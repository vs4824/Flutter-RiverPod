import 'package:flutter/material.dart';

import '../utils/colors.dart';

class TextIconBtn extends StatelessWidget {
  final String text;
  final Image? icon;
  const TextIconBtn({
    Key? key,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(right: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: kBoxBorderColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Color(0xff667083),
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 5),
          if (icon != null) icon!,
        ],
      ),
    );
  }
}
