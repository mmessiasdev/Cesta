import 'package:NIDE/component/colors.dart';
import 'package:NIDE/component/padding.dart';
import 'package:NIDE/component/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ContentColaborator extends StatelessWidget {
  ContentColaborator(
      {super.key,
      required this.drules,
      required this.title,
      this.name,
      this.maxl,
      this.over,
      this.bgcolor,
      required this.id});

  final String drules;
  final String title;
  final String? name;
  String id;
  int? maxl;
  TextOverflow? over;
  Color? bgcolor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GestureDetector(
        // onTap: () {
        //   (Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => CourseScreen(id: id)),
        //   ));
        // },
        child: Container(
          decoration: BoxDecoration(
            color: bgcolor ?? lightColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(0.2), // Cor e opacidade da sombra
                spreadRadius: 2, // Expansão da sombra
                blurRadius: 4, // Desfoque
                offset: Offset(0, 5), // Deslocamento (horizontal, vertical)
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: SubText(text: name ?? "", align: TextAlign.start)),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: defaultPadding,
                child: SecundaryText(
                  text: title,
                  color: nightColor,
                  align: TextAlign.start,
                  maxl: maxl,
                  over: over,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
