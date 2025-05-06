import 'package:NIDE/component/colors.dart';
import 'package:NIDE/component/padding.dart';
import 'package:NIDE/component/texts.dart';
import 'package:flutter/material.dart';

class IconList extends StatelessWidget {
  const IconList(
      {super.key,
      required this.onClick,
      required this.icon,
      required this.title});

  final Function onClick;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: GestureDetector(
            onTap: () => onClick(),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: PrimaryColor,
                      border: Border.all(color: SecudaryColor, width: 2)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      icon,
                      size: 30,
                      color: lightColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SubText(
                  text: title,
                  align: TextAlign.center,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class LargeIconList extends StatelessWidget {
  const LargeIconList(
      {super.key,
      required this.onClick,
      required this.icon,
      required this.title});

  final Function onClick;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        decoration: BoxDecoration(
          color: PrimaryColor,
          borderRadius: BorderRadius.circular(0),
          border: Border.all(color: SecudaryColor, width: 5),
        ),
        child: GestureDetector(
          onTap: () => onClick(),
          child: Padding(
            padding: defaultPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 38,
                  color: lightColor,
                ),
                SizedBox(
                  width: 15,
                ),
                SubText(
                  text: title,
                  align: TextAlign.center,
                  color: lightColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
