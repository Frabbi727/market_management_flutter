import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/dashboard_summary.dart';
import '../models/dashboard_view_models.dart';
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
final dashboardSummaryProvider = FutureProvider.autoDispose<DashboardSummary>((
  ref,
) async {
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

final dashboardHealthProvider = Provider<DashboardHealthStatus>((ref) {
  return const DashboardHealthStatus(
    inputsReady: true,
    missingReadings: 2,
    tariffReady: false,
    unlockedInvoices: 3,
  );
});

final dashboardInputsSnapshotProvider = Provider<DashboardInputsSnapshot>((
  ref,
) {
  return const DashboardInputsSnapshot(
    acTotalUnits: 1840.0,
    acUnitPrice: 12.5,
    acRatePerSqft: 2.4,
    guardCost: 6500.0,
    maidCost: 4200.0,
    otherCost: 1800.0,
    serviceRatePerSqft: 3.2,
    marketTotalSqft: 12850.0,
  );
});

final dashboardInvoicesProvider = Provider<List<DashboardInvoiceRow>>((ref) {
  return const [
    DashboardInvoiceRow(
      shopCode: 'S-101',
      shopName: 'Fresh Mart',
      electricityAmount: 14500.0,
      acAmount: 3200.0,
      serviceAmount: 2100.0,
      totalAmount: 19800.0,
      status: 'Paid',
      isLocked: true,
      isOverridden: false,
    ),
    DashboardInvoiceRow(
      shopCode: 'S-118',
      shopName: 'Style Avenue',
      electricityAmount: 9800.0,
      acAmount: 2800.0,
      serviceAmount: 1950.0,
      totalAmount: 14550.0,
      status: 'Unpaid',
      isLocked: false,
      isOverridden: true,
    ),
    DashboardInvoiceRow(
      shopCode: 'S-132',
      shopName: 'Tech Hub',
      electricityAmount: 16250.0,
      acAmount: 4100.0,
      serviceAmount: 2400.0,
      totalAmount: 22750.0,
      status: 'Overdue',
      isLocked: false,
      isOverridden: false,
    ),
    DashboardInvoiceRow(
      shopCode: 'S-142',
      shopName: 'Home Comfort',
      electricityAmount: 8700.0,
      acAmount: 2650.0,
      serviceAmount: 1820.0,
      totalAmount: 13170.0,
      status: 'Paid',
      isLocked: true,
      isOverridden: false,
    ),
    DashboardInvoiceRow(
      shopCode: 'S-156',
      shopName: 'Book Haven',
      electricityAmount: 5600.0,
      acAmount: 1980.0,
      serviceAmount: 1600.0,
      totalAmount: 9180.0,
      status: 'Unpaid',
      isLocked: false,
      isOverridden: false,
    ),
    DashboardInvoiceRow(
      shopCode: 'S-165',
      shopName: 'Gadget Lab',
      electricityAmount: 11200.0,
      acAmount: 3500.0,
      serviceAmount: 2100.0,
      totalAmount: 16800.0,
      status: 'Paid',
      isLocked: true,
      isOverridden: false,
    ),
    DashboardInvoiceRow(
      shopCode: 'S-174',
      shopName: 'Organic Bites',
      electricityAmount: 7200.0,
      acAmount: 2500.0,
      serviceAmount: 1750.0,
      totalAmount: 11450.0,
      status: 'Unpaid',
      isLocked: false,
      isOverridden: true,
    ),
    DashboardInvoiceRow(
      shopCode: 'S-181',
      shopName: 'Toy Planet',
      electricityAmount: 8150.0,
      acAmount: 2600.0,
      serviceAmount: 1800.0,
      totalAmount: 12550.0,
      status: 'Paid',
      isLocked: true,
      isOverridden: false,
    ),
  ];
});

final dashboardReadingsProvider = Provider<List<DashboardReadingRow>>((ref) {
  return const [
    DashboardReadingRow(
      shopName: 'Fresh Mart',
      meterCode: 'MTR-1101',
      previous: 12054,
      current: 12188,
      units: 134,
      isMissing: false,
    ),
    DashboardReadingRow(
      shopName: 'Style Avenue',
      meterCode: 'MTR-1236',
      previous: 8450,
      current: 0,
      units: 0,
      isMissing: true,
    ),
    DashboardReadingRow(
      shopName: 'Tech Hub',
      meterCode: 'MTR-1304',
      previous: 22340,
      current: 22525,
      units: 185,
      isMissing: false,
    ),
    DashboardReadingRow(
      shopName: 'Home Comfort',
      meterCode: 'MTR-1420',
      previous: 14210,
      current: 14306,
      units: 96,
      isMissing: false,
    ),
    DashboardReadingRow(
      shopName: 'Organic Bites',
      meterCode: 'MTR-1488',
      previous: 6250,
      current: 0,
      units: 0,
      isMissing: true,
    ),
  ];
});

final costBreakdownProvider = Provider<CostBreakdown>((ref) {
  return const CostBreakdown(
    electricity: 125478.0,
    ac: 25000.0,
    service: 18500.0,
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
