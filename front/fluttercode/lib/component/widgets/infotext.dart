import 'package:Cesta/component/colors.dart';
import 'package:Cesta/component/texts.dart';
import 'package:flutter/material.dart';

class InfoText extends StatelessWidget {
  InfoText({super.key, this.title, this.stitle, required this.icon});

  String? title;
  String? stitle;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          CircleAvatar(
            child: Icon(
              icon,
              color: lightColor,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: RichDefaultText(
              text: '$title \n',
              size: 14,
              wid: SecundaryText(
                  text: '$stitle', color: nightColor, align: TextAlign.start),
            ),
          ),
        ],
      ),
    );
  }
}
