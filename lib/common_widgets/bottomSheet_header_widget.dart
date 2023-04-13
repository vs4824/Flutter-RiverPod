import 'package:flutter/material.dart';

class BottomSheetHeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const BottomSheetHeaderWidget({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: onTap,
            child: const Icon(Icons.close_rounded),
          )
        ],
      ),
    );
  }
}
