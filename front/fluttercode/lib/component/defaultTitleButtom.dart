import 'package:NIDE/component/texts.dart';
import 'package:flutter/material.dart';

class DefaultTitleButton extends StatelessWidget {
  final String title;
  final Function onClick;
  Color color;
  Color iconColor;
  DefaultTitleButton({
    Key? key,
    required this.title,
    required this.onClick,
    required this.color,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              onClick();
            },
            child: Row(
              children: [
                Icon(
                  Icons.exit_to_app,
                  color: iconColor,
                ),
                SizedBox(
                  width: 15,
                ),
                SubTextSized(
                    text: title, size: 12, fontweight: FontWeight.w300),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
