import 'package:json_annotation/json_annotation.dart';

part 'shop_reading_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.none)
class ShopReadingModel {
  int? id;
  int? meterId;
  String? meterSerial;
  String? period; // YYYY-MM-DD format
  int? prevReading;
  int? currReading;
  int? units;
  bool? missing;
  DateTime? createdAt;
  DateTime? updatedAt;

  ShopReadingModel({
    this.id,
    this.meterId,
    this.meterSerial,
    this.period,
    this.prevReading,
    this.currReading,
    this.units,
    this.missing,
    this.createdAt,
    this.updatedAt,
  });

  factory ShopReadingModel.fromJson(Map<String, dynamic> json) =>
      _$ShopReadingModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopReadingModelToJson(this);

  @override
  String toString() {
    return 'ShopReadingModel{id: $id, meterId: $meterId, meterSerial: $meterSerial, period: $period, prevReading: $prevReading, currReading: $currReading, units: $units, missing: $missing, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}