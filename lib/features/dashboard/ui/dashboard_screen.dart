import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:market_management_flutter/features/dashboard/provider/dashboard_providers.dart';
import '../../../core/constants/app_theme.dart';
import '../../../shared/widgets/kpi_card.dart';
import '../../../shared/widgets/period_picker.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(selectedPeriodProvider);
    final dashboardAsync = ref.watch(dashboardSummaryProvider);

    // Fetch shops from API (triggers API call)
    ref.watch(shopsProvider);

    return Container(
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          Expanded(
            child: dashboardAsync.when(
              data: (summary) => _buildDashboardContent(context, ref, summary),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text('Error: ${error.toString()}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(dashboardSummaryProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, WidgetRef ref, summary) {
    final currencyFormat = NumberFormat.currency(symbol: 'TK ', decimalDigits: 2);
    final numberFormat = NumberFormat('#,##0.00');
    final shopsAsync = ref.watch(shopsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shops Count Info Bar
          shopsAsync.when(
            data: (shops) => Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.store, color: AppTheme.primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Total Shops: ${shops.length}',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'API Connected',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            loading: () => Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text('Loading shops...'),
                ],
              ),
            ),
            error: (error, _) => Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Failed to load shops: ${error.toString()}',
                      style: TextStyle(color: Colors.red[700], fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // KPI Cards Grid - Responsive
          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate crossAxisCount based on screen width
              int crossAxisCount = 3;
              if (constraints.maxWidth < 600) {
                crossAxisCount = 1; // Mobile: 1 column
              } else if (constraints.maxWidth < 1024) {
                crossAxisCount = 2; // Tablet: 2 columns
              } else {
                crossAxisCount = 3; // Desktop: 3 columns
              }

              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: constraints.maxWidth < 600 ? 2.5 : 2,
                children: [
              KpiCard(
                title: 'Total Electricity Units',
                value: numberFormat.format(summary.totalElectricityUnits ?? 0),
                icon: Icons.electric_bolt,
                color: AppTheme.electricityColor,
                subtitle: 'kWh',
              ),
              KpiCard(
                title: 'Total Electricity Amount',
                value: currencyFormat.format(summary.totalElectricityAmount ?? 0),
                icon: Icons.monetization_on,
                color: AppTheme.amountColor,
              ),
              KpiCard(
                title: 'Total AC Cost',
                value: currencyFormat.format(summary.totalAcCost ?? 0),
                icon: Icons.ac_unit,
                color: AppTheme.acCostColor,
              ),
              KpiCard(
                title: 'Total Service Cost',
                value: currencyFormat.format(summary.totalServiceCost ?? 0),
                icon: Icons.handyman,
                color: AppTheme.serviceCostColor,
              ),
              KpiCard(
                title: 'Total Invoices Amount',
                value: currencyFormat.format(summary.totalInvoicesAmount ?? 0),
                icon: Icons.receipt_long,
                color: AppTheme.invoiceColor,
              ),
              KpiCard(
                title: 'Invoices Status',
                value: '${summary.paidInvoicesCount ?? 0} / ${summary.unpaidInvoicesCount ?? 0}',
                icon: Icons.account_balance_wallet,
                color: AppTheme.statusColor,
                subtitle: 'Paid / Unpaid',
              ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          // Quick Actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildQuickActionButton(
                context,
                label: 'Enter Readings',
                icon: Icons.edit_note,
                color: Colors.blue,
                onPressed: () {
                  // Navigate to readings screen
                },
              ),
              _buildQuickActionButton(
                context,
                label: 'Set Monthly Inputs',
                icon: Icons.input,
                color: Colors.green,
                onPressed: () {
                  // Navigate to monthly inputs screen
                },
              ),
              _buildQuickActionButton(
                context,
                label: 'Run Compute',
                icon: Icons.play_arrow,
                color: Colors.orange,
                onPressed: () {
                  // Trigger billing compute
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    );
  }
}