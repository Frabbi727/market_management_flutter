// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeterModel _$MeterModelFromJson(Map<String, dynamic> json) => MeterModel(
  id: (json['id'] as num?)?.toInt(),
  shopId: (json['shopId'] as num?)?.toInt(),
  serialNumber: json['serialNumber'] as String?,
  utility: json['utility'] as String?,
  multiplier: (json['multiplier'] as num?)?.toDouble(),
  active: json['active'] as bool?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$MeterModelToJson(MeterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shopId': instance.shopId,
      'serialNumber': instance.serialNumber,
      'utility': instance.utility,
      'multiplier': instance.multiplier,
      'active': instance.active,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
