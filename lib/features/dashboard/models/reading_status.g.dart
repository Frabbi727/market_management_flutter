// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReadingStatus _$ReadingStatusFromJson(Map<String, dynamic> json) =>
    ReadingStatus(
      shopCode: json['shop_code'] as String?,
      shopName: json['shop_name'] as String?,
      meterNumber: json['meter_number'] as String?,
      prevReading: (json['prev_reading'] as num?)?.toInt(),
      currReading: (json['curr_reading'] as num?)?.toInt(),
      units: (json['units'] as num?)?.toInt(),
      missing: json['missing'] as bool?,
    );

Map<String, dynamic> _$ReadingStatusToJson(ReadingStatus instance) =>
    <String, dynamic>{
      'shop_code': instance.shopCode,
      'shop_name': instance.shopName,
      'meter_number': instance.meterNumber,
      'prev_reading': instance.prevReading,
      'curr_reading': instance.currReading,
      'units': instance.units,
      'missing': instance.missing,
    };
