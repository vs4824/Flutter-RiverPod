import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {
  final String rating;
  const StarRatingWidget({
    Key? key,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffFFFBF1),
        border: Border.all(
          color: const Color(0xffF7B917),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            size: 13,
            color: Color(0xffF7B917),
          ),
          const SizedBox(width: 3),
          Text(
            rating,
            style: const TextStyle(
              color: Color(0xffF7B917),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
