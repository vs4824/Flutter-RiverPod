import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common_widgets/backArrowAppBar.dart';
import '../../../common_widgets/food_item_tile.dart';
import '../../../common_widgets/image_assets.dart';
import '../../../common_widgets/loading_indicator.dart';
import '../../../model_class/food_mainpage_models/restaurant_list_model.dart';
import '../../../provider/restaurant_list_provider.dart';
import '../../../provider/restaurant_screen_provider.dart';
import '../../../repository/restaurant_list_repo.dart';
import '../../restaurant_screen/ui/restaurant_screen.dart';

class CategoryRestListScreen extends StatefulWidget {
  final String catId;
  final Function()? funcCallback;
  const CategoryRestListScreen(
      {super.key, required this.catId, this.funcCallback});

  @override
  State<CategoryRestListScreen> createState() => _CategoryRestListScreenState();
}

class _CategoryRestListScreenState extends State<CategoryRestListScreen> {

  List<RestaurantListModel> _response = [];
  bool isLoading = true;
  late RestaurantListModel responses;

  Future function(data) async {
    _response = data;

    // if (_response.length == 1 && mounted) {
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(
    //       builder: (_) => RestaurantScreen(
    //         data: _response[0],
    //         isFavorite: _response[0].favourite!,
    //         // funcCallback: widget.funcCallback!(),
    //       ),
    //     ),
    //   );
    //
    //   // PersistentNavBarNavigator.pushNewScreen(
    //   //   context,
    //   //   screen: RestaurantScreen(
    //   //     data: _response[0],
    //   //     isFavorite: _response[0]["favourite"],
    //   //     // funcCallback: widget.funcCallback!(),
    //   //   ),
    //   // )
    //   // .then((value) {
    //   //   widget.funcCallback!();
    //   //   Navigator.of(context).pop();
    //   // });
    //   return 1;
    // }

      isLoading = false;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backArrowAppBar(context: context),
      body: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final listData = ref.watch(fetchListNotifierProvider);
            function(listData).then((value) {
              ref.read(idProvider.notifier).state = _response[0].sId!;
              ref.read(idsProvider.notifier).state = _response[0].sId!;
              ref.read(vegNonVegIdProvider.notifier).state = "";
            });


            return _response.isEmpty ? Center(
              child: LoadingIndicator(),
            )
                : ListView.builder(
              itemCount: _response.length,
              itemBuilder: (c, i) {
                RestaurantListModel data = _response[i];
                return FoodItemTile(data: data);
              },
            );
          },
        ),
    );
  }
}
