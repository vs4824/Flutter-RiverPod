import 'package:flutter/material.dart';
import '../utils/colors.dart';

class DarkTextRow extends StatelessWidget {
  final String title, price;
  const DarkTextRow({
    Key? key,
    required this.title,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            price,
            style: const TextStyle(color: kAccentColor),
          ),
        ],
      ),
    );
  }
}
