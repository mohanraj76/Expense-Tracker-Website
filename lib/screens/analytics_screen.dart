import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense.dart';
import '../utils/category_icons.dart';

class AnalyticsScreen extends StatelessWidget {
  final List<Expense> expenses;

  const AnalyticsScreen({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Analytics'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildCategoryPieChart(context),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildDailyExpensesBarChart(context),
            ),
            _buildInsights(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPieChart(BuildContext context) {
    final Map<ExpenseCategory, double> data = {};
    for (var e in expenses) {
      data[e.category] = (data[e.category] ?? 0) + e.amount;
    }

    final total = data.values.fold(0.0, (sum, val) => sum + val);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spending by Category',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: data.entries.map((e) {
                    return PieChartSectionData(
                      value: e.value,
                      color: getCategoryColor(e.key),
                      title: '${(e.value / total * 100).toStringAsFixed(0)}%',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  sectionsSpace: 4,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLegend(context, data),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context, Map<ExpenseCategory, double> data) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: data.keys.map((cat) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: getCategoryColor(cat),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              cat.toString().split('.').last,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildDailyExpensesBarChart(BuildContext context) {
    // Simplified bar chart for last 7 days
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Spending (Last 7 Days)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 5000,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: const FlTitlesData(
                    show: true,
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 1200, color: Theme.of(context).colorScheme.primary)]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 800, color: Theme.of(context).colorScheme.primary)]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 2500, color: Theme.of(context).colorScheme.primary)]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 1500, color: Theme.of(context).colorScheme.primary)]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 3000, color: Theme.of(context).colorScheme.primary)]),
                    BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 500, color: Theme.of(context).colorScheme.primary)]),
                    BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 1800, color: Theme.of(context).colorScheme.primary)]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsights(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Smart Insights',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'You spent 15% less this week compared to last week. Great job on sticking to your budget!',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
