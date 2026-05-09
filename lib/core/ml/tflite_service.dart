import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';

class TFLiteService {
  Interpreter? _interpreter;

  Future<void> init() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model/model.tflite');
      print('Model loaded successfully');
      
      var inputTensors = _interpreter!.getInputTensors();
      var outputTensors = _interpreter!.getOutputTensors();
      print('Input Tensors: \${inputTensors.map((t) => t.shape)}');
      print('Output Tensors: \${outputTensors.map((t) => t.shape)}');
      
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  /// Predicts glucose for a single window of shape [250, 5].
  /// To pass multiple windows at once, the input shape should be [num_windows, 250, 5].
  /// Here we assume processing window by window or passing the whole array.
  Future<List<double>> predictBatch(List<List<List<double>>> windows) async {
    if (_interpreter == null || windows.isEmpty) return [];

    // The model expects [num_windows, 250, 5] of type float32.
    // TFLite Flutter works well with multi-dimensional lists, 
    // but flattening to Float32List is often safer and more efficient.
    
    int numWindows = windows.length;
    int windowSize = windows[0].length;
    int numFeatures = windows[0][0].length;
    
    // Create output tensor: [num_windows, 1] assuming single output per window
    var outputData = List.generate(numWindows, (_) => List.filled(1, 0.0));

    try {
      _interpreter!.run(windows, outputData);
      
      // Extract predictions
      return outputData.map((e) => e[0]).toList();
    } catch (e) {
      print('Inference error: $e');
      return [];
    }
  }

  void dispose() {
    _interpreter?.close();
  }
}
