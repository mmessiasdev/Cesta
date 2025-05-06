import 'package:NIDE/component/colors.dart';
import 'package:NIDE/component/texts.dart';
import 'package:flutter/material.dart';

class MainHeader extends StatelessWidget {
  MainHeader(
      {Key? key,
      required this.title,
      this.onClick,
      this.icon,
      this.over,
      this.iconColor,
      this.titleColor,
      this.buttom,
      this.maxl})
      : super(key: key);
  String title;
  final Function? onClick;
  IconData? icon;
  TextOverflow? over;
  int? maxl;
  Color? iconColor;
  Color? titleColor;
  bool? buttom;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isDesktop = constraints.maxWidth > 800;

      return SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                height: 75,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset('assets/images/logo/white.png'))),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: PrimaryText(
                maxl: maxl ?? 1,
                color: titleColor ?? nightColor,
                text: title,
              ),
            ),
            buttom == true || buttom == null
                ? GestureDetector(
                    onTap: () => onClick!(),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 25,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      );
    });
  }
}
