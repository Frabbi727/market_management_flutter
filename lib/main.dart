import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_routes.dart';
import 'shared/widgets/main_layout.dart';
import 'features/dashboard/ui/dashboard_screen.dart';
import 'features/shops/ui/shops_screen.dart';
import 'features/meters/ui/meters_screen.dart';
import 'features/tariffs/ui/tariffs_screen.dart';
import 'features/monthly_inputs/ui/monthly_inputs_screen.dart';
import 'features/billing/ui/billing_screen.dart';
import 'features/invoices/ui/invoices_screen.dart';
import 'features/reports/ui/reports_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  String _currentRoute = AppRoutes.dashboard;

  void _navigateTo(String route) {
    setState(() {
      _currentRoute = route;
    });
  }

  Widget _getCurrentScreen() {
    switch (_currentRoute) {
      case AppRoutes.dashboard:
        return const DashboardScreen();
      case AppRoutes.shops:
        return const ShopsScreen();
      case AppRoutes.meters:
        return const MetersScreen();
      case AppRoutes.tariffs:
        return const TariffsScreen();
      case AppRoutes.monthlyInputs:
        return const MonthlyInputsScreen();
      case AppRoutes.billing:
        return const BillingScreen();
      case AppRoutes.invoices:
        return const InvoicesScreen();
      case AppRoutes.reports:
        return const ReportsScreen();
      default:
        return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      onNavigate: _navigateTo,
      child: _getCurrentScreen(),
    );
  }
}
