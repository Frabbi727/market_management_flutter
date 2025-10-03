// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => Invoice(
  content: (json['content'] as List<dynamic>?)
      ?.map((e) => Content.fromJson(e as Map<String, dynamic>))
      .toList(),
  pageNumber: (json['page_number'] as num?)?.toInt(),
  pageSize: (json['page_size'] as num?)?.toInt(),
  totalElements: (json['total_elements'] as num?)?.toInt(),
  totalPages: (json['total_pages'] as num?)?.toInt(),
);

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
  'content': instance.content?.map((e) => e.toJson()).toList(),
  'page_number': instance.pageNumber,
  'page_size': instance.pageSize,
  'total_elements': instance.totalElements,
  'total_pages': instance.totalPages,
};

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
  invoiceId: (json['invoice_id'] as num?)?.toInt(),
  shopCode: json['shop_code'] as String?,
  shopName: json['shop_name'] as String?,
  electricityAmount: (json['electricity_amount'] as num?)?.toInt(),
  acAmount: (json['ac_amount'] as num?)?.toDouble(),
  serviceAmount: (json['service_amount'] as num?)?.toDouble(),
  total: (json['total'] as num?)?.toDouble(),
  status: json['status'] as String?,
  locked: json['locked'] as bool?,
  hasOverride: json['has_override'] as bool?,
);

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
  'invoice_id': instance.invoiceId,
  'shop_code': instance.shopCode,
  'shop_name': instance.shopName,
  'electricity_amount': instance.electricityAmount,
  'ac_amount': instance.acAmount,
  'service_amount': instance.serviceAmount,
  'total': instance.total,
  'status': instance.status,
  'locked': instance.locked,
  'has_override': instance.hasOverride,
};
