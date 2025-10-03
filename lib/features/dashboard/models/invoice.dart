
import 'package:json_annotation/json_annotation.dart';
part 'invoice.g.dart';
@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.none)
class Invoice {
  List<Content>? content;
  int? pageNumber;
  int? pageSize;
  int? totalElements;
  int? totalPages;

  Invoice({
    this.content,
    this.pageNumber,
    this.pageSize,
    this.totalElements,
    this.totalPages,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceToJson(this);

  @override
  String toString() {
    return 'Invoice{content: $content, pageNumber: $pageNumber, pageSize: $pageSize, totalElements: $totalElements, totalPages: $totalPages}';
  }
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.none)
class Content {
  int? invoiceId;
  String? shopCode;
  String? shopName;
  int? electricityAmount;
  double? acAmount;
  double? serviceAmount;
  double? total;
  String? status;
  bool? locked;
  bool? hasOverride;

  Content({
    this.invoiceId,
    this.shopCode,
    this.shopName,
    this.electricityAmount,
    this.acAmount,
    this.serviceAmount,
    this.total,
    this.status,
    this.locked,
    this.hasOverride,
  });
  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);

  @override
  String toString() {
    return 'Content{invoiceId: $invoiceId, shopCode: $shopCode, shopName: $shopName, electricityAmount: $electricityAmount, acAmount: $acAmount, serviceAmount: $serviceAmount, total: $total, status: $status, locked: $locked, hasOverride: $hasOverride}';
  }
}
