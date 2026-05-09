class SmoothingService {
  final double alpha;
  double? _previous;

  SmoothingService({this.alpha = 0.2});

  double smooth(double current) {
    if (_previous == null) {
      _previous = current;
      return current;
    }
    double smoothed = alpha * current + (1 - alpha) * _previous!;
    _previous = smoothed;
    return smoothed;
  }

  void reset() {
    _previous = null;
  }
}
