class CalibrationService {
  static const double a1 = 1.6503386722953322;
  static const double b1 = -59.872868969996944;

  static const double a2 = 1.1580773841646261;
  static const double b2 = -13.990054064331321;

  static double smoothPiecewise(
    double x,
    double a1,
    double b1,
    double a2,
    double b2, {
    double threshold = 90,
    double width = 10,
  }) {
    if (x < threshold - width) {
      return a1 * x + b1;
    } else if (x > threshold + width) {
      return a2 * x + b2;
    } else {
      double w = (x - (threshold - width)) / (2 * width);
      double low = a1 * x + b1;
      double high = a2 * x + b2;
      return (1 - w) * low + w * high;
    }
  }

  static double calibrate(double rawPrediction) {
    double calibrated = smoothPiecewise(rawPrediction, a1, b1, a2, b2);
    // Apply final clipping
    double finalGlucose = calibrated.clamp(
      rawPrediction - 30,
      rawPrediction + 30,
    );
    return finalGlucose;
  }
}
