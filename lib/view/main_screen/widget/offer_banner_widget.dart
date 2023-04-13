import 'package:flutter/material.dart';

class OfferBannerWidget extends StatelessWidget {
  final String category, perc, tagline;
  final List<Color> gradient;
  const OfferBannerWidget({
    Key? key,
    required this.category,
    required this.perc,
    required this.tagline,
    required this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.symmetric(horizontal: 22),
      height: 180,
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            category,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            perc,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: 'Montserrat-ExtraBold',
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 180,
            child: Text(
              tagline,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text(
                'Order Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              SizedBox(width: 12),
              Image(
                image: AssetImage('assets/images/arrow.png'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
