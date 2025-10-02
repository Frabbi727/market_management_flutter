import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_routes.dart';

// Navigation state provider using NotifierProvider for Riverpod 3.x
class SelectedNavIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

final selectedNavIndexProvider =
    NotifierProvider<SelectedNavIndexNotifier, int>(
      SelectedNavIndexNotifier.new,
    );

// Navigation rail expanded state provider using NotifierProvider for Riverpod 3.x
class NavRailExpandedNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
}

final navRailExpandedProvider = NotifierProvider<NavRailExpandedNotifier, bool>(
  NavRailExpandedNotifier.new,
);

class AppNavigationRail extends ConsumerWidget {
  final Function(String) onDestinationSelected;

  const AppNavigationRail({super.key, required this.onDestinationSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedNavIndexProvider);
    final wantsExtended = ref.watch(navRailExpandedProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    const double collapsedWidth = 80;
    const double extendedWidth = 280;
    const double extendedContentBreakpoint = 200;

    // Auto-collapse on small screens; delay label reveal until there is room.
    final targetIsExtended = wantsExtended && screenWidth > 768;
    final targetWidth = targetIsExtended ? extendedWidth : collapsedWidth;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: targetWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A237E), // Deep indigo
            const Color(0xFF283593), // Medium indigo
            const Color(0xFF3949AB), // Lighter indigo
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final canShowExtendedContent =
              targetIsExtended &&
              constraints.maxWidth >= extendedContentBreakpoint;

          return Column(
            children: [
              // Logo/Header section
              Container(
                padding: EdgeInsets.all(canShowExtendedContent ? 24 : 12),
                child: canShowExtendedContent
                    ? Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.bolt_rounded,
                              color: Colors.amber,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Market',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Management',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    letterSpacing: 1.5,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.bolt_rounded,
                            color: Colors.amber,
                            size: 28,
                          ),
                        ),
                      ),
              ),

              // Divider
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0),
                      Colors.white.withValues(alpha: 0.3),
                      Colors.white.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Navigation items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _buildNavItem(
                      context,
                      ref,
                      index: 0,
                      icon: Icons.dashboard_outlined,
                      selectedIcon: Icons.dashboard_rounded,
                      label: 'Dashboard',
                      showLabel: canShowExtendedContent,
                      isSelected: selectedIndex == 0,
                    ),
                    const SizedBox(height: 4),
                    _buildNavItem(
                      context,
                      ref,
                      index: 1,
                      icon: Icons.store_outlined,
                      selectedIcon: Icons.store_rounded,
                      label: 'Shops',
                      showLabel: canShowExtendedContent,
                      isSelected: selectedIndex == 1,
                    ),
                    const SizedBox(height: 4),
                    _buildNavItem(
                      context,
                      ref,
                      index: 2,
                      icon: Icons.electric_meter_outlined,
                      selectedIcon: Icons.electric_meter_rounded,
                      label: 'Meters & Readings',
                      showLabel: canShowExtendedContent,
                      isSelected: selectedIndex == 2,
                    ),
                    const SizedBox(height: 4),
                    _buildNavItem(
                      context,
                      ref,
                      index: 3,
                      icon: Icons.attach_money_outlined,
                      selectedIcon: Icons.attach_money_rounded,
                      label: 'Tariffs',
                      showLabel: canShowExtendedContent,
                      isSelected: selectedIndex == 3,
                    ),
                    const SizedBox(height: 4),
                    _buildNavItem(
                      context,
                      ref,
                      index: 4,
                      icon: Icons.input_outlined,
                      selectedIcon: Icons.input_rounded,
                      label: 'Monthly Inputs',
                      showLabel: canShowExtendedContent,
                      isSelected: selectedIndex == 4,
                    ),
                    const SizedBox(height: 4),
                    _buildNavItem(
                      context,
                      ref,
                      index: 5,
                      icon: Icons.calculate_outlined,
                      selectedIcon: Icons.calculate_rounded,
                      label: 'Billing',
                      showLabel: canShowExtendedContent,
                      isSelected: selectedIndex == 5,
                    ),
                    const SizedBox(height: 4),
                    _buildNavItem(
                      context,
                      ref,
                      index: 6,
                      icon: Icons.receipt_long_outlined,
                      selectedIcon: Icons.receipt_long_rounded,
                      label: 'Invoices',
                      showLabel: canShowExtendedContent,
                      isSelected: selectedIndex == 6,
                    ),
                    const SizedBox(height: 4),
                    _buildNavItem(
                      context,
                      ref,
                      index: 7,
                      icon: Icons.assessment_outlined,
                      selectedIcon: Icons.assessment_rounded,
                      label: 'Reports',
                      showLabel: canShowExtendedContent,
                      isSelected: selectedIndex == 7,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    WidgetRef ref, {
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required bool showLabel,
    required bool isSelected,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ref.read(selectedNavIndexProvider.notifier).setIndex(index);
          onDestinationSelected(_getRouteForIndex(index));
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: showLabel ? 16 : 12,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Colors.white.withValues(alpha: 0.3)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: showLabel
              ? Row(
                  children: [
                    Icon(
                      isSelected ? selectedIcon : icon,
                      color: isSelected ? Colors.amber : Colors.white70,
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 15,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          letterSpacing: 0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    if (isSelected)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                )
              : Center(
                  child: Icon(
                    isSelected ? selectedIcon : icon,
                    color: isSelected ? Colors.amber : Colors.white70,
                    size: 22,
                  ),
                ),
        ),
      ),
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
