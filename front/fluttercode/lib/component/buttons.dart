import 'package:NIDE/component/colors.dart';
import 'package:NIDE/component/padding.dart';
import 'package:NIDE/component/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/request/request.dart';

class DefaultButton extends StatelessWidget {
  DefaultButton(
      {super.key,
      required this.text,
      this.color,
      this.padding,
      this.icon,
      this.colorText});
  String text;
  Color? color;
  Color? colorText;
  EdgeInsetsGeometry? padding;
  IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: color ?? TerciaryColor,
      ),
      child: Padding(
        padding: padding ?? defaultPaddingHorizon,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? Row(
                    children: [
                      Icon(
                        icon,
                        color: colorText ?? nightColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  )
                : SizedBox(),
            ButtonText(
              text: text,
              colorText: colorText ?? nightColor,
            ),
          ],
        ),
      ),
    );
  }
}
