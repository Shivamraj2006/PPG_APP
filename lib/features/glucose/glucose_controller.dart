import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:usb_serial/usb_serial.dart';
import '../../core/ml/tflite_service.dart';
import '../../core/ml/dsp_utils.dart';

class NormalizationConfig {
  final List<double> xMean;
  final List<double> xStd;
  final double yMean;
  final double yStd;

  NormalizationConfig({
    required this.xMean,
    required this.xStd,
    required this.yMean,
    required this.yStd,
  });

  static Future<NormalizationConfig> loadFromAsset(String path) async {
    try {
      final String jsonString = await rootBundle.loadString(path);
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      
      return NormalizationConfig(
        xMean: List<double>.from(jsonMap['x_mean'].map((x) => (x as num).toDouble())),
        xStd: List<double>.from(jsonMap['x_std'].map((x) => (x as num).toDouble())),
        yMean: (jsonMap['y_mean'] as num).toDouble(),
        yStd: (jsonMap['y_std'] as num).toDouble(),
      );
    } catch (e) {
      print('Warning: Normalization config not found or invalid at $path. Using default (0 mean, 1 std). $e');
      return NormalizationConfig(
        xMean: List.filled(5, 0.0), // Assuming 5 features
        xStd: List.filled(5, 1.0),
        yMean: 0.0,
        yStd: 1.0,
      );
    }
  }
}

class GlucoseController extends ChangeNotifier {
  final TFLiteService _tfliteService = TFLiteService();
  NormalizationConfig? _normConfig;

  UsbPort? _port;
  StreamSubscription<Uint8List>? _subscription;
  String _buffer = "";

  String status = "Initializing...";
  bool isConnected = false;

  // Real-time data for UI (downsampled or limited for graph if needed)
  List<double> latestIrData = [];
  List<double> latestRedData = [];
  double? currentGlucose;
  double signalQuality = 0.0;
  
  int secondsLeft = 60;
  String phase = "Connecting"; // Connecting, Collecting, Processing, Complete, Timeout
  bool hasData = false;
  Timer? _countdownTimer;

  // Raw data collection: 1500 samples (60s @ 25Hz)
  final int targetSamples = 1500;
  final List<double> _rawIr = [];
  final List<double> _rawRed = [];

  GlucoseController() {
    _init();
  }

  Future<void> _init() async {
    await _tfliteService.init();
    _normConfig = await NormalizationConfig.loadFromAsset('assets/model/norm.json');
    
    status = "Waiting for USB device...";
    phase = "Connecting";
    notifyListeners();

    UsbSerial.usbEventStream!.listen((UsbEvent event) {
      if (event.event == UsbEvent.ACTION_USB_ATTACHED) {
        _connectToFirstAvailable();
      } else if (event.event == UsbEvent.ACTION_USB_DETACHED) {
        _disconnect();
      }
    });
    _connectToFirstAvailable();
  }

