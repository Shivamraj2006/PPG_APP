import 'dart:convert';
import 'package:flutter/services.dart';

class NormalizationService {
  List<double> xMean = [];
  List<double> xStd = [];
  double yMean = 0.0;
  double yStd = 1.0;

  Future<void> load() async {
    xMean = await _loadList('assets/normalization/x_mean.json');
    xStd = await _loadList('assets/normalization/x_std.json');
    List<double> yM = await _loadList('assets/normalization/y_mean.json');
    List<double> yS = await _loadList('assets/normalization/y_std.json');
    yMean = yM.isNotEmpty ? yM.first : 0.0;
    yStd = yS.isNotEmpty ? yS.first : 1.0;
  }

  Future<List<double>> _loadList(String path) async {
    try {
      final String response = await rootBundle.loadString(path);
      final List<dynamic> data = json.decode(response);
      return data.map((e) => (e as num).toDouble()).toList();
    } catch (e) {
      print('Error loading $path: $e');
      // Fallback
      return [0.0];
    }
  }

  // Normalize a window of shape (100, 3)
  List<List<double>> normalizeX(List<List<double>> window) {
    if (xMean.isEmpty || xStd.isEmpty) return window;
    
    // We assume xMean and xStd might be length 3 (one for each channel)
    // or length 1 (if the same across all). We'll handle both.
    return window.map((sample) {
      return sample.asMap().entries.map((entry) {
        int c = entry.key;
        double val = entry.value;
        double m = (xMean.length > c) ? xMean[c] : xMean.first;
        double s = (xStd.length > c) ? xStd[c] : xStd.first;
        if (s == 0.0) s = 1.0; // avoid division by zero
        return (val - m) / s;
      }).toList();
    }).toList();
  }

  double denormalizeY(double prediction) {
    return prediction * yStd + yMean;
  }
}
