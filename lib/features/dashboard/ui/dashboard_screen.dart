import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:market_management_flutter/core/constants/app_theme.dart';
import 'package:market_management_flutter/features/dashboard/models/dashboard_summary.dart';
import 'package:market_management_flutter/features/dashboard/models/dashboard_view_models.dart';
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
    final health = ref.watch(dashboardHealthProvider);
    final inputsSnapshot = ref.watch(dashboardInputsSnapshotProvider);
    final invoices = ref.watch(dashboardInvoicesProvider);
    final readings = ref.watch(dashboardReadingsProvider);
    final costBreakdown = ref.watch(costBreakdownProvider);
    final shopsAsync = ref.watch(shopsProvider);
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    final shopCount = shopsAsync.maybeWhen(
      data: (shops) => shops.length,
      orElse: () => null,
    );

    return Container(
      color: AppTheme.backgroundColor,
      child: summaryAsync.when(
        data: (summary) => _buildDashboardContent(
          context,
          summary,
          selectedPeriod,
          health,
          inputsSnapshot,
          invoices,
          readings,
          costBreakdown,
          shopCount,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
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
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    DashboardSummary summary,
    String selectedPeriod,
    DashboardHealthStatus health,
    DashboardInputsSnapshot inputsSnapshot,
    List<DashboardInvoiceRow> invoices,
    List<DashboardReadingRow> readings,
    CostBreakdown costBreakdown,
    int? shopCount,
  ) {
    final totalInvoicesCount =
        (summary.paidInvoicesCount ?? 0) + (summary.unpaidInvoicesCount ?? 0);
    final computeDisabled = health.computeDisabled;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterActionsBar(
            context,
            selectedPeriod,
            computeDisabled,
            health,
            shopCount,
          ),
          const SizedBox(height: 16),
          _buildKpiSection(summary, totalInvoicesCount),
          const SizedBox(height: 16),
          _buildHealthPanel(health),
          const SizedBox(height: 16),
          _buildInputsSnapshotPanel(inputsSnapshot),
          const SizedBox(height: 16),
          _buildInvoicesSection(invoices),
          const SizedBox(height: 16),
          _buildReadingsPanel(readings),
          const SizedBox(height: 16),
          _buildCostMixPanel(costBreakdown),
        ],
      ),
    );
  }

  Widget _buildFilterActionsBar(
    BuildContext context,
    String selectedPeriod,
    bool computeDisabled,
    DashboardHealthStatus health,
    int? shopCount,
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
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: () => _showSetInputsDialog(context),
                icon: const Icon(Icons.tune_rounded),
                label: const Text('Set Inputs'),
              ),
              OutlinedButton.icon(
                onPressed: () => _showAddReadingDialog(context),
                icon: const Icon(Icons.bolt_rounded),
                label: const Text('Add Reading'),
              ),
              Tooltip(
                message: computeDisabled
                    ? 'Resolve missing inputs, tariff, or readings before compute.'
                    : 'Run monthly billing compute.',
                child: ElevatedButton.icon(
                  onPressed: computeDisabled
                      ? null
                      : () => _showComputeDialog(context),
                  icon: const Icon(Icons.calculate_rounded),
                  label: const Text('Compute'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: computeDisabled
                        ? null
                        : theme.colorScheme.primary,
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => _showExportSheet(context),
                icon: const Icon(Icons.file_download_rounded),
                label: const Text('Export'),
              ),
              if (health.unlockedInvoices > 0)
                Chip(
                  backgroundColor: theme.colorScheme.errorContainer
                      .withValues(alpha: 0.3),
                  avatar: Icon(
                    Icons.lock_open_rounded,
                    size: 16,
                    color: theme.colorScheme.error,
                  ),
                  label: Text(
                    '${health.unlockedInvoices} invoices unlocked',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKpiSection(DashboardSummary summary, int totalInvoicesCount) {
    final items = [
      KpiCard(
        title: 'Invoices',
        value: _decimalFormat.format(totalInvoicesCount),
        icon: Icons.receipt_long_rounded,
        color: AppTheme.invoiceColor,
        subtitle:
            'Paid: ${_decimalFormat.format(summary.paidInvoicesCount ?? 0)} · Unpaid: ${_decimalFormat.format(summary.unpaidInvoicesCount ?? 0)}',
      ),
      KpiCard(
        title: 'Total Amount',
        value: _currencyFormat.format(summary.totalInvoicesAmount ?? 0),
        icon: Icons.account_balance_wallet_rounded,
        color: AppTheme.amountColor,
      ),
      KpiCard(
        title: 'Electricity Units',
        value: _decimalFormat.format(summary.totalElectricityUnits ?? 0),
        icon: Icons.electric_bolt_rounded,
        color: AppTheme.electricityColor,
        subtitle: 'kWh',
      ),
      KpiCard(
        title: 'Electricity Amount',
        value: _currencyFormat.format(summary.totalElectricityAmount ?? 0),
        icon: Icons.energy_savings_leaf_rounded,
        color: AppTheme.primaryColor,
      ),
      KpiCard(
        title: 'AC Cost',
        value: _currencyFormat.format(summary.totalAcCost ?? 0),
        icon: Icons.ac_unit_rounded,
        color: AppTheme.acCostColor,
      ),
      KpiCard(
        title: 'Service Cost',
        value: _currencyFormat.format(summary.totalServiceCost ?? 0),
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

  Widget _buildHealthPanel(DashboardHealthStatus health) {
    final badges = [
      _HealthBadgeData(
        label: 'Inputs',
        value: health.inputsReady ? 'OK' : 'Missing',
        icon: Icons.assignment_turned_in_rounded,
        color: health.inputsReady ? Colors.teal : Colors.red,
      ),
      _HealthBadgeData(
        label: 'Missing readings',
        value: '${health.missingReadings}',
        icon: Icons.flash_off,
        color: health.missingReadings > 0 ? Colors.orange : Colors.teal,
      ),
      _HealthBadgeData(
        label: 'Tariff',
        value: health.tariffReady ? 'OK' : 'Set required',
        icon: Icons.price_change_rounded,
        color: health.tariffReady ? Colors.teal : Colors.red,
      ),
      _HealthBadgeData(
        label: 'Unlocked invoices',
        value: '${health.unlockedInvoices}',
        icon: Icons.lock_open_rounded,
        color: health.unlockedInvoices > 0 ? Colors.orange : Colors.teal,
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

  Widget _buildInputsSnapshotPanel(DashboardInputsSnapshot inputs) {
    final entries = [
      _SnapshotEntry(
        label: 'AC total units',
        value: '${_decimalFormat.format(inputs.acTotalUnits)} kWh',
      ),
      _SnapshotEntry(
        label: 'AC unit price',
        value: _currencyWithDecimals.format(inputs.acUnitPrice),
      ),
      _SnapshotEntry(
        label: 'AC rate / sqft',
        value: _currencyWithDecimals.format(inputs.acRatePerSqft),
      ),
      _SnapshotEntry(
        label: 'Guard cost',
        value: _currencyFormat.format(inputs.guardCost),
      ),
      _SnapshotEntry(
        label: 'Maid cost',
        value: _currencyFormat.format(inputs.maidCost),
      ),
      _SnapshotEntry(
        label: 'Other cost',
        value: _currencyFormat.format(inputs.otherCost),
      ),
      _SnapshotEntry(
        label: 'Service rate / sqft',
        value: _currencyWithDecimals.format(inputs.serviceRatePerSqft),
      ),
      _SnapshotEntry(
        label: 'Market total sqft',
        value: _decimalFormat.format(inputs.marketTotalSqft),
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

  Widget _buildInvoicesSection(List<DashboardInvoiceRow> invoices) {
    if (invoices.isEmpty) {
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
      invoices: invoices,
      currencyFormat: _currencyFormat,
      onView: (invoice) => _showInvoiceDetails(context, invoice),
    );

    final hasOverrides = invoices.any((invoice) => invoice.isOverridden);

    final options = <int>{5, 10, 20, invoices.length}
      ..removeWhere((value) => value <= 0);
    final availableRows =
        options.where((value) => value <= invoices.length).toList()..sort();

    var effectiveRowsPerPage = _rowsPerPage;
    if (effectiveRowsPerPage < 1) {
      effectiveRowsPerPage = 1;
    }
    if (effectiveRowsPerPage > invoices.length && invoices.isNotEmpty) {
      effectiveRowsPerPage = invoices.length;
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

  Widget _buildReadingsPanel(List<DashboardReadingRow> readings) {
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
                        color: reading.isMissing
                            ? WidgetStateProperty.all<Color?>(
                                Colors.red.withValues(alpha: 0.05),
                              )
                            : null,
                        cells: [
                          DataCell(Text(reading.shopName)),
                          DataCell(Text(reading.meterCode)),
                          DataCell(Text(_decimalFormat.format(reading.previous))),
                          DataCell(
                            Text(
                              reading.current == 0
                                  ? '—'
                                  : _decimalFormat.format(reading.current),
                            ),
                          ),
                          DataCell(Text(_decimalFormat.format(reading.units))),
                          DataCell(
                            Chip(
                              label: Text(reading.isMissing ? 'Missing' : 'OK'),
                              backgroundColor: reading.isMissing
                                  ? Colors.red.withValues(alpha: 0.15)
                                  : Colors.teal.withValues(alpha: 0.15),
                              labelStyle: TextStyle(
                                color: reading.isMissing
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

  Future<void> _showAddReadingDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Reading'),
        content: const Text('Reading capture workflow will be added here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _showComputeDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Run Compute'),
        content: const Text(
          'This will trigger monthly billing computation for the selected period.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Compute triggered.')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showExportSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export options',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_rounded),
              title: const Text('Export invoices PDF'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PDF export queued.')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_on_rounded),
              title: const Text('Export detailed CSV'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('CSV export queued.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showInvoiceDetails(
    BuildContext context,
    DashboardInvoiceRow invoice,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Invoice ${invoice.shopCode}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDialogRow('Shop', invoice.shopName),
            _buildDialogRow(
              'Electricity',
              _currencyFormat.format(invoice.electricityAmount),
            ),
            _buildDialogRow('AC', _currencyFormat.format(invoice.acAmount)),
            _buildDialogRow(
              'Service',
              _currencyFormat.format(invoice.serviceAmount),
            ),
            const Divider(),
            _buildDialogRow(
              'Total',
              _currencyFormat.format(invoice.totalAmount),
            ),
            _buildDialogRow('Status', invoice.status),
            _buildDialogRow('Locked', invoice.isLocked ? 'Yes' : 'No'),
            if (invoice.isOverridden)
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

  final List<DashboardInvoiceRow> invoices;
  final NumberFormat currencyFormat;
  final void Function(DashboardInvoiceRow invoice) onView;

  @override
  DataRow? getRow(int index) {
    if (index >= invoices.length) {
      return null;
    }

    final invoice = invoices[index];

    return DataRow.byIndex(
      index: index,
      color: invoice.isOverridden
          ? WidgetStateProperty.all<Color?>(
              Colors.orange.withValues(alpha: 0.08),
            )
          : null,
      cells: [
        DataCell(Text(invoice.shopCode)),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(invoice.shopName),
              if (invoice.isOverridden)
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
        DataCell(Text(currencyFormat.format(invoice.electricityAmount))),
        DataCell(Text(currencyFormat.format(invoice.acAmount))),
        DataCell(Text(currencyFormat.format(invoice.serviceAmount))),
        DataCell(Text(currencyFormat.format(invoice.totalAmount))),
        DataCell(() {
          final palette = _statusColor(invoice.status);
          return Chip(
            label: Text(invoice.status),
            backgroundColor: palette.withValues(alpha: 0.15),
            labelStyle: TextStyle(
              color: palette.shade700,
              fontWeight: FontWeight.w600,
            ),
          );
        }()),
        DataCell(
          Icon(
            invoice.isLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
            color: invoice.isLocked ? Colors.green : Colors.red,
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

class _ReadingsDataSource extends DataTableSource {
  _ReadingsDataSource({
    required this.readings,
    required this.decimalFormat,
  });

  final List<DashboardReadingRow> readings;
  final NumberFormat decimalFormat;

  @override
  DataRow? getRow(int index) {
    if (index >= readings.length) {
      return null;
    }

    final reading = readings[index];

    return DataRow.byIndex(
      index: index,
      color: reading.isMissing
          ? WidgetStateProperty.all<Color?>(
              Colors.red.withValues(alpha: 0.08),
            )
          : null,
      cells: [
        DataCell(Text(reading.shopName)),
        DataCell(Text(reading.meterCode)),
        DataCell(Text(decimalFormat.format(reading.previous))),
        DataCell(
          Text(
            reading.current == 0 ? '—' : decimalFormat.format(reading.current),
          ),
        ),
        DataCell(Text(decimalFormat.format(reading.units))),
        DataCell(
          Chip(
            label: Text(reading.isMissing ? 'Missing' : 'OK'),
            backgroundColor: reading.isMissing
                ? Colors.red.withValues(alpha: 0.15)
                : Colors.teal.withValues(alpha: 0.15),
            labelStyle: TextStyle(
              color: reading.isMissing
                  ? Colors.red.shade700
                  : Colors.teal.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => readings.length;

  @override
  int get selectedRowCount => 0;
}
