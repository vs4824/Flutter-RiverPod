import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_examples/model_class/food_mainpage_models/cuisine_list_model.dart';
import 'package:riverpod_examples/model_class/food_mainpage_models/food_category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_widgets/bottomSheet_footer_widget.dart';
import '../../../common_widgets/bottomSheet_header_widget.dart';
import '../../../common_widgets/food_item_tile.dart';
import '../../../common_widgets/image_assets.dart';
import '../../../common_widgets/loading_indicator.dart';
import '../../../common_widgets/network_api.dart';
import '../../../common_widgets/shimmer_loading.dart';
import '../../../common_widgets/skelton_widget.dart';
import '../../../common_widgets/text_icon_btn.dart';
import '../../../provider/food_main_page_provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/util.dart';
import '../../main_screen/widget/search_box_widget.dart';


class RestaurantList extends ConsumerWidget {
  RestaurantList({Key? key}) : super(key: key);

  bool _isFilterApplied = false;

  String cuisineSearch = "";
  List cuisineList = [];
  List allCuisineList = [];
  dynamic searchedCuisineList = [];
  List<String> selectedCuisineList = [];
  final PagingController pagingController = PagingController(firstPageKey: 1);
  static const _pageSize = 10;

  String selectedvegNonvegId = "";
  dynamic vegNonvegList = [];

  String ratingsId = "";
  dynamic ratingsFilterList = {
    "heading": "Filter by ratings",
    "items": [
      {
        "id": "",
        "title": "Relevance (Default)",
      },
      {
        "id": "4.5",
        "title": "Ratings 4.5+",
      },
      {
        "id": "4.0",
        "title": "Rating 4.0+",
      },
      {
        "id": "3.5",
        "title": "Ratings 3.5+",
      },
    ]
  };

  String sortById = "";
  dynamic sortByList = {
    "heading": "Sort by",
    "items": [
      {
        "id": "",
        "title": "Relevance (Default)",
      },
      {
        "id": "rating",
        "title": "Rating",
      },
      {
        "id": "lth",
        "title": "Cost: Low to High",
      },
      {
        "id": "htl",
        "title": "Cost: High to Low",
      },
    ]
  };

  int selectedFilterIndex = 0;
  dynamic filterWidgetList;
  late dynamic filterSectionList = [
    "Sort",
    "Cuisines",
    "Ratings",
    "Veg/Non-veg"
  ];

  String totalRestaurants = "";

  bool isLoading = false;

