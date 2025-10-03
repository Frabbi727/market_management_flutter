import 'package:json_annotation/json_annotation.dart';

part 'dashboard_summary.g.dart';

@JsonSerializable(explicitToJson: true)
class DashBoardSummary {
  Kpis? kpis;
  Health? health;
  Inputs? inputs;

  DashBoardSummary({this.kpis, this.health, this.inputs});

  factory DashBoardSummary.fromJson(Map<String, dynamic> json) =>
      _$DashBoardSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$DashBoardSummaryToJson(this);

  @override
  String toString() {
    return 'DashBoardSummary{kpis: $kpis, health: $health, inputs: $inputs}';
  }
}

@JsonSerializable(explicitToJson: true)
class Health {
  bool? inputsOk;
  int? missingReadingsCount;
  bool? tariffOk;
  int? unlockedInvoicesCount;

  Health({
    this.inputsOk,
    this.missingReadingsCount,
    this.tariffOk,
    this.unlockedInvoicesCount,
  });

  factory Health.fromJson(Map<String, dynamic> json) => _$HealthFromJson(json);

  Map<String, dynamic> toJson() => _$HealthToJson(this);

  @override
  String toString() {
    return 'Health{inputsOk: $inputsOk, missingReadingsCount: $missingReadingsCount, tariffOk: $tariffOk, unlockedInvoicesCount: $unlockedInvoicesCount}';
  }
}

@JsonSerializable(explicitToJson: true)
class Inputs {
  double? acTotalUnits;
  double? acUnitPrice;
  double? acPerSqftRate;
  double? guardCost;
  double? maidCost;
  double? otherCost;
  double? servicePerSqftRate;
  double? marketTotalSqft;

  Inputs({
    this.acTotalUnits,
    this.acUnitPrice,
    this.acPerSqftRate,
    this.guardCost,
    this.maidCost,
    this.otherCost,
    this.servicePerSqftRate,
    this.marketTotalSqft,
  });

  factory Inputs.fromJson(Map<String, dynamic> json) => _$InputsFromJson(json);

  Map<String, dynamic> toJson() => _$InputsToJson(this);

  @override
  String toString() {
    return 'Inputs{acTotalUnits: $acTotalUnits, acUnitPrice: $acUnitPrice, acPerSqftRate: $acPerSqftRate, guardCost: $guardCost, maidCost: $maidCost, otherCost: $otherCost, servicePerSqftRate: $servicePerSqftRate, marketTotalSqft: $marketTotalSqft}';
  }
}

@JsonSerializable(explicitToJson: true)
class Kpis {
  int? invoiceCount;
  double? totalAmount;
  double? electricityUnits;
  double? electricityAmount;
  double? acCost;
  double? serviceCost;

  Kpis({
    this.invoiceCount,
    this.totalAmount,
    this.electricityUnits,
    this.electricityAmount,
    this.acCost,
    this.serviceCost,
  });

  factory Kpis.fromJson(Map<String, dynamic> json) => _$KpisFromJson(json);

  Map<String, dynamic> toJson() => _$KpisToJson(this);

  @override
  String toString() {
    return 'Kpis{invoiceCount: $invoiceCount, totalAmount: $totalAmount, electricityUnits: $electricityUnits, electricityAmount: $electricityAmount, acCost: $acCost, serviceCost: $serviceCost}';
  }
}
