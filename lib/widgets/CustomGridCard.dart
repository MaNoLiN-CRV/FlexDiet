import 'package:flutter/material.dart';

/// A card widget that arranges its children in a symmetrical grid layout, styled with theme data
///
/// The widgets within `GridCard` are distributed symmetrically, occupying the available space.
///
/// Example usage:
///
/// ```dart
/// GridCard(
///   cardTheme: CardTheme(
///     color: Colors.blue[100],
///     elevation: 4,
///   ),
///   columns: 3,
///   columnSpace: 8.0,
///   rowSpace: 8.0,
///   children: [
///     Container(color: Colors.red,   child: Center(child: Text('1'))),
///     Container(color: Colors.blue,  child: Center(child: Text('2'))),
///     Container(color: Colors.green, child: Center(child: Text('3'))),
///     Container(color: Colors.yellow,child: Center(child: Text('4'))),
///     Container(color: Colors.orange,child: Center(child: Text('5'))),
///     Container(color: Colors.purple,child: Center(child: Text('6'))),
///   ],
/// )
/// ```
/// - Columns : The number of columns in the grid.
/// - ColumnSpace : Horizontal space between each column.
/// - RowSpace : Vertical space between each row.
/// - Children : The widgets that will be displayed within the grid card.
/// - Padding : The padding around the GridView within the card.
/// - CardTheme : Defines the visual properties of the card, such as color, elevation, and shape.
///
///  Warning: If no cardTheme is provided, the `GridCard` will use the default `CardTheme` from the ambient theme. 

class GridCard extends StatelessWidget {

  final List<Widget> children;
  final int columns;
  final double columnSpace;
  final double rowSpace;
  final EdgeInsetsGeometry padding;
  final CardTheme? cardTheme;

  GridCard({
    super.key,
    required this.children,
    this.columns = 2,
    this.columnSpace = 8.0,
    this.rowSpace = 8.0,
    this.padding = const EdgeInsets.all(16.0),
    this.cardTheme,
  }) : assert(children.isNotEmpty, 'Children list cannot be empty');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveCardTheme = cardTheme ?? theme.cardTheme;

    Color? cardColor;
    ShapeBorder? cardShape;
    Clip? cardClipBehavior;
    double? cardElevation;
    Color? cardShadowColor;
    Color? cardSurfaceTintColor;

    if (effectiveCardTheme != null) {
      final CardTheme themeData = effectiveCardTheme as CardTheme; 
      cardColor = themeData.color;
      cardShape = themeData.shape;
      cardClipBehavior = themeData.clipBehavior;
      cardElevation = themeData.elevation;
      cardShadowColor = themeData.shadowColor;
      cardSurfaceTintColor = themeData.surfaceTintColor;
    }

    return Card(
      color: cardColor,
      shape: cardShape,
      clipBehavior: cardClipBehavior,
      elevation: cardElevation,
      shadowColor: cardShadowColor,
      surfaceTintColor: cardSurfaceTintColor,
      child: Padding(
        padding: padding,
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: columns,
          crossAxisSpacing: columnSpace,
          mainAxisSpacing: rowSpace,
          children: children,
        ),
      ),
    );
  }
}