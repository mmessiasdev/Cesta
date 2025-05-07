import 'package:Cesta/component/colors.dart';
import 'package:Cesta/component/padding.dart';
import 'package:Cesta/component/texts.dart';
import 'package:flutter/material.dart';

class ImageDescComp extends StatelessWidget {
  final String? title;
  final String? imageAsset;
  final String? subtext;
  final String? buttomText;
  final VoidCallback? onTap;

  const ImageDescComp({
    super.key,
    this.title,
    this.imageAsset,
    this.subtext,
    this.buttomText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Remova o operador "!" e permita que onTap seja null
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) // Exibe o título apenas se não for null
            Padding(
              padding: defaultPaddingHorizon,
              child: SecundaryText(
                text: title!,
                color: nightColor,
                align: TextAlign.start,
              ),
            ),
          Padding(
            padding: defaultPadding,
            child: Row(
              children: [
                if (imageAsset != null) // Exibe a imagem apenas se não for null
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      imageAsset!,
                      width: 160,
                      height: 130,
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: defaultPaddingHorizon,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (subtext !=
                            null) // Exibe o subtexto apenas se não for null
                          SubText(
                            text: subtext!,
                            align: TextAlign.start,
                          ),
                        const SizedBox(height: 10),
                        if (buttomText !=
                            null) // Exibe o botão apenas se não for null
                          Container(
                            color: PrimaryColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SubText(
                                text: buttomText!,
                                align: TextAlign.center,
                                color: lightColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
