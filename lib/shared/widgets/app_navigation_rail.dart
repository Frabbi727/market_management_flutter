import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_routes.dart';

// Navigation state provider
final selectedNavIndexProvider = StateProvider<int>((ref) => 0);

class AppNavigationRail extends ConsumerWidget {
  final Function(String) onDestinationSelected;

  const AppNavigationRail({
    super.key,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedNavIndexProvider);

    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        ref.read(selectedNavIndexProvider.notifier).state = index;
        onDestinationSelected(_getRouteForIndex(index));
      },
      labelType: NavigationRailLabelType.all,
      backgroundColor: Colors.white,
      elevation: 1,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.store_outlined),
          selectedIcon: Icon(Icons.store),
          label: Text('Shops'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.electric_meter_outlined),
          selectedIcon: Icon(Icons.electric_meter),
          label: Text('Meters & Readings'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.attach_money_outlined),
          selectedIcon: Icon(Icons.attach_money),
          label: Text('Tariffs'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.input_outlined),
          selectedIcon: Icon(Icons.input),
          label: Text('Monthly Inputs'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.calculate_outlined),
          selectedIcon: Icon(Icons.calculate),
          label: Text('Billing'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.receipt_outlined),
          selectedIcon: Icon(Icons.receipt),
          label: Text('Invoices'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.assessment_outlined),
          selectedIcon: Icon(Icons.assessment),
          label: Text('Reports'),
        ),
      ],
    );
  }

  String _getRouteForIndex(int index) {
    switch (index) {
      case 0:
        return AppRoutes.dashboard;
      case 1:
        return AppRoutes.shops;
      case 2:
        return AppRoutes.meters;
      case 3:
        return AppRoutes.tariffs;
      case 4:
        return AppRoutes.monthlyInputs;
      case 5:
        return AppRoutes.billing;
      case 6:
        return AppRoutes.invoices;
      case 7:
        return AppRoutes.reports;
      default:
        return AppRoutes.dashboard;
    }
  }
}