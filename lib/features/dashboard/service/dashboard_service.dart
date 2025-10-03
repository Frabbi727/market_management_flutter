import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../models/dashboard_summary.dart';
import '../models/shop_model.dart';
import '../models/invoice.dart';
import '../models/reading_status.dart';
import 'dart:developer' as developer;

class DashboardService {
  final DioClient _dioClient;

  DashboardService(this._dioClient);

  Future<DashBoardSummary> getDashboardSummary({
    required int marketId,
    required String period,
  }) async {
    try {
      developer.log(
        'Fetching dashboard summary for marketId: $marketId, period: $period',
        name: 'DashboardService',
      );

      final response = await _dioClient.get(
        ApiConstants.reportsSummary,
        queryParameters: {'marketId': marketId, 'period': period},
      );

      developer.log(
        '✅ Successfully fetched dashboard summary',
        name: 'DashboardService',
      );

      return DashBoardSummary.fromJson(response.data);
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to load dashboard summary',
        name: 'DashboardService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
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

  Future<Invoice> getInvoices({
    required int marketId,
    required String period,
    int page = 0,
    int size = 20,
  }) async {
    try {
      developer.log(
        'Fetching invoices for marketId: $marketId, period: $period, page: $page, size: $size',
        name: 'DashboardService',
      );

      final response = await _dioClient.get(
        ApiConstants.invoices,
        queryParameters: {
          'marketId': marketId,
          'period': period,
          'page': page,
          'size': size,
        },
      );

      developer.log(
        '✅ Successfully fetched invoices',
        name: 'DashboardService',
      );

      return Invoice.fromJson(response.data);
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to load invoices',
        name: 'DashboardService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<List<ReadingStatus>> getReadingStatus({
    required int marketId,
    required String period,
  }) async {
    try {
      developer.log(
        'Fetching reading status for marketId: $marketId, period: $period',
        name: 'DashboardService',
      );

      final response = await _dioClient.get(
        ApiConstants.readingStatus,
        queryParameters: {'marketId': marketId, 'period': period},
      );

      developer.log(
        '✅ Successfully fetched reading status',
        name: 'DashboardService',
      );

      if (response.data is List) {
        return ReadingStatus.listFromJson(response.data as List);
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to load reading status',
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
