import 'package:json_annotation/json_annotation.dart';

part 'meter_model.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.none,
)
class MeterModel {
  int? id;
  int? shopId;
  String? serialNumber;
  String? utility; // ELECTRICITY, GAS, WATER
  double? multiplier;
  bool? active;
  DateTime? createdAt;
  DateTime? updatedAt;

  MeterModel({
    this.id,
    this.shopId,
    this.serialNumber,
    this.utility,
    this.multiplier,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  factory MeterModel.fromJson(Map<String, dynamic> json) =>
      _$MeterModelFromJson(json);

  Map<String, dynamic> toJson() => _$MeterModelToJson(this);

  @override
  String toString() {
    return 'MeterModel{id: $id, shopId: $shopId, serialNumber: $serialNumber, utility: $utility, multiplier: $multiplier, active: $active, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}