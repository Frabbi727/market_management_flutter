import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_navigation_rail.dart';
import 'app_top_bar.dart';

class MainLayout extends ConsumerWidget {
  final Widget child;
  final Function(String) onNavigate;
  final String currentPageTitle;

  const MainLayout({
    super.key,
    required this.child,
    required this.onNavigate,
    required this.currentPageTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Row(
        children: [
          // Left Navigation Rail
          AppNavigationRail(onDestinationSelected: onNavigate),

          const VerticalDivider(thickness: 1, width: 1),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Bar
                AppTopBar(
                  title: currentPageTitle,
                  onMenuToggle: () {
                    final currentState = ref.read(navRailExpandedProvider);
                    ref.read(navRailExpandedProvider.notifier).state = !currentState;
                  },
                ),

                // Page Content
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}