import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:market_management_flutter/core/constants/app_theme.dart';
import 'package:market_management_flutter/features/dashboard/models/dashboard_summary.dart';
import 'package:market_management_flutter/features/dashboard/models/dashboard_view_models.dart';
import 'package:market_management_flutter/features/dashboard/models/invoice.dart';
import 'package:market_management_flutter/features/dashboard/models/reading_status.dart';
import 'package:market_management_flutter/features/dashboard/provider/dashboard_providers.dart';

import '../../../shared/widgets/kpi_card.dart';
import '../../../shared/widgets/period_picker.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '৳ ',
    decimalDigits: 0,
  );
  final NumberFormat _currencyWithDecimals = NumberFormat.currency(
    symbol: '৳ ',
    decimalDigits: 2,
  );
  final NumberFormat _decimalFormat = NumberFormat('#,##0.##');

  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  void initState() {
    super.initState();
    _rowsPerPage = 6;
  }

  @override
  Widget build(BuildContext context) {
    final selectedPeriod = ref.watch(selectedPeriodProvider);
    final shopsAsync = ref.watch(shopsProvider);
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final invoicesAsync = ref.watch(invoicesProvider);
    final readingsAsync = ref.watch(readingStatusProvider);

    final shopCount = shopsAsync.maybeWhen(
      data: (shops) => shops.length,
      orElse: () => null,
    );

    return Container(
      color: AppTheme.backgroundColor,
      child: summaryAsync.when(
        data: (summary) {
          return invoicesAsync.when(
            data: (invoiceData) {
              return readingsAsync.when(
                data: (readings) {
                  return _buildDashboardContent(
                    context,
                    summary,
                    selectedPeriod,
                    invoiceData,
                    readings,
                    shopCount,
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text('Error loading readings: ${error.toString()}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.refresh(readingStatusProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text('Error loading invoices: ${error.toString()}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.refresh(invoicesProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text('Error loading summary: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(dashboardSummaryProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    DashBoardSummary summary,
    String selectedPeriod,
    Invoice invoice,
    List<ReadingStatus> readings,
    int? shopCount,
  ) {
    // Calculate cost breakdown from KPIs
    final costBreakdown = CostBreakdown(
      electricity: summary.kpis?.electricityAmount ?? 0.0,
      ac: summary.kpis?.acCost ?? 0.0,
      service: summary.kpis?.serviceCost ?? 0.0,
    );



    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterActionsBar(
            context: context,selectedPeriod: selectedPeriod,),
          const SizedBox(height: 16),
          _buildKpiSection(summary.kpis),
          const SizedBox(height: 16),
          _buildHealthPanel(summary.health),
          const SizedBox(height: 16),
          _buildInputsSnapshotPanel(summary.inputs),
          const SizedBox(height: 16),
          _buildInvoicesSection(invoice),
          const SizedBox(height: 16),
          _buildReadingsPanel(readings),
          const SizedBox(height: 16),
          _buildCostMixPanel(costBreakdown),
        ],
      ),
    );
  }

  Widget _buildFilterActionsBar({ required BuildContext context,
    required String selectedPeriod,
    int? shopCount,}
  ) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters & Actions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                child: PeriodPicker(
                  currentPeriod: selectedPeriod,
                  onPeriodChanged: (period) => ref
                      .read(selectedPeriodProvider.notifier)
                      .setPeriod(period),
                ),
              ),
              if (shopCount != null)
                Chip(
                  avatar: const Icon(Icons.storefront, size: 16),
                  label: Text('Shops synced: $shopCount'),
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildKpiSection(Kpis? kpis) {
    debugPrint("this is kpi section ${kpis}");
    final items = [
      KpiCard(
        title: 'Invoices',
        value: _decimalFormat.format(kpis?.invoiceCount??0),
        icon: Icons.receipt_long_rounded,
        color: AppTheme.invoiceColor,
        subtitle:
            'Paid: ${_decimalFormat.format( 0)} · Unpaid: ${_decimalFormat.format( 0)}',
      ),
      KpiCard(
        title: 'Total Amount',
        value: _currencyFormat.format(kpis?.totalAmount ?? 0.0),
        icon: Icons.account_balance_wallet_rounded,
        color: AppTheme.amountColor,
      ),
      KpiCard(
        title: 'Electricity Units',
        value: _decimalFormat.format(kpis?.electricityUnits ?? 0.0),
        icon: Icons.electric_bolt_rounded,
        color: AppTheme.electricityColor,
        subtitle: 'kWh',
      ),
      KpiCard(
        title: 'Electricity Amount',
        value: _currencyFormat.format(kpis?.electricityAmount ?? 0.0),
        icon: Icons.energy_savings_leaf_rounded,
        color: AppTheme.primaryColor,
      ),
      KpiCard(
        title: 'AC Cost',
        value: _currencyFormat.format(kpis?.acCost ?? 0.0),
        icon: Icons.ac_unit_rounded,
        color: AppTheme.acCostColor,
      ),
      KpiCard(
        title: 'Service Cost',
        value: _currencyFormat.format(kpis?.serviceCost ?? 0.0),
        icon: Icons.handshake_rounded,
        color: AppTheme.serviceCostColor,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;
        if (constraints.maxWidth < 640) {
          crossAxisCount = 2;
        } else if (constraints.maxWidth < 1024) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = 6;
        }

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: constraints.maxWidth < 640 ? 1.6 : 1.3,
          children: items,
        );
      },
    );
  }

  Widget _buildHealthPanel(Health? health) {
    final badges = [
      _HealthBadgeData(
        label: 'Inputs',
        value: (health?.inputsOk??false) ? 'OK' : 'Missing',
        icon: Icons.assignment_turned_in_rounded,
        color: (health?.inputsOk??false) ? Colors.teal : Colors.red,
      ),
      _HealthBadgeData(
        label: 'Missing readings',
        value: '${health?.missingReadingsCount??0}',
        icon: Icons.flash_off,
        color: (health?.missingReadingsCount??0) > 0 ? Colors.orange : Colors.teal,
      ),
      _HealthBadgeData(
        label: 'Tariff',
        value: (health?.tariffOk??false) ? 'OK' : 'Set required',
        icon: Icons.price_change_rounded,
        color: (health?.tariffOk??false) ? Colors.teal : Colors.red,
      ),
      _HealthBadgeData(
        label: 'Unlocked invoices',
        value: '${health?.unlockedInvoicesCount??0}',
        icon: Icons.lock_open_rounded,
        color: (health?.unlockedInvoicesCount??0) > 0 ? Colors.orange : Colors.teal,
      ),
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Status',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: badges
                .map(
                  (badge) => Chip(
                    avatar: Icon(badge.icon, size: 16, color: Colors.white),
                    label: Text('${badge.label}: ${badge.value}'),
                    backgroundColor: badge.color.withValues(alpha: 0.15),
                    side: BorderSide(
                      color: badge.color.withValues(alpha: 0.4),
                    ),
                    labelStyle: TextStyle(
                      color: badge.color.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputsSnapshotPanel(Inputs? inputs) {
    final entries = [
      _SnapshotEntry(
        label: 'AC total units',
        value: '${_decimalFormat.format(inputs?.acTotalUnits??0.0)} kWh',
      ),
      _SnapshotEntry(
        label: 'AC unit price',
        value: _currencyWithDecimals.format(inputs?.acUnitPrice??0.0),
      ),
      _SnapshotEntry(
        label: 'AC rate / sqft',
        value: _currencyWithDecimals.format(inputs?.acPerSqftRate??0.0),
      ),
      _SnapshotEntry(
        label: 'Guard cost',
        value: _currencyFormat.format(inputs?.guardCost??0.0),
      ),
      _SnapshotEntry(
        label: 'Maid cost',
        value: _currencyFormat.format(inputs?.maidCost??0.0),
      ),
      _SnapshotEntry(
        label: 'Other cost',
        value: _currencyFormat.format(inputs?.otherCost??0.0),
      ),
      _SnapshotEntry(
        label: 'Service rate / sqft',
        value: _currencyWithDecimals.format(inputs?.servicePerSqftRate??0.0),
      ),
      _SnapshotEntry(
        label: 'Market total sqft',
        value: _decimalFormat.format(inputs?.marketTotalSqft??0.0),
      ),
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Inputs Snapshot',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _showSetInputsDialog(context),
                tooltip: 'Edit inputs',
                icon: const Icon(Icons.edit_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 500;
              final tileWidth = isCompact ? constraints.maxWidth : 220.0;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: entries
                    .map(
                      (entry) => ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: math.min(
                            tileWidth,
                            constraints.maxWidth,
                          ),
                          maxWidth: math.min(
                            tileWidth,
                            constraints.maxWidth,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.label,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              entry.value,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInvoicesSection(Invoice invoice) {
    final content = invoice.content ?? [];
    if (content.isEmpty) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Invoices',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            Text('No invoices available for the selected period.'),
          ],
        ),
      );
    }

    final dataSource = _InvoicesDataSource(
      invoices: content,
      currencyFormat: _currencyFormat,
      onView: (invoice) => _showInvoiceDetails(context, invoice),
    );

    final hasOverrides = content.any((c) => c.hasOverride ?? false);

    final options = <int>{5, 10, 20, content.length}
      ..removeWhere((value) => value <= 0);
    final availableRows =
        options.where((value) => value <= content.length).toList()..sort();

    var effectiveRowsPerPage = _rowsPerPage;
    if (effectiveRowsPerPage < 1) {
      effectiveRowsPerPage = 1;
    }
    if (effectiveRowsPerPage > content.length && content.isNotEmpty) {
      effectiveRowsPerPage = content.length;
    }
    if (!availableRows.contains(effectiveRowsPerPage)) {
      availableRows.add(effectiveRowsPerPage);
      availableRows.sort();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: math.max(MediaQuery.of(context).size.width - 32, 900),
        child: PaginatedDataTable(
          header: const Text('Invoices'),
          rowsPerPage: effectiveRowsPerPage,
          availableRowsPerPage: availableRows,
          dataRowMinHeight: hasOverrides ? 60 : 56,
          dataRowMaxHeight: hasOverrides ? 72 : 60,
          onRowsPerPageChanged: (value) {
            if (value != null) {
              setState(() {
                _rowsPerPage = value;
              });
            }
          },
          columns: const [
            DataColumn(label: Text('Shop Code')),
            DataColumn(label: Text('Shop Name')),
            DataColumn(label: Text('Elec (৳)')),
            DataColumn(label: Text('AC (৳)')),
            DataColumn(label: Text('Service (৳)')),
            DataColumn(label: Text('Total (৳)')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Locked')),
            DataColumn(label: Text('Actions')),
          ],
          source: dataSource,
        ),
      ),
    );
  }

  Widget _buildReadingsPanel(List<ReadingStatus> readings) {
    if (readings.isEmpty) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Readings Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            Text('No readings available for the selected period.'),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Readings Status',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: math.max(MediaQuery.of(context).size.width - 64, 800),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  Colors.grey.withValues(alpha: 0.1),
                ),
                columns: const [
                  DataColumn(label: Text('Shop Name')),
                  DataColumn(label: Text('Meter Code')),
                  DataColumn(label: Text('Previous')),
                  DataColumn(label: Text('Current')),
                  DataColumn(label: Text('Units')),
                  DataColumn(label: Text('Status')),
                ],
                rows: readings
                    .map(
                      (reading) => DataRow(
                        color: (reading.missing ?? false)
                            ? WidgetStateProperty.all<Color?>(
                                Colors.red.withValues(alpha: 0.05),
                              )
                            : null,
                        cells: [
                          DataCell(Text(reading.shopName ?? '')),
                          DataCell(Text(reading.meterNumber ?? '')),
                          DataCell(Text(_decimalFormat.format(reading.prevReading ?? 0))),
                          DataCell(
                            Text(
                              (reading.currReading ?? 0) == 0
                                  ? '—'
                                  : _decimalFormat.format(reading.currReading ?? 0),
                            ),
                          ),
                          DataCell(Text(_decimalFormat.format(reading.units ?? 0))),
                          DataCell(
                            Chip(
                              label: Text((reading.missing ?? false) ? 'Missing' : 'OK'),
                              backgroundColor: (reading.missing ?? false)
                                  ? Colors.red.withValues(alpha: 0.15)
                                  : Colors.teal.withValues(alpha: 0.15),
                              labelStyle: TextStyle(
                                color: (reading.missing ?? false)
                                    ? Colors.red.shade700
                                    : Colors.teal.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostMixPanel(CostBreakdown costBreakdown) {
    final costSegments = [
      _CostSegment(
        label: 'Electricity',
        value: costBreakdown.electricity,
        color: AppTheme.electricityColor,
      ),
      _CostSegment(
        label: 'AC',
        value: costBreakdown.ac,
        color: AppTheme.acCostColor,
      ),
      _CostSegment(
        label: 'Service',
        value: costBreakdown.service,
        color: AppTheme.serviceCostColor,
      ),
    ];

    final totalCost = costBreakdown.total;

    final barChildren = totalCost <= 0
        ? costSegments
              .map(
                (segment) => Expanded(child: Container(color: segment.color)),
              )
              .toList()
        : costSegments
              .map(
                (segment) => Expanded(
                  flex: math.max(
                    1,
                    ((segment.value / totalCost) * 1000).round(),
                  ),
                  child: Container(color: segment.color),
                ),
              )
              .toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cost Mix',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Container(
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Row(children: barChildren),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: costSegments.map((segment) {
              final share = totalCost <= 0
                  ? 0
                  : (segment.value / totalCost) * 100;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: segment.color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(segment.label)),
                    Text(
                      _currencyFormat.format(segment.value),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 12),
                    Text('${share.toStringAsFixed(1)}%'),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _showSetInputsDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Inputs'),
        content: const Text(
          'Input configuration flows will live here. For now this is a placeholder dialog.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }


  Future<void> _showInvoiceDetails(
    BuildContext context,
    Content invoice,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Invoice ${invoice.shopCode ?? ''}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDialogRow('Shop', invoice.shopName ?? ''),
            _buildDialogRow(
              'Electricity',
              _currencyFormat.format((invoice.electricityAmount ?? 0).toDouble()),
            ),
            _buildDialogRow('AC', _currencyFormat.format(invoice.acAmount ?? 0.0)),
            _buildDialogRow(
              'Service',
              _currencyFormat.format(invoice.serviceAmount ?? 0.0),
            ),
            const Divider(),
            _buildDialogRow(
              'Total',
              _currencyFormat.format(invoice.total ?? 0.0),
            ),
            _buildDialogRow('Status', invoice.status ?? ''),
            _buildDialogRow('Locked', (invoice.locked ?? false) ? 'Yes' : 'No'),
            if (invoice.hasOverride ?? false)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Marked as overridden. Please review before compute.',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _HealthBadgeData {
  final String label;
  final String value;
  final IconData icon;
  final MaterialColor color;

  const _HealthBadgeData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class _SnapshotEntry {
  final String label;
  final String value;

  const _SnapshotEntry({required this.label, required this.value});
}

class _CostSegment {
  final String label;
  final double value;
  final Color color;

  const _CostSegment({
    required this.label,
    required this.value,
    required this.color,
  });
}

class _InvoicesDataSource extends DataTableSource {
  _InvoicesDataSource({
    required this.invoices,
    required this.currencyFormat,
    required this.onView,
  });

  final List<Content> invoices;
  final NumberFormat currencyFormat;
  final void Function(Content invoice) onView;

  @override
  DataRow? getRow(int index) {
    if (index >= invoices.length) {
      return null;
    }

    final invoice = invoices[index];

    return DataRow.byIndex(
      index: index,
      color: (invoice.hasOverride ?? false)
          ? WidgetStateProperty.all<Color?>(
              Colors.orange.withValues(alpha: 0.08),
            )
          : null,
      cells: [
        DataCell(Text(invoice.shopCode ?? '')),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(invoice.shopName ?? invoice.shopCode ?? 'N/A'),
              if (invoice.hasOverride ?? false)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Chip(
                    label: const Text('Overridden'),
                    backgroundColor: Colors.orange.withValues(alpha: 0.2),
                    labelStyle: TextStyle(
                      color: Colors.orange.shade800,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                ),
            ],
          ),
        ),
        DataCell(Text(currencyFormat.format((invoice.electricityAmount ?? 0).toDouble()))),
        DataCell(Text(currencyFormat.format(invoice.acAmount ?? 0.0))),
        DataCell(Text(currencyFormat.format(invoice.serviceAmount ?? 0.0))),
        DataCell(Text(currencyFormat.format(invoice.total ?? 0.0))),
        DataCell(() {
          final palette = _statusColor(invoice.status ?? '');
          return Chip(
            label: Text(invoice.status ?? ''),
            backgroundColor: palette.withValues(alpha: 0.15),
            labelStyle: TextStyle(
              color: palette.shade700,
              fontWeight: FontWeight.w600,
            ),
          );
        }()),
        DataCell(
          Icon(
            (invoice.locked ?? false) ? Icons.lock_rounded : Icons.lock_open_rounded,
            color: (invoice.locked ?? false) ? Colors.green : Colors.red,
          ),
        ),
        DataCell(
          TextButton.icon(
            onPressed: () => onView(invoice),
            icon: const Icon(Icons.visibility_rounded),
            label: const Text('View'),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => invoices.length;

  @override
  int get selectedRowCount => 0;

  MaterialColor _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.teal;
      case 'overdue':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}

