class DashboardHealthStatus {
  final bool inputsReady;
  final int missingReadings;
  final bool tariffReady;
  final int unlockedInvoices;

  const DashboardHealthStatus({
    required this.inputsReady,
    required this.missingReadings,
    required this.tariffReady,
    required this.unlockedInvoices,
  });

  bool get hasIssues => !inputsReady || !tariffReady || missingReadings > 0;

  bool get computeDisabled =>
      !inputsReady || !tariffReady || missingReadings > 0;
}

class DashboardInputsSnapshot {
  final double acTotalUnits;
  final double acUnitPrice;
  final double acRatePerSqft;
  final double guardCost;
  final double maidCost;
  final double otherCost;
  final double serviceRatePerSqft;
  final double marketTotalSqft;

  const DashboardInputsSnapshot({
    required this.acTotalUnits,
    required this.acUnitPrice,
    required this.acRatePerSqft,
    required this.guardCost,
    required this.maidCost,
    required this.otherCost,
    required this.serviceRatePerSqft,
    required this.marketTotalSqft,
  });
}

class DashboardInvoiceRow {
  final String shopCode;
  final String shopName;
  final double electricityAmount;
  final double acAmount;
  final double serviceAmount;
  final double totalAmount;
  final String status;
  final bool isLocked;
  final bool isOverridden;

  const DashboardInvoiceRow({
    required this.shopCode,
    required this.shopName,
    required this.electricityAmount,
    required this.acAmount,
    required this.serviceAmount,
    required this.totalAmount,
    required this.status,
    required this.isLocked,
    required this.isOverridden,
  });
}

class DashboardReadingRow {
  final String shopName;
  final String meterCode;
  final double previous;
  final double current;
  final double units;
  final bool isMissing;

  const DashboardReadingRow({
    required this.shopName,
    required this.meterCode,
    required this.previous,
    required this.current,
    required this.units,
    required this.isMissing,
  });
}

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
