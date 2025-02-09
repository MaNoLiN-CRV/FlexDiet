import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final double width;
  final double height;
  final double borderRadius;
  final double textSize;
  final FontWeight textStyle;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.blue,
    this.width = double.infinity,
    this.height = 50,
    this.borderRadius = 10,
    this.textSize = 16,
    this.textStyle = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: textSize,
            fontWeight: textStyle,
          ),
        ),
      ),
    );
  }
}
