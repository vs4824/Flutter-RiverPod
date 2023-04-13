import 'package:flutter/material.dart';
import 'package:riverpod_examples/common_widgets/yellow_btn_widget.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';

class BottomSheetFooterWidget extends StatelessWidget {
  final Function() clearFilterCallback;
  final Function() applyBtnCallback;
  const BottomSheetFooterWidget({
    Key? key,
    required this.clearFilterCallback,
    required this.applyBtnCallback,
  }) : super(key: key);

  //iPhoneSE height = 667

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(
        // right: 12,
        // left: 12,
        top: 10,
        bottom: height < 700 ? 12 : 22,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 7,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
            onPressed: clearFilterCallback,
            child: Text(
              'Clear Filters',
              style: mediumBoldTextStyle.copyWith(
                color: kLightTextColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: applyBtnCallback,
            child: const YellowButtonWidget(
              text: 'Apply',
              fontSize: 14,
              padding: EdgeInsets.symmetric(
                horizontal: 60,
                // vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
