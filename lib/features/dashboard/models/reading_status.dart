
import 'package:json_annotation/json_annotation.dart';
part 'reading_status.g.dart';
@JsonSerializable(explicitToJson: true,fieldRename: FieldRename.none)

class ReadingStatus {
  String? shopCode;
  String? shopName;
  String? meterNumber;
  int? prevReading;
  int? currReading;
  int? units;
  bool? missing;

  ReadingStatus({
    this.shopCode,
    this.shopName,
    this.meterNumber,
    this.prevReading,
    this.currReading,
    this.units,
    this.missing,
  });
  factory ReadingStatus.fromJson(Map<String, dynamic> json) =>
      _$ReadingStatusFromJson(json);

  Map<String, dynamic> toJson() => _$ReadingStatusToJson(this);

  static List<ReadingStatus> listFromJson(List<dynamic> list) =>
      List<ReadingStatus>.from(list.map((x) => ReadingStatus.fromJson(x)));

  @override
  String toString() {
    return 'ReadingStatus{shopCode: $shopCode, shopName: $shopName, meterNumber: $meterNumber, prevReading: $prevReading, currReading: $currReading, units: $units, missing: $missing}';
  }
}
