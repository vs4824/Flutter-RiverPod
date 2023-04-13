import 'package:flutter/material.dart';
import '../utils/colors.dart';

class LightTextRow extends StatelessWidget {
  final String text, price;
  const LightTextRow({
    Key? key,
    required this.text,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(color: kLightTextColor),
          ),
          Text(
            price,
            style: const TextStyle(color: kLightTextColor),
          ),
        ],
      ),
    );
  }
}
