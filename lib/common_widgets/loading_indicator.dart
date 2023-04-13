import 'package:flutter/material.dart';
import '../utils/colors.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: kYellowButtonColor,
        strokeWidth: 2.5,
      ),
    );
  }
}
