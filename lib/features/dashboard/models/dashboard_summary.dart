import 'package:json_annotation/json_annotation.dart';

part 'dashboard_summary.g.dart';

@JsonSerializable()
class DashboardSummary {
  final double? totalElectricityUnits;
  final double? totalElectricityAmount;
  final double? totalAcCost;
  final double? totalServiceCost;
  final double? totalInvoicesAmount;
  final int? paidInvoicesCount;
  final int? unpaidInvoicesCount;

  DashboardSummary({
     this.totalElectricityUnits,
     this.totalElectricityAmount,
     this.totalAcCost,
     this.totalServiceCost,
     this.totalInvoicesAmount,
     this.paidInvoicesCount,
     this.unpaidInvoicesCount,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardSummaryToJson(this);
}