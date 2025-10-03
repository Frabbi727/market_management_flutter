import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/dashboard_summary.dart';
import '../models/invoice.dart';
import '../models/shop_model.dart';
import '../models/reading_status.dart';
import '../service/dashboard_service.dart';

// Period provider (YYYY-MM-DD format) using NotifierProvider for Riverpod 3.x
class SelectedPeriodNotifier extends Notifier<String> {
  @override
  String build() {
    final now = DateTime.now();
    // Format as YYYY-MM-DD (today's date)
    return DateFormat('yyyy-MM-dd').format(now);
  }

  void setPeriod(String period) => state = period;
}

final selectedPeriodProvider = NotifierProvider<SelectedPeriodNotifier, String>(
  SelectedPeriodNotifier.new,
);

// Market ID provider - you can change this to get from user session/config
final marketIdProvider = Provider<int>((ref) => 1);

// Dashboard summary provider - fetches from API
final dashboardSummaryProvider = FutureProvider.autoDispose<DashBoardSummary>((
  ref,
) async {
  final service = ref.watch(dashboardServiceProvider);
  final period = ref.watch(selectedPeriodProvider);
  final marketId = ref.watch(marketIdProvider);

  // Fetch data from API
  return await service.getDashboardSummary(marketId: marketId, period: period);
});

// Invoices provider - fetches from API
final invoicesProvider = FutureProvider.autoDispose<Invoice>((ref) async {
  final service = ref.watch(dashboardServiceProvider);
  final period = ref.watch(selectedPeriodProvider);
  final marketId = ref.watch(marketIdProvider);

  // Fetch invoices from API
  return await service.getInvoices(
    marketId: marketId,
    period: period,
    page: 0,
    size: 20,
  );
});

// Shops provider
final shopsProvider = FutureProvider.autoDispose<List<ShopModel>>((ref) async {
  final service = ref.watch(dashboardServiceProvider);
  return await service.getShops();
});

// Reading status provider - fetches from API
final readingStatusProvider = FutureProvider.autoDispose<List<ReadingStatus>>((ref) async {
  final service = ref.watch(dashboardServiceProvider);
  final period = ref.watch(selectedPeriodProvider);
  final marketId = ref.watch(marketIdProvider);

  // Fetch reading status from API
  return await service.getReadingStatus(
    marketId: marketId,
    period: period,
  );
});

// Helper function to format period display
String formatPeriodDisplay(String period) {
  try {
    final date = DateFormat('yyyy-MM-dd').parse(period);
    return DateFormat('dd MMMM yyyy').format(date);
  } catch (e) {
    return period;
  }
}
