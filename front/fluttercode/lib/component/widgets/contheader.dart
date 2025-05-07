import 'package:Cesta/component/colors.dart';
import 'package:Cesta/component/padding.dart';
import 'package:Cesta/component/texts.dart';
import 'package:Cesta/component/widgets/header.dart';
import 'package:Cesta/view/home/account/account.dart';
import 'package:flutter/material.dart';

class ContHeader extends StatelessWidget {
  ContHeader(
      {super.key,
      required this.subtitle,
      this.subtext,
      this.buttom,
      this.subheight,
      this.icon,
      this.screenRoute});

  bool subtitle;
  String? subtext;
  double? subheight;
  final Widget? screenRoute;
  IconData? icon;
  bool? buttom = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isDesktop = constraints.maxWidth > 800;

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: lightColor,
          // borderRadius: const BorderRadius.only(
          //   bottomLeft: Radius.circular(50),
          // ),
        ),
        child: Padding(
          padding: defaultPadding,
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MainHeader(
                    iconColor: nightColor,
                    title: "Cesta",
                    icon: icon,
                    titleColor: nightColor,
                    buttom: buttom ?? true,
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => screenRoute!,
                        ),
                      );
                    }),
                subtitle
                    ? SubText(
                        color: nightColor,
                        text: subtext ?? "",
                        align: TextAlign.start,
                      )
                    : SizedBox(
                        height: subheight ?? 0,
                      ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      );
    });
  }
}
