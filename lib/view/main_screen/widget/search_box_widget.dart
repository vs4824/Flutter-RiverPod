import 'package:flutter/material.dart';
import '../../../common_widgets/image_assets.dart';

class SearchBoxWidget extends StatelessWidget {
  final String hintText;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BoxBorder? border;
  final TextStyle? hintStyle;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Function(String value)? onChanged;
  final Widget? suffixIcon;
  final bool enabled, autofocus;
  const SearchBoxWidget({
    Key? key,
    required this.hintText,
    this.margin,
    this.backgroundColor = Colors.white,
    this.onChanged,
    this.border,
    this.controller,
    this.suffixIcon = searchIcon,
    this.enabled = true,
    this.autofocus = false,
    this.hintStyle = const TextStyle(
      color: Color(0xff7D8698),
      fontSize: 14,
    ),
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.only(left: 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: border,
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        autofocus: autofocus,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: hintStyle,
          suffixIcon: suffixIcon,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
