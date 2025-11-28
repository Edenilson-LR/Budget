import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/app_data_provider.dart';
import '../widgets/custom_card.dart';
import '../utils/formatters.dart';
import '../models/transaction.dart';

class BudgetView extends StatefulWidget {
  const BudgetView({super.key});

  @override
  State<BudgetView> createState() => _BudgetViewState();
}

class _BudgetViewState extends State<BudgetView> {
  String _chartType = 'pie';

  @override
  Widget build(BuildContext context) {
    return Consumer<AppDataProvider>(
      builder: (context, provider, _) {
        final data = provider.appData;
        final theme = Theme.of(context);
        final now = DateTime.now();

        // Calculate expenses by category
        final expensesByCategory = data.categories
            .where((c) => c.type == TransactionType.expense)
            .map((cat) {
          final total = data.transactions
              .where((t) =>
                  t.categoryId == cat.id &&
                  t.type == TransactionType.expense &&
                  t.date.year == now.year &&
                  t.date.month == now.month)
              .fold<double>(0, (sum, t) => sum + t.amount);
          return {'category': cat, 'total': total};
        }).toList()
          ..sort((a, b) => (b['total'] as double).compareTo(a['total'] as double));

        // Prepare chart data
        final pieData = expensesByCategory
            .map((item) => {
                  'name': (item['category'] as dynamic).name,
                  'value': item['total'] as double,
                  'color': (item['category'] as dynamic).color,
                  'icon': (item['category'] as dynamic).icon,
                })
            .toList();

        // Area chart data (balance trend)
        final sortedTx = List.from(data.transactions)
          ..sort((a, b) => a.date.compareTo(b.date));
        final dates = sortedTx.map((t) => t.date).toSet().toList()..sort();
        double cumulative = 0;
        final areaData = dates.map((date) {
          final dayTx = sortedTx.where((t) =>
              t.date.year == date.year &&
              t.date.month == date.month &&
              t.date.day == date.day);
          final dayNet = dayTx.fold<double>(
              0,
              (acc, t) => acc +
                  (t.type == TransactionType.income ? t.amount : -t.amount));
          cumulative += dayNet;
          return {'date': date, 'value': cumulative};
        }).toList();

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Presupuesto & Gráficos',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Chart Type Selector
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildChartTypeButton(
                            context,
                            'pie',
                            Icons.pie_chart,
                            'Categorías',
                          ),
                        ),
                        Expanded(
                          child: _buildChartTypeButton(
                            context,
                            'bar',
                            Icons.bar_chart,
                            'Barras',
                          ),
                        ),
                        Expanded(
                          child: _buildChartTypeButton(
                            context,
                            'area',
                            Icons.show_chart,
                            'Tendencia',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Chart
                  CustomCard(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 300,
                      child: _chartType == 'pie'
                          ? _buildPieChart(pieData, theme)
                          : _chartType == 'bar'
                              ? _buildBarChart(pieData, theme)
                              : _buildAreaChart(areaData, theme),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Budget Categories
                  ...expensesByCategory.map((item) {
                    final cat = item['category'] as dynamic;
                    final total = item['total'] as double;
                    final percentage = cat.budgetLimit > 0
                        ? (total / cat.budgetLimit * 100).clamp(0, 100)
                        : 0.0;
                    return CustomCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(cat.icon, style: const TextStyle(fontSize: 20)),
                                  const SizedBox(width: 8),
                                  Text(
                                    cat.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${formatCurrency(total, 'USD', data.currencies)}${cat.budgetLimit > 0 ? ' / ${formatCurrency(cat.budgetLimit, 'USD', data.currencies)}' : ''}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          if (cat.budgetLimit > 0) ...[
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: percentage / 100,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  percentage > 90
                                      ? Colors.red
                                      : Color(int.parse(
                                          cat.color.replaceFirst('#', '0xFF'))),
                                ),
                                minHeight: 8,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChartTypeButton(
    BuildContext context,
    String type,
    IconData icon,
    String label,
  ) {
    final isSelected = _chartType == type;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => setState(() => _chartType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (theme.brightness == Brightness.dark
                  ? const Color(0xFF334155)
                  : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFF6B7280),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF3B82F6)
                    : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(List<dynamic> data, ThemeData theme) {
    if (data.isEmpty) {
      return const Center(child: Text('No hay datos'));
    }
    return PieChart(
      PieChartData(
        sections: data.asMap().entries.map((entry) {
          final item = entry.value;
          return PieChartSectionData(
            value: item['value'] as double,
            color: Color(int.parse(
                (item['color'] as String).replaceFirst('#', '0xFF'))),
            title: '',
            radius: 75,
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 55,
      ),
    );
  }

  Widget _buildBarChart(List<dynamic> data, ThemeData theme) {
    if (data.isEmpty) {
      return const Center(child: Text('No hay datos'));
    }
    final top5 = data.take(5).toList();
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (data.map((d) => d['value'] as double).reduce((a, b) => a > b ? a : b) * 1.2),
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= top5.length) return const Text('');
                final item = top5[value.toInt()];
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    item['icon'] as String,
                    style: TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: top5.asMap().entries.map((entry) {
          final item = entry.value;
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: item['value'] as double,
                color: Color(int.parse(
                    (item['color'] as String).replaceFirst('#', '0xFF'))),
                width: 20,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(6),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAreaChart(List<dynamic> data, ThemeData theme) {
    if (data.isEmpty) {
      return const Center(child: Text('No hay datos'));
    }
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value['value'] as double);
            }).toList(),
            isCurved: true,
            color: const Color(0xFF3B82F6),
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF3B82F6).withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}

