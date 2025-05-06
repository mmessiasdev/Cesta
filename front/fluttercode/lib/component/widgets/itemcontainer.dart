import 'package:NIDE/component/buttons.dart';
import 'package:NIDE/component/colors.dart';
import 'package:NIDE/component/padding.dart';
import 'package:NIDE/component/texts.dart';
import 'package:flutter/material.dart';

class ItemContainer extends StatelessWidget {
  const ItemContainer(
      {super.key, this.onClick, required this.title, required this.desc});
  final Function? onClick;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultPadding,
      child: GestureDetector(
        onTap: () => onClick?.call(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 25,
                spreadRadius: 0,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Fundo degradê e imagem
                Positioned.fill(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              PrimaryColor,
                              lightColor,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Opacity(
                          opacity: .2,
                          child: Image.network(
                            "https://www.keysight.com/content/dam/keysight/en/img/prd/ixia-homepage-redirect/network-visibility-and-network-test-products/Network-Monitoring.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Conteúdo principal com padding
                Padding(
                  padding: defaultPadding,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Impede que o Column ocupe espaço extra
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      PrimaryText(
                        text: title,
                        color: lightColor,
                        align: TextAlign.start,
                      ),
                      const SizedBox(height: 10),
                      SubText(
                        text: desc,
                        align: TextAlign.start,
                        color: lightColor,
                      ),
                      const SizedBox(height: 35), // Ajuste no espaçamento para evitar overflow
                      Divider(color: lightColor,),
                      const SizedBox(height: 35),
                      DefaultButton(
                        color: SeventhColor,
                        padding: defaultPadding,
                        text: "Acessar",
                        icon: Icons.radio_button_checked,
                        colorText: lightColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
