import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:market_management_flutter/features/dashboard/provider/dashboard_providers.dart';
import '../../../shared/widgets/kpi_card.dart';
import '../../../shared/widgets/period_picker.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(selectedPeriodProvider);
    final dashboardAsync = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header with period picker
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  'Dashboard',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                PeriodPicker(
                  currentPeriod: selectedPeriod,
                  onPeriodChanged: (newPeriod) {
                    ref.read(selectedPeriodProvider.notifier).state = newPeriod;
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Main content
          Expanded(
            child: dashboardAsync.when(
              data: (summary) => _buildDashboardContent(context, summary),
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

  Widget _buildDashboardContent(BuildContext context, summary) {
    final currencyFormat = NumberFormat.currency(symbol: 'TK ', decimalDigits: 2);
    final numberFormat = NumberFormat('#,##0.00');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI Cards Grid
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2,
            children: [
              KpiCard(
                title: 'Total Electricity Units',
                value: numberFormat.format(summary.totalElectricityUnits),
                icon: Icons.electric_bolt,
                color: Colors.orange,
                subtitle: 'kWh',
              ),
              KpiCard(
                title: 'Total Electricity Amount',
                value: currencyFormat.format(summary.totalElectricityAmount),
                icon: Icons.monetization_on,
                color: Colors.blue,
              ),
              KpiCard(
                title: 'Total AC Cost',
                value: currencyFormat.format(summary.totalAcCost),
                icon: Icons.ac_unit,
                color: Colors.cyan,
              ),
              KpiCard(
                title: 'Total Service Cost',
                value: currencyFormat.format(summary.totalServiceCost),
                icon: Icons.handyman,
                color: Colors.green,
              ),
              KpiCard(
                title: 'Total Invoices Amount',
                value: currencyFormat.format(summary.totalInvoicesAmount),
                icon: Icons.receipt_long,
                color: Colors.purple,
              ),
              KpiCard(
                title: 'Invoices Status',
                value: '${summary.paidInvoicesCount} / ${summary.unpaidInvoicesCount}',
                icon: Icons.account_balance_wallet,
                color: Colors.teal,
                subtitle: 'Paid / Unpaid',
              ),
            ],
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