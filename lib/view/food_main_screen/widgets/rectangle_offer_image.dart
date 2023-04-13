import 'package:flutter/material.dart';
import '../../../common_widgets/rounded_image_widget.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_styles.dart';


class RectangleOfferImage extends StatelessWidget {
  final String image;
  final String offer;
  final String offerType;
  final String? restaurantText;
  final String uptoValue;
  const RectangleOfferImage({
    Key? key,
    required this.image,
    required this.offer,
    this.restaurantText,
    required this.uptoValue,
    required this.offerType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 140,
          width: 120,
          margin: const EdgeInsets.only(right: 12),
          child: Stack(
            children: [
              RoundedImageWidget(
                image: image,
                height: 140,
                width: 120,
              ),
              // const ClipRRect(
              //   borderRadius: BorderRadius.all(Radius.circular(12)),
              //   child: FadeInImage(
              //     height: 140,
              //     width: 120,
              //     fit: BoxFit.cover,
              //     placeholder: AssetImage('assets/images/first section.png'),
              //     image: AssetImage('assets/images/food_image.jpeg'),
              //     placeholderFit: BoxFit.contain,
              //   ),
              // ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black,
                        Colors.black.withOpacity(0.5),
                        Colors.black45.withOpacity(0.0),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      offerType == "Flat"
                          ? Text(
                              "Flat $offer OFF",
                              style: extraBoldTextStyle.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )
                          : Text(
                              "$offer % OFF",
                              style: extraBoldTextStyle.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                      Text(
                        'UPTO SAR $uptoValue',
                        style: lightTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (restaurantText != null)
          Column(
            children: [
              const SizedBox(height: 8),
              LimitedBox(
                maxWidth: 115,
                child: Text(
                  restaurantText ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: mediumBoldTextStyle.copyWith(color: kBlackTextColor),
                ),
              ),
            ],
          ),
      ],
    );
  }
}






 // Container(
        //   height: 140,
        //   width: 120,
        //   margin: const EdgeInsets.only(right: 16),
        //   alignment: Alignment.bottomCenter,
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage(image),
        //       fit: BoxFit.cover,
        //     ),
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   child: Container(
        //     height: 90,
        //     alignment: Alignment.bottomLeft,
        //     padding: const EdgeInsets.all(12),
        //     decoration: BoxDecoration(
        //       borderRadius: const BorderRadius.vertical(
        //         bottom: Radius.circular(12),
        //       ),
        //       gradient: LinearGradient(
        //         begin: Alignment.bottomCenter,
        //         end: Alignment.topCenter,
        //         colors: [
        //           Colors.black,
        //           Colors.black.withOpacity(0.7),
        //           Colors.black45.withOpacity(0.0),
        //         ],
        //       ),
        //     ),
        //     child: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(
        //           offer,
        //           style: extraBoldTextStyle.copyWith(
        //             color: Colors.white,
        //             fontSize: 16,
        //           ),
        //         ),
        //         Text(
        //           'UPTO SAR 100',
        //           style: lightTextStyle.copyWith(
        //             color: Colors.white,
        //             fontSize: 11,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

