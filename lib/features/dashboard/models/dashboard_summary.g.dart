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
  inputsOk: json['inputsOk'] as bool?,
  missingReadingsCount: (json['missingReadingsCount'] as num?)?.toInt(),
  tariffOk: json['tariffOk'] as bool?,
  unlockedInvoicesCount: (json['unlockedInvoicesCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$HealthToJson(Health instance) => <String, dynamic>{
  'inputsOk': instance.inputsOk,
  'missingReadingsCount': instance.missingReadingsCount,
  'tariffOk': instance.tariffOk,
  'unlockedInvoicesCount': instance.unlockedInvoicesCount,
};

Inputs _$InputsFromJson(Map<String, dynamic> json) => Inputs(
  acTotalUnits: (json['acTotalUnits'] as num?)?.toDouble(),
  acUnitPrice: (json['acUnitPrice'] as num?)?.toDouble(),
  acPerSqftRate: (json['acPerSqftRate'] as num?)?.toDouble(),
  guardCost: (json['guardCost'] as num?)?.toDouble(),
  maidCost: (json['maidCost'] as num?)?.toDouble(),
  otherCost: (json['otherCost'] as num?)?.toDouble(),
  servicePerSqftRate: (json['servicePerSqftRate'] as num?)?.toDouble(),
  marketTotalSqft: (json['marketTotalSqft'] as num?)?.toDouble(),
);

Map<String, dynamic> _$InputsToJson(Inputs instance) => <String, dynamic>{
  'acTotalUnits': instance.acTotalUnits,
  'acUnitPrice': instance.acUnitPrice,
  'acPerSqftRate': instance.acPerSqftRate,
  'guardCost': instance.guardCost,
  'maidCost': instance.maidCost,
  'otherCost': instance.otherCost,
  'servicePerSqftRate': instance.servicePerSqftRate,
  'marketTotalSqft': instance.marketTotalSqft,
};

Kpis _$KpisFromJson(Map<String, dynamic> json) => Kpis(
  invoiceCount: (json['invoiceCount'] as num?)?.toInt(),
  totalAmount: (json['totalAmount'] as num?)?.toDouble(),
  electricityUnits: (json['electricityUnits'] as num?)?.toDouble(),
  electricityAmount: (json['electricityAmount'] as num?)?.toDouble(),
  acCost: (json['acCost'] as num?)?.toDouble(),
  serviceCost: (json['serviceCost'] as num?)?.toDouble(),
);

Map<String, dynamic> _$KpisToJson(Kpis instance) => <String, dynamic>{
  'invoiceCount': instance.invoiceCount,
  'totalAmount': instance.totalAmount,
  'electricityUnits': instance.electricityUnits,
  'electricityAmount': instance.electricityAmount,
  'acCost': instance.acCost,
  'serviceCost': instance.serviceCost,
};
