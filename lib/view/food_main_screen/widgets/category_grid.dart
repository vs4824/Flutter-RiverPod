import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model_class/food_mainpage_models/category_model.dart';
import '../../../provider/restaurant_list_provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/util.dart';
import '../../category_list_screen/ui/category_restaurant_list_screen.dart';

class CategoryGrid extends StatefulWidget {
  final List<CategoryModel> data;
  final Function()? funcCallback;
  const CategoryGrid({
    Key? key,
    required this.data,
    this.funcCallback,
  }) : super(key: key);

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  bool isSeeMore = true;
  List<CategoryModel>? data;

  @override
  void initState() {
    data = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 9,
            crossAxisSpacing: 0,
            childAspectRatio: 0.85,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: data!.length < 8
              ? data!.length
              : isSeeMore
                  ? 8
                  : data!.length,
          itemBuilder: (_, index) {
            return Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                return GestureDetector(
                  onTap: () {
                    if (widget.funcCallback == null) print("callback null in grid");
                    if (data![index].resturantCount != 0) {
                      ref.read(fetchListIdProvider.notifier).state = data![index].sId!;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryRestListScreen(
                        catId: data![index].sId!,
                        funcCallback: widget.funcCallback!(),
                      )));
                    } else {
                      showSnackbar(
                        context: context,
                        title: "No result found",
                      );
                    }

                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (_) =>
                    //         CategoryRestListScreen(catId: data[index]["_id"]),
                    //   ),
                    // );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CachedNetworkImage(
                        imageUrl: data![index].image?? "",
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  blurRadius: 7,
                                  // spreadRadius: 0,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundImage: imageProvider,
                              radius: 37,
                              backgroundColor: Colors.white,
                            ),
                          );
                        },
                        placeholder: (context, url) {
                          return CircleAvatar(
                            backgroundImage: NetworkImage(data![index].image.toString()),
                            // : AssetImage("assets/images/second section.png"),
                            radius: 32,
                            backgroundColor: Colors.white,
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      LimitedBox(
                        maxHeight: 35,
                        child: Text(
                          data![index].title.toString(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            color: kBlackTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 8),
        //SEE MORE BUTTON
        if (data!.length > 8)
          GestureDetector(
            onTap: () {
              setState(() {
                isSeeMore = !isSeeMore;
              });
            },
            child: Container(
              // height: 36,
              padding: const EdgeInsets.symmetric(vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: kBoxBorderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isSeeMore ? 'See More' : 'See Less',
                    style: const TextStyle(
                      color: Color(0xff667083),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 3),
                  isSeeMore
                      ? const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xff667083),
                          size: 15,
                        )
                      : const Icon(
                          Icons.keyboard_arrow_up_outlined,
                          color: Color(0xff667083),
                          size: 15,
                        )
                ],
              ),
            ),
          ),
      ],
    );
  }
}
