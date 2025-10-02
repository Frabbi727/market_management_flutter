import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/dashboard_summary.dart';
import '../models/shop_model.dart';
import '../service/dashboard_service.dart';

// Period provider (YYYY-MM format) using NotifierProvider for Riverpod 3.x
class SelectedPeriodNotifier extends Notifier<String> {
  @override
  String build() {
    final now = DateTime.now();
    return DateFormat('yyyy-MM').format(now);
  }

  void setPeriod(String period) => state = period;
}

final selectedPeriodProvider = NotifierProvider<SelectedPeriodNotifier, String>(
  SelectedPeriodNotifier.new,
);

// Dashboard summary provider with DEMO DATA
final dashboardSummaryProvider =
    FutureProvider.autoDispose<DashboardSummary>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 500));

  // Return demo data
  return DashboardSummary(
    totalElectricityUnits: 12547.80,
    totalElectricityAmount: 125478.00,
    totalAcCost: 25000.00,
    totalServiceCost: 18500.00,
    totalInvoicesAmount: 168978.00,
    paidInvoicesCount: 42,
    unpaidInvoicesCount: 8,
  );
});

// Shops provider - fetches from API
final shopsProvider = FutureProvider.autoDispose<List<ShopModel>>((ref) async {
  final service = ref.watch(dashboardServiceProvider);
  return await service.getShops();
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