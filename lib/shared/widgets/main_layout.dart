import 'package:flutter/material.dart';
import 'app_navigation_rail.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final Function(String) onNavigate;

  const MainLayout({
    super.key,
    required this.child,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Navigation Rail
          AppNavigationRail(onDestinationSelected: onNavigate),

          const VerticalDivider(thickness: 1, width: 1),

          // Main Content Area
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}