import 'package:flutter/material.dart';

import '../../../utils/colors.dart';


class VegIndicatorWidget extends StatelessWidget {
  const VegIndicatorWidget({
    Key? key,
    required this.isVeg,
  }) : super(key: key);

  final bool isVeg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isVeg ? kVegColor : kNonVegColor,
        borderRadius: const BorderRadius.all(Radius.circular(2)),
      ),
      child: Container(
        height: 7,
        width: 7,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}
