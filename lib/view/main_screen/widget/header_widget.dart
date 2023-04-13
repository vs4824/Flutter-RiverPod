import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import '../../../controller/location_controller.dart';
import '../../../model_class/address_model.dart';
import '../../../utils/util.dart';
import '../../location_screen/location_screen.dart';

class HeaderWidget extends StatefulWidget {
  final Position? position;

  const HeaderWidget({
    Key? key,
    this.position
  }) : super(key: key);

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  String address = "";

  @override
  void initState(){
    LocationController().initializeAddress(position: widget.position).then((value) {
      // address = ref.watch(locationProvider);
      // print(address.address);

      setState(() {
        address = value;
      });
      if (kDebugMode) {
        print(address);
      }
    });
   super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    // PersistentNavBarNavigator.pushNewScreen(
                    //   context,
                    //   screen: LocationScreen(
                    //     canBack: true,
                    //   ),
                    //   withNavBar: false,
                    // );

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LocationScreen(
                          canBack: true,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/svg/location.svg'),
                      const SizedBox(width: 10),
                      LimitedBox(
                        maxWidth: 180,
                        child: Text(
                          address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SvgPicture.asset('assets/svg/downarrow.svg'),
                    ],
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                var data = await getDeviceModel();
                if (kDebugMode) {
                  print(data);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffE2E6ED)),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/svg/language.svg'),
                    const SizedBox(width: 5),
                    const Text(
                      'English',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
