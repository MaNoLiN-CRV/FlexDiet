import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeightData {
  final DateTime date;
  final double weight;

  WeightData(this.date, this.weight);
}

class WeightChart extends StatelessWidget {
  final List<WeightData> data = [
    WeightData(DateTime(2024, 1, 1), 80.5),
    WeightData(DateTime(2024, 1, 8), 79.8),
    WeightData(DateTime(2024, 1, 15), 79.2),
    WeightData(DateTime(2024, 1, 22), 78.9),
    WeightData(DateTime(2024, 1, 29), 78.3),
    WeightData(DateTime(2024, 2, 5), 77.8),
    WeightData(DateTime(2024, 2, 12), 77.2),
  ];

  WeightChart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final chartAreaColor = isDarkMode
        ? theme.colorScheme.inversePrimary.withValues(alpha: 0.2)
        : theme.colorScheme.inversePrimary.withValues(alpha: 0.2);
    final textColor = isDarkMode ? Colors.white : theme.colorScheme.onSurface;
    final secondaryTextColor =
        isDarkMode ? Colors.grey[400] : theme.colorScheme.inversePrimary;
    final gridLineColor = isDarkMode
        ? Colors.grey[800]!
        : theme.colorScheme.outline.withValues(alpha: 0.1);
    final dotColor = isDarkMode
        ? theme.colorScheme.inversePrimary
        : theme.colorScheme.inversePrimary;
    final backgroundColor =
        isDarkMode ? Colors.grey[900] : theme.colorScheme.surface;

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progreso de Peso',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Últimas 7 semanas',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: gridLineColor,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < data.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat('dd/MM').format(data[index].date),
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: textColor), // Use textColor
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}kg',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: textColor),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: data.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.weight);
                    }).toList(),
                    isCurved: true,
                    color: theme.colorScheme.inversePrimary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: theme.colorScheme.inversePrimary,
                        strokeWidth: 2,
                        strokeColor: theme.colorScheme.onInverseSurface,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: theme.colorScheme.inversePrimary
                          .withValues(alpha: 0.2),
                    ),
                  ),
                ],
                minY: 75,
                maxY: 82,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