  @override
  Widget build(BuildContext context, ref) {
    final restaurantData = ref.watch(foodCategoryInRestaurantListNotifierProvider);
    final foodCategoryData = ref.watch(restaurantNotifierProvider);
    final cuisineData = ref.watch(cuisineNotifierProvider);

    final isLastPage = restaurantData.length < _pageSize;
      pagingController.appendLastPage(restaurantData);
      print(isLastPage);

    print(restaurantData);

    var size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              // FILTER
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    enableDrag: false,
                    isDismissible: false,
                    useRootNavigator: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                    ),
                    isScrollControlled: true,
                    // enableDrag: false,
                    context: context,
                    builder: (ctx) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          filterWidgetList = [
                            sortByWidget(setState),
                            cuisineFilterWidget(setState,cuisineData),
                            ratingsFilterWidget(setState),
                            vegNonvegWidget(setState,foodCategoryData),
                          ];
                          return Container(
                            height: size.height * 0.65,
                            decoration: const BoxDecoration(
                              color: kScaffoldBackgroundColor,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(22),
                              ),
                            ),
                            child: Column(
                              children: [
                                BottomSheetHeaderWidget(
                                  title: 'Filter',
                                  onTap: () {
                                    if (!_isFilterApplied) {
                                      setState(() {
                                        sortById = "";
                                        selectedCuisineList = [];
                                        ratingsId = "";
                                        selectedvegNonvegId = "";
                                      });
                                    }

                                    Navigator.of(ctx).pop();
                                  },
                                ),
                                const Divider(height: 0),
                                Expanded(
                                  flex: 11,
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: DecoratedBox(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            children: [
                                              for (int i = 0;
                                              i <
                                                  filterSectionList
                                                      .length;
                                              i++)
                                                IntrinsicHeight(
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedFilterIndex =
                                                            i;
                                                      });
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Container(
                                                          margin: const EdgeInsets
                                                              .only(
                                                              right:
                                                              17.5),
                                                          width: 3,
                                                          color: selectedFilterIndex ==
                                                              i
                                                              ? kAccentColor
                                                              : Colors
                                                              .transparent,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              vertical:
                                                              20),
                                                          child: Text(
                                                            filterSectionList[
                                                            i],
                                                            style:
                                                            TextStyle(
                                                              fontSize:
                                                              15,
                                                              color: selectedFilterIndex ==
                                                                  i
                                                                  ? kAccentColor
                                                                  : Colors
                                                                  .black,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const VerticalDivider(width: 0),
                                      Expanded(
                                        flex: 8,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15),
                                          child: Scrollbar(
                                            showTrackOnHover: true,
                                            radius:
                                            const Radius.circular(12),
                                            child: SingleChildScrollView(
                                              child: filterWidgetList[
                                              selectedFilterIndex],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: BottomSheetFooterWidget(
                                      clearFilterCallback: () {
                                        setState(() {
                                          sortById = "";
                                          selectedCuisineList = [];
                                          ratingsId = "";
                                          selectedvegNonvegId = "";
                                          _isFilterApplied = false;
                                        });
                                        pagingController.refresh();
                                        Navigator.of(ctx).pop();
                                      },
                                      applyBtnCallback: () {
                                        _isFilterApplied = true;
                                        pagingController.refresh();
                                        Navigator.of(ctx).pop();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                child: const TextIconBtn(
                  text: 'Filter',
                  icon: filterIcon,
                ),
              ),
              // SORT BY
              PopupMenuButton(
                shape: const RoundedRectangleBorder(
                  side: BorderSide(color: kBoxBorderColor),
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                ),
                offset: const Offset(0, 50),
                itemBuilder: (_) {
                  return [
                    for (var item in sortByList["items"])
                      PopupMenuItem(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15),
                              child: Text(
                                item["title"],
                                style: TextStyle(
                                    color: sortById == item["id"]
                                        ? kBlackTextColor
                                        : kLightTextColor),
                              ),
                            ),
                            sortById == item["id"]
                                ? const Icon(
                              Icons.radio_button_checked_rounded,
                              color: kAccentColor,
                              size: 20,
                            )
                                : const Icon(
                              Icons.radio_button_off_rounded,
                              color: kLightTextColor,
                              size: 20,
                            ),
                          ],
                        ),
                        onTap: () {
                          // setState(() {
                            sortById = item["id"];
                          // });
                          pagingController.refresh();
                        },
                      ),
                  ];
                },
                child: const TextIconBtn(
                  text: 'Sort by',
                  icon: downArrowIcon,
                ),
              ),
              // CUISINES
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    isDismissible: false,
                    useRootNavigator: true,
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                    ),
                    isScrollControlled: true,
                    enableDrag: false,
                    builder: (c) {
                      // List cuisineList = selectedCuisineList;
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Container(
                            height: size.height * 0.65,
                            decoration: const BoxDecoration(
                              color: kScaffoldBackgroundColor,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(22),
                              ),
                            ),
                            child: Column(
                              children: [
                                BottomSheetHeaderWidget(
                                  title: 'Cuisine',
                                  onTap: () {
                                    if (!_isFilterApplied) {
                                      setState(() {
                                        cuisineList = allCuisineList;
                                        selectedCuisineList.clear();
                                      });
                                    } else {
                                      setState(() =>
                                      cuisineList = allCuisineList);
                                    }

                                    Navigator.pop(c);
                                  },
                                ),
                                const Divider(height: 0),
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    children: [
                                      SearchBoxWidget(
                                        margin:
                                        const EdgeInsets.symmetric(
                                          horizontal: 18,
                                          vertical: 8,
                                        ),
                                        hintText: 'Search for cuisines',
                                        border: Border.all(
                                          color: kBoxBorderColor,
                                        ),
                                        onChanged: (value) {
                                          final suggestions =
                                          allCuisineList
                                              .where((cuisine) {
                                            final title = cuisine["title"]
                                                .toLowerCase();
                                            final input =
                                            value.toLowerCase();

                                            return title.contains(input);
                                          }).toList();

                                          setState(() {
                                            cuisineList = suggestions;
                                          });
                                        },
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          keyboardDismissBehavior:
                                          ScrollViewKeyboardDismissBehavior
                                              .onDrag,
                                          padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 19),
                                          itemCount: cuisineData.length,
                                          itemBuilder: (c, i) {
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (!selectedCuisineList
                                                      .contains(
                                                      cuisineData[i].sId)) {
                                                    selectedCuisineList
                                                        .add(cuisineData[
                                                    i].sId.toString());
                                                  } else {
                                                    selectedCuisineList
                                                        .remove(
                                                        cuisineData[i].sId);
                                                  }
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  selectedCuisineList
                                                      .contains(
                                                      cuisineData[
                                                      i].sId)
                                                      ? const Icon(
                                                    Icons
                                                        .check_box_rounded,
                                                    color:
                                                    kAccentColor,
                                                    size: 20,
                                                  )
                                                      : const Icon(
                                                    Icons
                                                        .check_box_outline_blank_rounded,
                                                    color:
                                                    kLightestTextColor,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(
                                                      width: 14),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                      top: 15,
                                                      bottom: 15,
                                                      // right: 3,
                                                    ),
                                                    child: Text(
                                                      cuisineData[i].title.toString(),
                                                      maxLines: 2,
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                      softWrap: false,
                                                      style:
                                                      const TextStyle(
                                                        color:
                                                        kLightestTextColor,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: BottomSheetFooterWidget(
                                      clearFilterCallback: () {
                                        setState(() {
                                          cuisineList = allCuisineList;
                                          _isFilterApplied = false;
                                          selectedCuisineList = [];
                                        });
                                        pagingController.refresh();
                                        Navigator.of(c).pop();
                                      },
                                      applyBtnCallback: () {
                                        if (selectedCuisineList
                                            .isNotEmpty) {
                                          cuisineList = allCuisineList;
                                          _isFilterApplied = true;
                                          Navigator.of(context).pop();
                                          pagingController.refresh();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                child: const TextIconBtn(
                  text: 'Cuisines',
                  icon: downArrowIcon,
                ),
              ),
              // RATINGS
              PopupMenuButton(
                shape: const RoundedRectangleBorder(
                  side: BorderSide(color: kBoxBorderColor),
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                ),
                offset: const Offset(0, 50),
                itemBuilder: (_) {
                  return [
                    for (var item in ratingsFilterList["items"])
                      PopupMenuItem(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15),
                              child: Text(
                                item["title"],
                                style: TextStyle(
                                    color: ratingsId == item["id"]
                                        ? kBlackTextColor
                                        : kLightTextColor),
                              ),
                            ),
                            ratingsId == item["id"]
                                ? const Icon(
                              Icons.radio_button_checked_rounded,
                              color: kAccentColor,
                              size: 20,
                            )
                                : const Icon(
                              Icons.radio_button_off_rounded,
                              color: kLightTextColor,
                              size: 20,
                            ),
                          ],
                        ),
                        onTap: () {
                            ratingsId = item["id"];
                          pagingController.refresh();
                        },
                      ),
                  ];
                },
                child: const TextIconBtn(
                  text: 'Ratings ',
                  icon: downArrowIcon,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            '$totalRestaurants Restaurants near you',
            style: const TextStyle(
              color: kBlackTextColor,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        restaurantData.isNotEmpty  ? SizedBox(
          height: 1000,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
              itemCount: restaurantData.length,
              itemBuilder: (BuildContext context, int index) {
                return FoodItemTile(
                  data: restaurantData[index],
                );
              }),
        ) :
        const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget vegNonvegWidget(StateSetter setState, List<FoodCategoryListModel> foodCategoryData) => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 18),
      const Text(
        "Filter by veg/non-veg",
        style: TextStyle(
          color: kLightTextColor,
          fontSize: 12,
        ),
      ),
      for (var item in foodCategoryData)
        InkWell(
          onTap: () {
            setState(() {
              selectedvegNonvegId = item.sId!;
            });
          },
          child: Row(
            children: [
              selectedvegNonvegId == item.sId
                  ? const Icon(
                Icons.radio_button_checked_rounded,
                color: kAccentColor,
                size: 19,
              )
                  : const Icon(
                Icons.radio_button_off_rounded,
                color: kLightTextColor,
                size: 19,
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  item.title.toString(),
                  style: TextStyle(
                    color: selectedvegNonvegId == item.sId
                        ? kBlackTextColor
                        : kLightTextColor,
                  ),
                ),
              ),
            ],
          ),
        )
    ],
  );

  Widget ratingsFilterWidget(StateSetter setState) => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 18),
      Text(
        ratingsFilterList["heading"],
        style: const TextStyle(
          color: kLightTextColor,
          fontSize: 12,
        ),
      ),
      for (var item in ratingsFilterList["items"])
        InkWell(
          onTap: () {
            setState(() {
              ratingsId = item["id"];
            });
          },
          child: Row(
            children: [
              ratingsId == item["id"]
                  ? const Icon(
                Icons.radio_button_checked_rounded,
                color: kAccentColor,
                size: 19,
              )
                  : const Icon(
                Icons.radio_button_off_rounded,
                color: kLightTextColor,
                size: 19,
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  item["title"],
                  style: TextStyle(
                    color: ratingsId == item["id"]
                        ? kBlackTextColor
                        : kLightTextColor,
                  ),
                ),
              ),
            ],
          ),
        )
    ],
  );

  Widget cuisineFilterWidget(StateSetter setState, List<CuisineListModel> cuisineData) => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      const SizedBox(height: 18),
      const Text(
        "Filter by cuisine",
        style: TextStyle(
          color: kLightTextColor,
          fontSize: 12,
        ),
      ),
      for (var item in cuisineData)
        InkWell(
          onTap: () {
            setState(() {
              if (!selectedCuisineList.contains(item.sId)) {
                selectedCuisineList.add(item.sId.toString());
              } else {
                selectedCuisineList.remove(item.sId);
              }
            });
          },
          child: Row(
            children: [
              selectedCuisineList.contains(item.sId)
                  ? const Icon(
                Icons.check_box_rounded,
                color: kAccentColor,
                size: 20,
              )
                  : const Icon(
                Icons.check_box_outline_blank_rounded,
                color: kLightestTextColor,
                size: 20,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    item.title.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selectedCuisineList.contains(item.sId)
                          ? kBlackTextColor
                          : kLightestTextColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
    ],
  );

  Widget sortByWidget(StateSetter setState) => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 18),
      Text(
        sortByList["heading"],
        style: const TextStyle(
          color: kLightTextColor,
          fontSize: 12,
        ),
      ),
      for (var item in sortByList["items"])
        InkWell(
          onTap: () {
            setState(() {
              sortById = item["id"];
            });
          },
          child: Row(
            children: [
              sortById == item["id"]
                  ? const Icon(
                Icons.radio_button_checked_rounded,
                color: kAccentColor,
                size: 19,
              )
                  : const Icon(
                Icons.radio_button_off_rounded,
                color: kLightTextColor,
                size: 19,
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  item["title"],
                  style: TextStyle(
                    color: sortById == item["id"]
                        ? kBlackTextColor
                        : kLightTextColor,
                  ),
                ),
              ),
            ],
          ),
        )
    ],
  );
}
