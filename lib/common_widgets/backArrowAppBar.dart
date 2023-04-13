import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/text_styles.dart';

AppBar backArrowAppBar({
  required BuildContext context,
  void Function()? onBackPressed,
  List<Widget>? actions,
  String? title,
  bool isIgnoring = false,
}) {
  return AppBar(
    elevation: 0,
    backgroundColor: kScaffoldBackgroundColor,
    centerTitle: false,
    title: title != null
        ? Text(
            title,
            style: mediumBoldTextStyle.copyWith(
              color: kBlackTextColor,
              fontSize: 20,
            ),
          )
        : null,
    leading: IgnorePointer(
      ignoring: isIgnoring,
      child: IconButton(
        onPressed: onBackPressed ??
            () {
              Navigator.pop(context);
            },
        icon: const Image(
          image: AssetImage('assets/images/arrowleftblack.png'),
        ),
      ),
    ),
    actions: actions,
  );
}
