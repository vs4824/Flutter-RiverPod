import 'package:flutter/material.dart';
import '../utils/colors.dart';

class YellowButtonWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  const YellowButtonWidget({
    Key? key,
    required this.text,
    required this.fontSize,
    this.backgroundColor = kYellowButtonColor,
    this.textColor = Colors.white,
    this.margin,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: padding == null ? 45 : null,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
