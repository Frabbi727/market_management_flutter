// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashBoardSummary _$DashBoardSummaryFromJson(Map<String, dynamic> json) =>
    DashBoardSummary(
      kpis: json['kpis'] == null
          ? null
          : Kpis.fromJson(json['kpis'] as Map<String, dynamic>),
      health: json['health'] == null
          ? null
          : Health.fromJson(json['health'] as Map<String, dynamic>),
      inputs: json['inputs'] == null
          ? null
          : Inputs.fromJson(json['inputs'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DashBoardSummaryToJson(DashBoardSummary instance) =>
    <String, dynamic>{
      'kpis': instance.kpis?.toJson(),
      'health': instance.health?.toJson(),
      'inputs': instance.inputs?.toJson(),
    };

Health _$HealthFromJson(Map<String, dynamic> json) => Health(
  inputsOk: json['inputs_ok'] as bool?,
  missingReadingsCount: (json['missing_readings_count'] as num?)?.toInt(),
  tariffOk: json['tariff_ok'] as bool?,
  unlockedInvoicesCount: (json['unlocked_invoices_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$HealthToJson(Health instance) => <String, dynamic>{
  'inputs_ok': instance.inputsOk,
  'missing_readings_count': instance.missingReadingsCount,
  'tariff_ok': instance.tariffOk,
  'unlocked_invoices_count': instance.unlockedInvoicesCount,
};

Inputs _$InputsFromJson(Map<String, dynamic> json) => Inputs(
  acTotalUnits: (json['ac_total_units'] as num?)?.toDouble(),
  acUnitPrice: (json['ac_unit_price'] as num?)?.toDouble(),
  acPerSqftRate: (json['ac_per_sqft_rate'] as num?)?.toDouble(),
  guardCost: (json['guard_cost'] as num?)?.toDouble(),
  maidCost: (json['maid_cost'] as num?)?.toDouble(),
  otherCost: (json['other_cost'] as num?)?.toDouble(),
  servicePerSqftRate: (json['service_per_sqft_rate'] as num?)?.toDouble(),
  marketTotalSqft: (json['market_total_sqft'] as num?)?.toDouble(),
);

Map<String, dynamic> _$InputsToJson(Inputs instance) => <String, dynamic>{
  'ac_total_units': instance.acTotalUnits,
  'ac_unit_price': instance.acUnitPrice,
  'ac_per_sqft_rate': instance.acPerSqftRate,
  'guard_cost': instance.guardCost,
  'maid_cost': instance.maidCost,
  'other_cost': instance.otherCost,
  'service_per_sqft_rate': instance.servicePerSqftRate,
  'market_total_sqft': instance.marketTotalSqft,
};

Kpis _$KpisFromJson(Map<String, dynamic> json) => Kpis(
  invoiceCount: (json['invoice_count'] as num?)?.toInt(),
  totalAmount: (json['total_amount'] as num?)?.toDouble(),
  electricityUnits: (json['electricity_units'] as num?)?.toDouble(),
  electricityAmount: (json['electricity_amount'] as num?)?.toDouble(),
  acCost: (json['ac_cost'] as num?)?.toDouble(),
  serviceCost: (json['service_cost'] as num?)?.toDouble(),
);

Map<String, dynamic> _$KpisToJson(Kpis instance) => <String, dynamic>{
  'invoice_count': instance.invoiceCount,
  'total_amount': instance.totalAmount,
  'electricity_units': instance.electricityUnits,
  'electricity_amount': instance.electricityAmount,
  'ac_cost': instance.acCost,
  'service_cost': instance.serviceCost,
};
