// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopModel _$ShopModelFromJson(Map<String, dynamic> json) => ShopModel(
  id: (json['id'] as num?)?.toInt(),
  shopNumber: (json['shopNumber'] as num?)?.toInt(),
  code: json['code'] as String?,
  shopName: json['shopName'] as String?,
  market: json['market'] as String?,
  floor: (json['floor'] as num?)?.toInt(),
  side: json['side'] as String?,
  location: json['location'] as String?,
  locationNo: json['locationNo'] as String?,
  registrationNo: json['registrationNo'] as String?,
  areaSqft: (json['areaSqft'] as num?)?.toDouble(),
  ownerName: json['ownerName'] as String?,
  ownerPhone: json['ownerPhone'] as String?,
  remarks: json['remarks'] as String?,
  active: json['active'] as bool?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ShopModelToJson(ShopModel instance) => <String, dynamic>{
  'id': instance.id,
  'shopNumber': instance.shopNumber,
  'code': instance.code,
  'shopName': instance.shopName,
  'market': instance.market,
  'floor': instance.floor,
  'side': instance.side,
  'location': instance.location,
  'locationNo': instance.locationNo,
  'registrationNo': instance.registrationNo,
  'areaSqft': instance.areaSqft,
  'ownerName': instance.ownerName,
  'ownerPhone': instance.ownerPhone,
  'remarks': instance.remarks,
  'active': instance.active,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
