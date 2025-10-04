// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_reading_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopReadingModel _$ShopReadingModelFromJson(Map<String, dynamic> json) =>
    ShopReadingModel(
      id: (json['id'] as num?)?.toInt(),
      meterId: (json['meterId'] as num?)?.toInt(),
      meterSerial: json['meterSerial'] as String?,
      period: json['period'] as String?,
      prevReading: (json['prevReading'] as num?)?.toInt(),
      currReading: (json['currReading'] as num?)?.toInt(),
      units: (json['units'] as num?)?.toInt(),
      missing: json['missing'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ShopReadingModelToJson(ShopReadingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'meterId': instance.meterId,
      'meterSerial': instance.meterSerial,
      'period': instance.period,
      'prevReading': instance.prevReading,
      'currReading': instance.currReading,
      'units': instance.units,
      'missing': instance.missing,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
