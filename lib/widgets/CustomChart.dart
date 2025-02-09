import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// A generic, reusable chart widget that uses the charts_flutter library.
///
/// This widget takes a list of data and a series builder function to create
/// a line chart.  It's designed to be flexible and work with different data
/// types.
///
/// Example Usage:
///
/// ```dart
/// class SalesData {
///   final int year;
///   final int sales;
///
///   SalesData(this.year, this.sales);
/// }
///
/// CustomChart<SalesData, int>(
///   data: [
///     SalesData(2020, 100),
///     SalesData(2021, 150),
///     SalesData(2022, 200),
///   ],
///   seriesBuilder: (List<SalesData> data) {
///     return charts.Series<SalesData, int>(
///       id: 'Sales',
///       domainFn: (SalesData sales, _) => sales.year,
///       measureFn: (SalesData sales, _) => sales.sales,
///       data: data,
///     );
///   },
/// )
/// ```
class CustomChart<T, D> extends StatelessWidget {
  final List<T> data;
  final charts.Series<T, D> Function(List<T>) seriesBuilder;
  const CustomChart(
      {super.key, required this.data, required this.seriesBuilder});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<T, D>> series = [seriesBuilder(data)];
    return charts.LineChart(
      series.cast<charts.Series<dynamic, num>>(),
      animate: true,
    );
  }
}
