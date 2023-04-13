import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RoundedImageWidget extends StatelessWidget {
  final String image;
  final double height, width;
  const RoundedImageWidget({
    Key? key,
    required this.image,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: CachedNetworkImage(
        imageUrl: image,
        imageBuilder: (context, imageProvider) {
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Image(
              image: imageProvider,
              height: height,
              width: width,
              fit: BoxFit.cover,
            ),
          );
        },
        errorWidget: (context, url, error) {
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Image(
              image: const AssetImage("assets/images/first section.png"),
              height: height,
              width: width,
              fit: BoxFit.cover,
            ),
          );
        },
        placeholder: (context, url) {
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Image(
              image: const AssetImage("assets/images/first section.png"),
              height: height,
              width: width,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
