// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReadingStatus _$ReadingStatusFromJson(Map<String, dynamic> json) =>
    ReadingStatus(
      shopCode: json['shopCode'] as String?,
      shopName: json['shopName'] as String?,
      meterNumber: json['meterNumber'] as String?,
      prevReading: (json['prevReading'] as num?)?.toInt(),
      currReading: (json['currReading'] as num?)?.toInt(),
      units: (json['units'] as num?)?.toInt(),
      missing: json['missing'] as bool?,
    );

Map<String, dynamic> _$ReadingStatusToJson(ReadingStatus instance) =>
    <String, dynamic>{
      'shopCode': instance.shopCode,
      'shopName': instance.shopName,
      'meterNumber': instance.meterNumber,
      'prevReading': instance.prevReading,
      'currReading': instance.currReading,
      'units': instance.units,
      'missing': instance.missing,
    };