  Future<void> _connectToFirstAvailable() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (devices.isNotEmpty) {
      await _connectTo(devices.first);
    } else {
      status = "No USB devices found.";
      phase = "NoDevice";
      notifyListeners();
    }
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft > 0) {
        secondsLeft--;
        notifyListeners();
      } else {
        timer.cancel();
        _finishCollection();
      }
    });
  }

  Future<bool> _connectTo(UsbDevice device) async {
    _disconnect();

    _port = await device.create();
    if (await (_port!.open()) != true) {
      status = "Failed to open port";
      notifyListeners();
      return false;
    }

    await _port!.setDTR(true);
    await _port!.setRTS(true);
    await _port!.setPortParameters(115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    if (_port!.inputStream != null) {
      _subscription = _port!.inputStream!.listen(_onSerialData);
    }

    status = "Connected! Streaming Data...";
    phase = "Collecting";
    isConnected = true;
    notifyListeners();
    _startTimer();
    return true;
  }

  void _onSerialData(Uint8List data) {
    if (phase != "Collecting") return;
    
    _buffer += String.fromCharCodes(data);
    while (_buffer.contains('\n')) {
      int index = _buffer.indexOf('\n');
      String line = _buffer.substring(0, index).trim();
      _buffer = _buffer.substring(index + 1);
      _parseLine(line);
    }
  }

  void _parseLine(String line) {
    if (line.startsWith('(') && line.endsWith(')')) {
      line = line.substring(1, line.length - 1);
    }
    
    List<String> parts = line.split(',');
    if (parts.length >= 2) {
      try {
        double ir = double.parse(parts[0].trim());
        double red = double.parse(parts[1].trim());
        hasData = true;

        if (_rawIr.length < targetSamples) {
          _rawIr.add(ir);
          _rawRed.add(red);

          // Update UI array (keep last 100 for graph)
          latestIrData.add(ir);
          latestRedData.add(red);
          if (latestIrData.length > 100) {
            latestIrData.removeAt(0);
            latestRedData.removeAt(0);
          }

          notifyListeners();
        }
        
        // Auto-finish if we reached the required samples before timeout
        if (_rawIr.length == targetSamples) {
          _countdownTimer?.cancel();
          _finishCollection();
        }
      } catch (e) {
        // Parse error, ignore line
      }
    }
  }

  Future<void> _finishCollection() async {
    if (!hasData || _rawIr.isEmpty) {
      phase = "Timeout";
      status = "Collection Timeout / No Data";
      notifyListeners();
      return;
    }

    phase = "Processing";
    status = "Processing Signal...";
    notifyListeners();

    try {
      await _processSignalAndPredict();
      phase = "Complete";
      status = "Done";
    } catch (e) {
      phase = "Error";
      status = "Processing Failed: $e";
      print(e);
    }

    notifyListeners();
  }

  Future<void> _processSignalAndPredict() async {
    // We do the heavy processing potentially in an isolate, but for 1500 samples it's very fast.
    // 1. Bandpass filter
    List<double> filteredIr = DspUtils.filtfilt(_rawIr);
    List<double> filteredRed = DspUtils.filtfilt(_rawRed);

    // 2. DC removal
    List<double> cleanIr = DspUtils.removeDC(filteredIr);
    List<double> cleanRed = DspUtils.removeDC(filteredRed);

    // 3. Window Segmentation
    const int windowSize = 250;
    const int stepSize = 125;
    
    List<List<List<double>>> modelInputWindows = [];
    
    for (int start = 0; start <= cleanIr.length - windowSize; start += stepSize) {
      int end = start + windowSize;
      List<double> segIr = cleanIr.sublist(start, end);
      List<double> segRed = cleanRed.sublist(start, end);

      // 4. Feature Engineering
      List<double> ratio = List.generate(windowSize, (i) => segIr[i] / (segRed[i] + 1e-6));
      List<double> velocity = DspUtils.gradient(segIr);
      List<double> acceleration = DspUtils.gradient(velocity);

      // Construct tensor [250, 5]
      List<List<double>> windowFeatures = [];
      bool hasInvalid = false;

      for (int i = 0; i < windowSize; i++) {
        List<double> timestep = [
          segIr[i],
          segRed[i],
          ratio[i],
          velocity[i],
          acceleration[i],
        ];

        // 5. Invalid value check
        if (timestep.any((v) => v.isNaN || v.isInfinite)) {
          hasInvalid = true;
          break;
        }

        // 6. Normalization
        if (_normConfig != null) {
          for (int f = 0; f < 5; f++) {
            timestep[f] = (timestep[f] - _normConfig!.xMean[f]) / (_normConfig!.xStd[f] + 1e-8);
          }
        }
        
        windowFeatures.add(timestep);
      }

      if (!hasInvalid) {
        modelInputWindows.add(windowFeatures);
      }
    }

    if (modelInputWindows.isEmpty) {
      throw Exception("No valid windows found after preprocessing.");
    }

    // 7. TFLite inference
    List<double> rawPreds = await _tfliteService.predictBatch(modelInputWindows);

    // 8. Output Denormalization
    List<double> denormPreds = rawPreds.map((p) => p * _normConfig!.yStd + _normConfig!.yMean).toList();

    // 9. Final Glucose Estimation (IQR-filtered mean)
    currentGlucose = _calculateIQRMean(denormPreds);
    print("Final Estimated Glucose: $currentGlucose");
  }

  double _calculateIQRMean(List<double> preds) {
    if (preds.isEmpty) return 0.0;
    if (preds.length < 4) {
      return preds.reduce((a, b) => a + b) / preds.length;
    }

    List<double> sorted = List.from(preds)..sort();
    
    // Percentile 25 and 75
    int q1Index = (sorted.length * 0.25).floor();
    int q3Index = (sorted.length * 0.75).floor();
    
    double q1 = sorted[q1Index];
    double q3 = sorted[q3Index];

    List<double> filtered = preds.where((p) => p >= q1 && p <= q3).toList();
    if (filtered.isEmpty) {
      return preds.reduce((a, b) => a + b) / preds.length;
    }

    return filtered.reduce((a, b) => a + b) / filtered.length;
  }

  void _disconnect() {
    _subscription?.cancel();
    _port?.close();
    _port = null;
    isConnected = false;
    if (phase == "Connecting" || phase == "Collecting") {
      status = "Disconnected";
    }
    _rawIr.clear();
    _rawRed.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _disconnect();
    _tfliteService.dispose();
    super.dispose();
  }
}
