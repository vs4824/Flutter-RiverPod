import 'package:flutter/material.dart';
import 'package:riverpod_examples/view/restaurant_screen/widgets/veg_indicator_widget.dart';

import '../../../utils/colors.dart';

class VegNVegWidget extends StatelessWidget {
  final bool isVeg;
  final bool isTapped;
  const VegNVegWidget({
    Key? key,
    required this.isVeg,
    required this.isTapped,
    // required this.title, required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: isTapped ? kScaffoldBackgroundColor : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isTapped ? kAccentColor : kBoxBorderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          VegIndicatorWidget(isVeg: isVeg),
          const SizedBox(width: 10),
          Text(
            isVeg ? "Veg" : "Non-Veg",
            style: const TextStyle(
              fontSize: 11.5,
            ),
          )
        ],
      ),
    );
  }
}
