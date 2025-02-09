import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


/// CustomEnhancedScrollView Widget is a custom implementation of the [ScrollView] widget.
/// It provides a way to add custom slivers to the scrollable area of the widget.
/// Example usage:
/// ```dart
/// CustomEnhancedScrollView(
///   slivers: [
///     SliverToBoxAdapter(
///       child: Container(
///         height: 200,
///         color: Colors.red,
///       ),
///     ),
///     SliverToBoxAdapter(
///       child: Container(
///         height: 200,
///         color: Colors.green,
///       ),
///     ),
///   ],
/// )
/// ```
/// Advanced usage:
/// ```dart
/// CustomEnhancedScrollView(
///   slivers: [
///     SliverToBoxAdapter(
///       child: Container(
///         height: 200,
///         color: Colors.red,
///       ),
///     ),
///     SliverToBoxAdapter(
///       child: Container(
///         height: 200,
///         color: Colors.green,
///       ),
///     ),
///   ],
///   semanticChildCount: '2',
///   dragStartBehavior: DragStartBehavior.start,
///   keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
///   padding: const EdgeInsets.all(16.0),
///   scrollDirection: Axis.horizontal,
///   reverse: true,
///   controller: ScrollController(),
///   cachePixelsPercent: 0.3,
///   
/// )
/// ```
/// Props:
/// - slivers: A list of slivers to be added to the scrollable area of the widget.
/// - semanticChildCount: The number of semantic children in the scrollable area of the widget.
/// - dragStartBehavior: The behavior to use for determining the start of a drag gesture.
/// - keyboardDismissBehavior: The behavior to use for dismissing the keyboard.
/// - padding: The padding to apply to the scrollable area of the widget.
/// - scrollDirection: The direction to scroll the scrollable area of the widget.
/// - reverse: Whether to reverse the scrollable area of the widget.
/// - controller: The scroll controller to use for the scrollable area of the widget.
/// - cachePixelsPercent: The percentage of the scrollable area of the widget to cache. Example: 0.3 means 30% of the scrollable area will be cached.


class CustomEnhancedScrollView extends StatelessWidget {
  final List<Widget> slivers;
  final ScrollController? controller;
  final Axis scrollDirection;
  final bool reverse;
  final EdgeInsetsGeometry? padding;
  final String? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final double? cachePixelsPercent;

  CustomEnhancedScrollView({
    super.key,
    required this.slivers,
    this.controller,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.padding,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.cachePixelsPercent = 0.3,
  }) : assert(slivers.isNotEmpty, 'Slivers list cannot be empty');

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    

    return SafeArea(
      top: false,
      bottom: false,
      child: ScrollConfiguration(
        behavior: _CustomScrollBehavior(),
        child: CustomScrollView(
          controller: controller,
          scrollDirection: scrollDirection,
          reverse: reverse,
          shrinkWrap: false,
          center: null,
          anchor: 0.0,
          cacheExtent: _calculateCacheExtent(mediaQuery),
          semanticChildCount: semanticChildCount != null
              ? int.parse(semanticChildCount!)
              : null,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          slivers: <Widget>[
            if (padding != null)
              SliverPadding(
                padding: padding!,
                sliver: _SliverListWrapper(slivers: slivers),
              )
            else
              _SliverListWrapper(slivers: slivers),
          ],
        ),
      ),
    );
  }


  double _calculateCacheExtent(MediaQueryData mediaQuery) {
    return mediaQuery.orientation == Orientation.portrait
        ? mediaQuery.size.height * cachePixelsPercent!
        : mediaQuery.size.width * cachePixelsPercent!;
  }
}


class _SliverListWrapper extends StatelessWidget {
  final List<Widget> slivers;

  const _SliverListWrapper({required this.slivers});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => slivers[index],
        childCount: slivers.length,
      ),
    );
  }
}


class _CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return child;
    }
    return GlowingOverscrollIndicator(
      axisDirection: details.direction,
      color: Theme.of(context).colorScheme.secondary.withAlpha(76),
      child: child,
    );
  }

 
}