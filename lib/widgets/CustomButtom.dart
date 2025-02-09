import 'package:flutter/material.dart';

/// A customizable button widget.
///
/// This widget extends [ElevatedButton] and allows for customization of text,
/// action, appearance, icon, and layout.  It uses the current theme for default
/// styling.
///
/// Example usage:
///
/// ```dart
/// CustomButton(
///   text: 'Save',
///   onPressed: () {
///     // Save logic here
///   },
///   icon: Icons.save,
/// )
/// ```
/// Advanced usage:
///
/// ```dart
/// CustomButton(
///   text: 'Save',
///   onPressed: () {
///     // Save logic here
///   },
///   icon: Icons.save,
///   style: ElevatedButton.styleFrom(
///     backgroundColor: Colors.green,
///     shape: RoundedRectangleBorder(
///       borderRadius: BorderRadius.circular(8),
///     ),
///   ),
/// )
/// ```

class CustomButton extends StatelessWidget {
  /// The text displayed on the button.
  final String text;

  /// The callback function when the button is pressed.
  final VoidCallback onPressed;

  /// The [ButtonStyle] to customize the button's appearance.  If null, a
  /// default style based on the current theme is used.
  final ButtonStyle? style;

  /// The [TextStyle] to customize the button text. If null, the theme's
  /// `textTheme.labelLarge` style is used.
  final TextStyle? textStyle;

  /// An optional [IconData] to display before the button text.
  final IconData? icon;

  /// The size of the icon. Defaults to 20.0.
  final double iconSize;

  /// How the children of the [Row] should be aligned along the main axis.
  /// Defaults to [MainAxisAlignment.center].
  final MainAxisAlignment mainAxisAlignment;

  /// Creates a custom button.
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style,
    this.textStyle,
    this.icon,
    this.iconSize = 20.0,
    this.mainAxisAlignment = MainAxisAlignment.center,
    required Color backgroundColor,
    required Color textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = ElevatedButton.styleFrom(
      textStyle: textStyle ?? theme.textTheme.labelLarge,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: style ?? defaultStyle,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: theme.colorScheme.onPrimary),
            const SizedBox(width: 8),
          ],
          Text(text,
              style: textStyle ??
                  theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  )),
        ],
      ),
    );
  }
}
