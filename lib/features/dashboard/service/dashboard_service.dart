import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../models/dashboard_summary.dart';

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
}

// Provider for DashboardService
final dashboardServiceProvider = Provider<DashboardService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return DashboardService(dioClient);
});