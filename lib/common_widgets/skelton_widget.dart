import 'package:flutter/material.dart';

class Skelton extends StatelessWidget {
  final double? height, width, radius;
  final EdgeInsets? margin;
  const Skelton({
    Key? key,
    this.height,
    this.width,
    this.margin,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        // color: Colors.black.withOpacity(0.04),
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius == null ? 8.0 : radius!),
      ),
    );
  }
}
