// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => Invoice(
  content: (json['content'] as List<dynamic>?)
      ?.map((e) => Content.fromJson(e as Map<String, dynamic>))
      .toList(),
  pageNumber: (json['pageNumber'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
  totalElements: (json['totalElements'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
);

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
  'content': instance.content?.map((e) => e.toJson()).toList(),
  'pageNumber': instance.pageNumber,
  'pageSize': instance.pageSize,
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
};

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
  invoiceId: (json['invoiceId'] as num?)?.toInt(),
  shopCode: json['shopCode'] as String?,
  shopName: json['shopName'] as String?,
  electricityAmount: (json['electricityAmount'] as num?)?.toInt(),
  acAmount: (json['acAmount'] as num?)?.toDouble(),
  serviceAmount: (json['serviceAmount'] as num?)?.toDouble(),
  total: (json['total'] as num?)?.toDouble(),
  status: json['status'] as String?,
  locked: json['locked'] as bool?,
  hasOverride: json['hasOverride'] as bool?,
);

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
  'invoiceId': instance.invoiceId,
  'shopCode': instance.shopCode,
  'shopName': instance.shopName,
  'electricityAmount': instance.electricityAmount,
  'acAmount': instance.acAmount,
  'serviceAmount': instance.serviceAmount,
  'total': instance.total,
  'status': instance.status,
  'locked': instance.locked,
  'hasOverride': instance.hasOverride,
};
