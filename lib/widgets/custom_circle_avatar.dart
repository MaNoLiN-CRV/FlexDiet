import 'package:flutter/material.dart';

/// A custom circle avatar widget that displays an image from the network with a transparent background.
/// It can be tapped to perform an action.
/// If the image fails to load and a placeholder is provided, the placeholder image will be displayed.
///
/// Example usage:
/// ```dart
/// CustomCircleAvatar(
///   image: 'https://example.com/avatar.jpg',
///   onTap: () {
///     // Perform action when tapped
///   },
///   radius: 50,
///   placeHolder: 'https://example.com/placeholder.jpg',
/// )
/// ```
class CustomCircleAvatar extends StatefulWidget {

  final VoidCallback? onTap;
  final String image;
  final double? radius;
  final String? placeHolder;

  const CustomCircleAvatar({
    super.key,
    this.onTap,
    required this.image,
    this.radius,
    this.placeHolder,
  });

  @override
  State<CustomCircleAvatar> createState() => _CustomCircleAvatarState();
}

class _CustomCircleAvatarState extends State<CustomCircleAvatar> {
  late String _currentImage;

  @override
  void initState() {
    super.initState();
    _currentImage = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: CircleAvatar(
        backgroundImage: NetworkImage(_currentImage),
        radius: widget.radius,
        backgroundColor: Colors.transparent,
        onBackgroundImageError: (_, __) {
          if (widget.placeHolder != null && _currentImage != widget.placeHolder) {
            setState(() {
              _currentImage = widget.placeHolder!;
            });
          }
        },
      ),
    );
  }
}