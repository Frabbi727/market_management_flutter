import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_theme.dart';
import '../../dashboard/models/shop_model.dart';
import '../provider/shop_providers.dart';
import 'widgets/add_shop_dialog.dart';

class ShopsScreen extends ConsumerStatefulWidget {
  const ShopsScreen({super.key});

  @override
  ConsumerState<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends ConsumerState<ShopsScreen> {
  final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '৳ ',
    decimalDigits: 0,
  );
  final NumberFormat _decimalFormat = NumberFormat('#,##0.##');

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shopsAsync = ref.watch(shopsListProvider);
    final selectedShop = ref.watch(selectedShopProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Row(
        children: [
          // Main content
          Expanded(
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                _buildFilters(),
                const SizedBox(height: 16),
                Expanded(
                  child: shopsAsync.when(
                    data: (shops) => _buildShopsTable(shops),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, _) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text('Error: ${error.toString()}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => ref.refresh(shopsListProvider),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right drawer
          if (selectedShop != null)
            Container(
              width: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(-2, 0),
                  ),
                ],
              ),
              child: _buildShopDrawer(selectedShop),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Shops',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Import CSV - Coming soon')),
              );
            },
            icon: const Icon(Icons.upload_file),
            label: const Text('Import'),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export CSV - Coming soon')),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Export'),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AddShopDialog(),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Shop'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final filters = ref.watch(shopFiltersProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by code, name, owner, registration...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    ref.read(shopFiltersProvider.notifier).setSearch(value);
                  },
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 150,
                child: DropdownButtonFormField<bool?>(
                  value: filters.active,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All')),
                    DropdownMenuItem(value: true, child: Text('Active')),
                    DropdownMenuItem(value: false, child: Text('Inactive')),
                  ],
                  onChanged: (value) {
                    ref.read(shopFiltersProvider.notifier).setActive(value);
                  },
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 150,
                child: DropdownButtonFormField<String>(
                  value: filters.sortBy,
                  decoration: InputDecoration(
                    labelText: 'Sort By',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'code', child: Text('Code')),
                    DropdownMenuItem(value: 'shopName', child: Text('Name')),
                    DropdownMenuItem(value: 'floor', child: Text('Floor')),
                    DropdownMenuItem(value: 'areaSqft', child: Text('Area')),
                    DropdownMenuItem(value: 'ownerName', child: Text('Owner')),
                  ],
                  onChanged: (value) {
                    ref.read(shopFiltersProvider.notifier).setSortBy(value);
                  },
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: Icon(
                  filters.sortOrder == 'asc'
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                ),
                onPressed: () {
                  ref.read(shopFiltersProvider.notifier).setSortOrder(
                        filters.sortOrder == 'asc' ? 'desc' : 'asc',
                      );
                },
              ),
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  ref.read(shopFiltersProvider.notifier).reset();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShopsTable(List<ShopModel> shops) {
    if (shops.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No shops found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            Colors.grey.withValues(alpha: 0.1),
          ),
          columns: const [
            DataColumn(label: Text('Code')),
            DataColumn(label: Text('Shop Name')),
            DataColumn(label: Text('Market • Floor • Side')),
            DataColumn(label: Text('Location No')),
            DataColumn(label: Text('Area (sqft)')),
            DataColumn(label: Text('Owner')),
            DataColumn(label: Text('Active')),
            DataColumn(label: Text('Actions')),
          ],
          rows: shops.map((shop) {
            final isSelected =
                ref.watch(selectedShopProvider)?.id == shop.id;

            return DataRow(
              selected: isSelected,
              onSelectChanged: (_) {
                ref.read(selectedShopProvider.notifier).selectShop(shop);
              },
              cells: [
                DataCell(
                  Text(
                    shop.code ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DataCell(Text(shop.shopName ?? '')),
                DataCell(
                  Text(
                    '${shop.market ?? ''} • F${shop.floor ?? ''} • ${shop.side ?? ''}',
                  ),
                ),
                DataCell(Text(shop.locationNo ?? '')),
                DataCell(
                  Text(
                    _decimalFormat.format(shop.areaSqft ?? 0),
                    textAlign: TextAlign.right,
                  ),
                ),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(shop.ownerName ?? ''),
                      if (shop.ownerPhone != null)
                        Text(
                          shop.ownerPhone!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                DataCell(
                  Chip(
                    label: Text((shop.active ?? false) ? 'Active' : 'Inactive'),
                    backgroundColor: (shop.active ?? false)
                        ? Colors.teal.withValues(alpha: 0.15)
                        : Colors.red.withValues(alpha: 0.15),
                    labelStyle: TextStyle(
                      color: (shop.active ?? false)
                          ? Colors.teal.shade700
                          : Colors.red.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility, size: 20),
                        onPressed: () {
                          ref
                              .read(selectedShopProvider.notifier)
                              .selectShop(shop);
                        },
                        tooltip: 'View Details',
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Edit ${shop.shopName} - Coming soon'),
                            ),
                          );
                        },
                        tooltip: 'Edit',
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildShopDrawer(ShopModel shop) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.shopName ?? 'Unnamed Shop',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      shop.code ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  ref.read(selectedShopProvider.notifier).clearSelection();
                },
              ),
            ],
          ),
        ),

        // Tabs (simplified - just showing overview for now)
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: _buildShopOverview(shop),
          ),
        ),
      ],
    );
  }

  Widget _buildShopOverview(ShopModel shop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoRow('Code', shop.code ?? ''),
        _buildInfoRow('Shop Name', shop.shopName ?? ''),
        _buildInfoRow('Market', shop.market ?? ''),
        _buildInfoRow('Floor', shop.floor?.toString() ?? ''),
        _buildInfoRow('Side', shop.side ?? ''),
        _buildInfoRow('Location', shop.location ?? ''),
        _buildInfoRow('Location No', shop.locationNo ?? ''),
        _buildInfoRow('Registration No', shop.registrationNo ?? ''),
        _buildInfoRow('Area (sqft)', _decimalFormat.format(shop.areaSqft ?? 0)),
        _buildInfoRow('Owner Name', shop.ownerName ?? ''),
        _buildInfoRow('Owner Phone', shop.ownerPhone ?? ''),
        _buildInfoRow('Remarks', shop.remarks ?? ''),
        _buildInfoRow(
          'Status',
          (shop.active ?? false) ? 'Active' : 'Inactive',
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}