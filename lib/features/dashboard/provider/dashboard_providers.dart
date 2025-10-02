import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/dashboard_summary.dart';
import '../service/dashboard_service.dart';

// Period provider (YYYY-MM format)
final selectedPeriodProvider = StateProvider<String>((ref) {
  final now = DateTime.now();
  return DateFormat('yyyy-MM').format(now);
});

// Dashboard summary provider
final dashboardSummaryProvider =
    FutureProvider.autoDispose<DashboardSummary>((ref) async {
  final period = ref.watch(selectedPeriodProvider);
  final service = ref.watch(dashboardServiceProvider);

  return await service.getDashboardSummary(period);
});

// Helper function to format period display
String formatPeriodDisplay(String period) {
  try {
    final date = DateFormat('yyyy-MM').parse(period);
    return DateFormat('MMMM yyyy').format(date);
  } catch (e) {
    return period;
  }
}