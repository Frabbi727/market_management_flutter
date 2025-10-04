

import 'package:json_annotation/json_annotation.dart';
part 'shop_model.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.none,
)
class ShopModel {
  int? id;
  int? shopNumber;
  String? code;
  String? shopName;

  @JsonKey(
    fromJson: _marketFromJson,
    toJson: _marketToJson,
  )
  String? market;

  int? floor;
  String? side;
  String? location;
  String? locationNo;
  String? registrationNo;
  double? areaSqft;
  String? ownerName;
  String? ownerPhone;
  String? remarks;
  bool? active;
  DateTime? createdAt;
  DateTime? updatedAt;

  ShopModel({
    this.id,
    this.shopNumber,
    this.code,
    this.shopName,
    this.market,
    this.floor,
    this.side,
    this.location,
    this.locationNo,
    this.registrationNo,
    this.areaSqft,
    this.ownerName,
    this.ownerPhone,
    this.remarks,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  static String? _marketFromJson(dynamic json) {
    if (json is String) {
      return json;
    } else if (json is Map) {
      return json['name'] as String?;
    }
    return null;
  }

  static dynamic _marketToJson(String? market) => market;

  factory ShopModel.fromJson(Map<String, dynamic> json) =>
      _$ShopModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopModelToJson(this);

  @override
  String toString() {
    return 'ShopModel{id: $id, shopNumber: $shopNumber, code: $code, shopName: $shopName, market: $market, floor: $floor, side: $side, location: $location, locationNo: $locationNo, registrationNo: $registrationNo, areaSqft: $areaSqft, ownerName: $ownerName, ownerPhone: $ownerPhone, remarks: $remarks, active: $active, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
