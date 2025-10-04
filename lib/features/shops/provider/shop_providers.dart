import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dashboard/models/shop_model.dart';
import '../models/meter_model.dart';
import '../models/shop_reading_model.dart';
import '../../dashboard/models/invoice.dart';
import '../service/shop_service.dart';

// ============ FILTER STATE ============

class ShopFilters {
  final String? search;
  final int? marketId;
  final int? floor;
  final String? side;
  final bool? active;
  final String? sortBy;
  final String? sortOrder;

  const ShopFilters({
    this.search,
    this.marketId,
    this.floor,
    this.side,
    this.active,
    this.sortBy = 'code',
    this.sortOrder = 'asc',
  });

  ShopFilters copyWith({
    String? search,
    int? marketId,
    int? floor,
    String? side,
    bool? active,
    String? sortBy,
    String? sortOrder,
  }) {
    return ShopFilters(
      search: search ?? this.search,
      marketId: marketId ?? this.marketId,
      floor: floor ?? this.floor,
      side: side ?? this.side,
      active: active ?? this.active,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class ShopFiltersNotifier extends Notifier<ShopFilters> {
  @override
  ShopFilters build() => const ShopFilters();

  void setSearch(String? value) {
    state = state.copyWith(search: value);
  }

  void setMarketId(int? value) {
    state = state.copyWith(marketId: value);
  }

  void setFloor(int? value) {
    state = state.copyWith(floor: value);
  }

  void setSide(String? value) {
    state = state.copyWith(side: value);
  }

  void setActive(bool? value) {
    state = state.copyWith(active: value);
  }

  void setSortBy(String? value) {
    state = state.copyWith(sortBy: value);
  }

  void setSortOrder(String? value) {
    state = state.copyWith(sortOrder: value);
  }

  void reset() {
    state = const ShopFilters();
  }
}

final shopFiltersProvider = NotifierProvider<ShopFiltersNotifier, ShopFilters>(
  ShopFiltersNotifier.new,
);

// ============ SELECTED SHOP STATE ============

class SelectedShopNotifier extends Notifier<ShopModel?> {
  @override
  ShopModel? build() => null;

  void selectShop(ShopModel? shop) => state = shop;

  void clearSelection() => state = null;
}

final selectedShopProvider =
    NotifierProvider<SelectedShopNotifier, ShopModel?>(
  SelectedShopNotifier.new,
);

// ============ SHOPS LIST ============

final shopsListProvider = FutureProvider.autoDispose<List<ShopModel>>((ref) async {
  final service = ref.watch(shopServiceProvider);
  final filters = ref.watch(shopFiltersProvider);

  return await service.getShops(
    search: filters.search,
    marketId: filters.marketId,
    floor: filters.floor,
    side: filters.side,
    active: filters.active,
    sortBy: filters.sortBy,
    sortOrder: filters.sortOrder,
  );
});

// ============ SINGLE SHOP ============

final shopByIdProvider = FutureProvider.autoDispose.family<ShopModel, int>(
  (ref, shopId) async {
    final service = ref.watch(shopServiceProvider);
    return await service.getShopById(shopId);
  },
);

// ============ SHOP METERS ============

final shopMetersProvider = FutureProvider.autoDispose.family<List<MeterModel>, int>(
  (ref, shopId) async {
    final service = ref.watch(shopServiceProvider);
    return await service.getShopMeters(shopId);
  },
);

// ============ SHOP READINGS ============

class ShopReadingsParams {
  final int shopId;
  final String? period;

  const ShopReadingsParams({
    required this.shopId,
    this.period,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopReadingsParams &&
          runtimeType == other.runtimeType &&
          shopId == other.shopId &&
          period == other.period;

  @override
  int get hashCode => shopId.hashCode ^ period.hashCode;
}

final shopReadingsProvider = FutureProvider.autoDispose
    .family<List<ShopReadingModel>, ShopReadingsParams>(
  (ref, params) async {
    final service = ref.watch(shopServiceProvider);
    return await service.getShopReadings(
      shopId: params.shopId,
      period: params.period,
    );
  },
);

// ============ SHOP INVOICES ============

class ShopInvoicesParams {
  final int shopId;
  final String? period;

  const ShopInvoicesParams({
    required this.shopId,
    this.period,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopInvoicesParams &&
          runtimeType == other.runtimeType &&
          shopId == other.shopId &&
          period == other.period;

  @override
  int get hashCode => shopId.hashCode ^ period.hashCode;
}

final shopInvoicesProvider =
    FutureProvider.autoDispose.family<List<Content>, ShopInvoicesParams>(
  (ref, params) async {
    final service = ref.watch(shopServiceProvider);
    return await service.getShopInvoices(
      shopId: params.shopId,
      period: params.period,
    );
  },
);