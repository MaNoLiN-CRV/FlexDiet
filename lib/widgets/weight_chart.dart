import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:flutter_flexdiet/models/final_models/historical_bodyweight.dart';

class WeightChart extends StatelessWidget {
  final List<HistoricalBodyweight> weightHistory;

  const WeightChart({
    super.key,
    required this.weightHistory,
  });

  @override
  Widget build(BuildContext context) {
    // If less than 3 records, don't show the chart
    if (weightHistory.length < 3) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final textColor =
        isDarkMode ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;
    final secondaryTextColor =
        isDarkMode ? Colors.grey[400] : theme.colorScheme.inversePrimary;
    final gridLineColor = isDarkMode
        ? Colors.grey[800]!
        : theme.colorScheme.outline.withValues(alpha: 0.1);
    final backgroundColor =
        isDarkMode ? Colors.grey[900] : theme.colorScheme.surface;

    // Sort weight history by date
    final sortedHistory = List<HistoricalBodyweight>.from(weightHistory)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Calculate min and max values for Y axis
    final minWeight = sortedHistory.map((e) => e.weight).reduce(min);
    final maxWeight = sortedHistory.map((e) => e.weight).reduce(max);
    final padding = (maxWeight - minWeight) * 0.1;

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
            'Últimos ${sortedHistory.length} registros',
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
                        if (index >= 0 && index < sortedHistory.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              DateFormat('dd/MM')
                                  .format(sortedHistory[index].date),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: textColor,
                              ),
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
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: textColor,
                          ),
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
                    spots: sortedHistory.asMap().entries.map((entry) {
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
                      color: theme.colorScheme.inversePrimary.withValues(
                        alpha: 0.2,
                      ),
                    ),
                  ),
                ],
                minY: minWeight - padding,
                maxY: maxWeight + padding,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
