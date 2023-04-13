import 'package:flutter/material.dart';

import '../utils/colors.dart';

class SearchSuggestionWidget extends StatelessWidget {
  final String text;
  final bool isTrending;

  const SearchSuggestionWidget({
    Key? key,
    required this.text,
    required this.isTrending,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kBoxBorderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: AssetImage(isTrending
                ? 'assets/images/arrowtrending.png'
                : 'assets/images/recent.png'),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              color: kLightestTextColor,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
