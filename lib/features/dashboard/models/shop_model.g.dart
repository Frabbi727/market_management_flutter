// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopModel _$ShopModelFromJson(Map<String, dynamic> json) => ShopModel(
  id: (json['id'] as num?)?.toInt(),
  shopNumber: (json['shop_number'] as num?)?.toInt(),
  code: json['code'] as String?,
  shopName: json['shop_name'] as String?,
  market: json['market'] as String?,
  floor: (json['floor'] as num?)?.toInt(),
  side: json['side'] as String?,
  location: json['location'] as String?,
  locationNo: json['location_no'] as String?,
  registrationNo: json['registration_no'] as String?,
  areaSqft: (json['area_sqft'] as num?)?.toDouble(),
  ownerName: json['owner_name'] as String?,
  ownerPhone: json['owner_phone'] as String?,
  remarks: json['remarks'] as String?,
  active: json['active'] as bool?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ShopModelToJson(ShopModel instance) => <String, dynamic>{
  'id': instance.id,
  'shop_number': instance.shopNumber,
  'code': instance.code,
  'shop_name': instance.shopName,
  'market': instance.market,
  'floor': instance.floor,
  'side': instance.side,
  'location': instance.location,
  'location_no': instance.locationNo,
  'registration_no': instance.registrationNo,
  'area_sqft': instance.areaSqft,
  'owner_name': instance.ownerName,
  'owner_phone': instance.ownerPhone,
  'remarks': instance.remarks,
  'active': instance.active,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
