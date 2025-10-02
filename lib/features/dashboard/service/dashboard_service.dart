import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../models/dashboard_summary.dart';
import '../models/shop_model.dart';
import 'dart:developer' as developer;

class DashboardService {
  final DioClient _dioClient;

  DashboardService(this._dioClient);

  Future<DashboardSummary> getDashboardSummary(String period) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.reportsSummary,
        queryParameters: {'period': period},
      );
      return DashboardSummary.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load dashboard summary: $e');
    }
  }

  Future<List<ShopModel>> getShops() async {

    try {

      final response = await _dioClient.get(ApiConstants.shops);


      if (response.data is List) {
        final shops = (response.data as List)
            .map((json) => ShopModel.fromJson(json as Map<String, dynamic>))
            .toList();


        return shops;
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to load shops',
        name: 'DashboardService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}

// Provider for DashboardService
final dashboardServiceProvider = Provider<DashboardService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return DashboardService(dioClient);
});