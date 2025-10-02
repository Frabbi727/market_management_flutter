import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/dashboard_summary.dart';

// Period provider (YYYY-MM format)
final selectedPeriodProvider = StateProvider<String>((ref) {
  final now = DateTime.now();
  return DateFormat('yyyy-MM').format(now);
});

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

// Helper function to format period display
String formatPeriodDisplay(String period) {
  try {
    final date = DateFormat('yyyy-MM').parse(period);
    return DateFormat('MMMM yyyy').format(date);
  } catch (e) {
    return period;
  }
}