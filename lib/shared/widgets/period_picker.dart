import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PeriodPicker extends StatelessWidget {
  final String currentPeriod;
  final Function(String) onPeriodChanged;

  const PeriodPicker({
    super.key,
    required this.currentPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => _changePeriod(-1),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => _showPeriodDialog(context),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    _formatPeriod(currentPeriod),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => _changePeriod(1),
            ),
          ],
        ),
      ),
    );
  }

  void _changePeriod(int months) {
    try {
      final date = DateFormat('yyyy-MM').parse(currentPeriod);
      final newDate = DateTime(date.year, date.month + months);
      final newPeriod = DateFormat('yyyy-MM').format(newDate);
      onPeriodChanged(newPeriod);
    } catch (e) {
      print('Error changing period: $e');
    }
  }

  String _formatPeriod(String period) {
    try {
      final date = DateFormat('yyyy-MM').parse(period);
      return DateFormat('MMMM yyyy').format(date);
    } catch (e) {
      return period;
    }
  }

  Future<void> _showPeriodDialog(BuildContext context) async {
    final date = DateFormat('yyyy-MM').parse(currentPeriod);
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null) {
      final newPeriod = DateFormat('yyyy-MM').format(picked);
      onPeriodChanged(newPeriod);
    }
  }
}