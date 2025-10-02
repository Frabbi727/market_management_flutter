// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardSummary _$DashboardSummaryFromJson(
  Map<String, dynamic> json,
) => DashboardSummary(
  totalElectricityUnits: (json['total_electricity_units'] as num).toDouble(),
  totalElectricityAmount: (json['total_electricity_amount'] as num).toDouble(),
  totalAcCost: (json['total_ac_cost'] as num).toDouble(),
  totalServiceCost: (json['total_service_cost'] as num).toDouble(),
  totalInvoicesAmount: (json['total_invoices_amount'] as num).toDouble(),
  paidInvoicesCount: (json['paid_invoices_count'] as num).toInt(),
  unpaidInvoicesCount: (json['unpaid_invoices_count'] as num).toInt(),
);

Map<String, dynamic> _$DashboardSummaryToJson(DashboardSummary instance) =>
    <String, dynamic>{
      'total_electricity_units': instance.totalElectricityUnits,
      'total_electricity_amount': instance.totalElectricityAmount,
      'total_ac_cost': instance.totalAcCost,
      'total_service_cost': instance.totalServiceCost,
      'total_invoices_amount': instance.totalInvoicesAmount,
      'paid_invoices_count': instance.paidInvoicesCount,
      'unpaid_invoices_count': instance.unpaidInvoicesCount,
    };
