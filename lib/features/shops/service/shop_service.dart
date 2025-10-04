import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../dashboard/models/shop_model.dart';
import '../models/meter_model.dart';
import '../models/shop_reading_model.dart';
import '../../dashboard/models/invoice.dart';
import 'dart:developer' as developer;

class ShopService {
  final DioClient _dioClient;

  ShopService(this._dioClient);

  // ============ SHOP CRUD ============

  Future<List<ShopModel>> getShops({
    String? search,
    int? marketId,
    int? floor,
    String? side,
    bool? active,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      developer.log(
        'Fetching shops with filters',
        name: 'ShopService',
      );

      final queryParams = <String, dynamic>{};
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (marketId != null) queryParams['marketId'] = marketId;
      if (floor != null) queryParams['floor'] = floor;
      if (side != null && side.isNotEmpty) queryParams['side'] = side;
      if (active != null) queryParams['active'] = active;
      if (sortBy != null) queryParams['sortBy'] = sortBy;
      if (sortOrder != null) queryParams['sortOrder'] = sortOrder;

      final response = await _dioClient.get(
        ApiConstants.shops,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      developer.log(
        '✅ Successfully fetched ${(response.data as List).length} shops',
        name: 'ShopService',
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) => ShopModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to load shops',
        name: 'ShopService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<ShopModel> getShopById(int id) async {
    try {
      developer.log('Fetching shop with id: $id', name: 'ShopService');

      final response = await _dioClient.get('${ApiConstants.shops}/$id');

      developer.log('✅ Successfully fetched shop', name: 'ShopService');

      return ShopModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to load shop',
        name: 'ShopService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<ShopModel> createShop(Map<String, dynamic> shopData) async {
    try {
      developer.log('Creating new shop', name: 'ShopService');

      final response = await _dioClient.post(
        ApiConstants.shops,
        data: shopData,
      );

      developer.log('✅ Successfully created shop', name: 'ShopService');

      return ShopModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to create shop',
        name: 'ShopService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<ShopModel> updateShop(int id, Map<String, dynamic> shopData) async {
    try {
      developer.log('Updating shop with id: $id', name: 'ShopService');

      final response = await _dioClient.put(
        '${ApiConstants.shops}/$id',
        data: shopData,
      );

      developer.log('✅ Successfully updated shop', name: 'ShopService');

      return ShopModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to update shop',
        name: 'ShopService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> deleteShop(int id) async {
    try {
      developer.log('Deleting shop with id: $id', name: 'ShopService');

      await _dioClient.delete('${ApiConstants.shops}/$id');

      developer.log('✅ Successfully deleted shop', name: 'ShopService');
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to delete shop',
        name: 'ShopService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> toggleShopActive(int id, bool active) async {
    try {
      developer.log(
        'Toggling shop active status: $id -> $active',
        name: 'ShopService',
      );

      await _dioClient.patch(
        '${ApiConstants.shops}/$id/active',
        data: {'active': active},
      );

      developer.log('✅ Successfully toggled shop status', name: 'ShopService');
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to toggle shop status',
        name: 'ShopService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // ============ METER CRUD ============

  Future<List<MeterModel>> getShopMeters(int shopId) async {
    try {
      developer.log(
        'Fetching meters for shop: $shopId',
        name: 'ShopService',
      );

      final response = await _dioClient.get(
        '${ApiConstants.shops}/$shopId/meters',
      );

      developer.log(
        '✅ Successfully fetched ${(response.data as List).length} meters',
        name: 'ShopService',
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) => MeterModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to load meters',
        name: 'ShopService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<MeterModel> createMeter(int shopId, Map<String, dynamic> meterData) async {
    try {
      developer.log('Creating meter for shop: $shopId', name: 'ShopService');

      final response = await _dioClient.post(
        '${ApiConstants.shops}/$shopId/meters',
        data: meterData,
      );

      developer.log('✅ Successfully created meter', name: 'ShopService');

      return MeterModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to create meter',
        name: 'ShopService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<MeterModel> updateMeter(
    int shopId,
    int meterId,
    Map<String, dynamic> meterData,
  ) async {
    try {
      developer.log('Updating meter: $meterId', name: 'ShopService');

      final response = await _dioClient.put(
        '${ApiConstants.shops}/$shopId/meters/$meterId',
        data: meterData,
      );

      developer.log('✅ Successfully updated meter', name: 'ShopService');

      return MeterModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to update meter',
        name: 'ShopService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> toggleMeterActive(int shopId, int meterId, bool active) async {
    try {
      developer.log(
        'Toggling meter active: $meterId -> $active',
        name: 'ShopService',
      );

      await _dioClient.patch(
        '${ApiConstants.shops}/$shopId/meters/$meterId/active',
        data: {'active': active},
      );

      developer.log('✅ Successfully toggled meter status', name: 'ShopService');
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to toggle meter status',
        name: 'ShopService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // ============ READINGS ============

  Future<List<ShopReadingModel>> getShopReadings({
    required int shopId,
    String? period,
  }) async {
    try {
      developer.log(
        'Fetching readings for shop: $shopId, period: $period',
        name: 'ShopService',
      );

      final queryParams = <String, dynamic>{};
      if (period != null) queryParams['period'] = period;

      final response = await _dioClient.get(
        '${ApiConstants.shops}/$shopId/readings',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      developer.log(
        '✅ Successfully fetched ${(response.data as List).length} readings',
        name: 'ShopService',
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) =>
                ShopReadingModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to load readings',
        name: 'ShopService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<ShopReadingModel> createReading(
    int shopId,
    Map<String, dynamic> readingData,
  ) async {
    try {
      developer.log('Creating reading for shop: $shopId', name: 'ShopService');

      final response = await _dioClient.post(
        '${ApiConstants.shops}/$shopId/readings',
        data: readingData,
      );

      developer.log('✅ Successfully created reading', name: 'ShopService');

      return ShopReadingModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to create reading',
        name: 'ShopService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // ============ INVOICES ============

  Future<List<Content>> getShopInvoices({
    required int shopId,
    String? period,
  }) async {
    try {
      developer.log(
        'Fetching invoices for shop: $shopId, period: $period',
        name: 'ShopService',
      );

      final queryParams = <String, dynamic>{};
      if (period != null) queryParams['period'] = period;

      final response = await _dioClient.get(
        '${ApiConstants.shops}/$shopId/invoices',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      developer.log(
        '✅ Successfully fetched ${(response.data as List).length} invoices',
        name: 'ShopService',
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) => Content.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      developer.log(
        '❌ Failed to load invoices',
        name: 'ShopService',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}

// Provider for ShopService
final shopServiceProvider = Provider<ShopService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ShopService(dioClient);
});