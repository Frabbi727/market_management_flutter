





class CostBreakdown {
  final double electricity;
  final double ac;
  final double service;

  const CostBreakdown({
    required this.electricity,
    required this.ac,
    required this.service,
  });

  double get total => electricity + ac + service;

  double shareOf(double value) {
    if (total <= 0) {
      return 0;
    }
    return value / total;
  }
}
