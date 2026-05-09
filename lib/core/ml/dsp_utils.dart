import 'dart:math' as math;

class DspUtils {
  // Butterworth order 3, bandpass 0.7-3.5 Hz, fs=25
  static const List<double> _b = [
    0.024100207997821227,
    0.0,
    -0.07230062399346368,
    0.0,
    0.07230062399346368,
    0.0,
    -0.024100207997821227
  ];
  static const List<double> _a = [
    1.0,
    -4.247262208456783,
    7.776338082193026,
    -7.9319987071027525,
    4.7827450420604345,
    -1.6144506796554468,
    0.23660039107762815
  ];

  /// Forward-backward zero-phase filter (similar to scipy.signal.filtfilt).
  /// This applies the filter forward, reverses the signal, applies it again,
  /// and reverses it back.
  static List<double> filtfilt(List<double> x) {
    if (x.isEmpty) return [];
    
    // Forward filter
    List<double> yForward = lfilter(_b, _a, x);
    
    // Reverse the result
    List<double> yReversed = yForward.reversed.toList();
    
    // Forward filter again
    List<double> yBackward = lfilter(_b, _a, yReversed);
    
    // Reverse back to original orientation
    return yBackward.reversed.toList();
  }

  /// Linear digital filter (similar to scipy.signal.lfilter).
  static List<double> lfilter(List<double> b, List<double> a, List<double> x) {
    List<double> y = List.filled(x.length, 0.0);
    for (int i = 0; i < x.length; i++) {
      y[i] = b[0] * x[i];
      for (int j = 1; j < b.length; j++) {
        if (i - j >= 0) {
          y[i] += b[j] * x[i - j];
        }
      }
      for (int j = 1; j < a.length; j++) {
        if (i - j >= 0) {
          y[i] -= a[j] * y[i - j];
        }
      }
      y[i] /= a[0];
    }
    return y;
  }

  /// Removes DC component (subtracts the mean).
  static List<double> removeDC(List<double> signal) {
    if (signal.isEmpty) return [];
    double mean = signal.reduce((a, b) => a + b) / signal.length;
    return signal.map((val) => val - mean).toList();
  }

  /// Computes numerical gradient (similar to np.gradient).
  static List<double> gradient(List<double> y) {
    int n = y.length;
    List<double> grad = List.filled(n, 0.0);
    if (n < 2) return grad;
    
    grad[0] = y[1] - y[0];
    grad[n - 1] = y[n - 1] - y[n - 2];
    for (int i = 1; i < n - 1; i++) {
      grad[i] = (y[i + 1] - y[i - 1]) / 2.0;
    }
    return grad;
  }
}
