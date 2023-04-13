import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/text_styles.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  const ExpandableTextWidget({super.key, required this.text});

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  late String first, second;
  bool hide = true;

  @override
  void initState() {
    if (widget.text.length > 44) {
      first = widget.text.substring(0, 44);
      second = widget.text.substring(45, widget.text.length);
    } else {
      first = widget.text;
      second = "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxWidth: 190,
      child: second.isEmpty
          ? Text(
              widget.text,
              style: lightTextStyle.copyWith(
                color: kLightTextColor,
                fontSize: 12,
              ),
            )
          : RichText(
              text: TextSpan(
                  text: hide ? "$first..." : first + second,
                  style: lightTextStyle.copyWith(
                    color: kLightTextColor,
                    fontSize: 12,
                  ),
                  children: [
                    TextSpan(
                        text: hide ? " more" : "   less",
                        style: lightTextStyle.copyWith(
                          color: kAccentColor,
                          fontSize: 12,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              hide = !hide;
                            });
                          }),
                  ]),
            ),
    );
  }
}
