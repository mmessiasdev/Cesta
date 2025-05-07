import 'package:Cesta/component/bannerlist.dart';
import 'package:Cesta/component/buttons.dart';
import 'package:Cesta/component/colors.dart';
import 'package:Cesta/component/inputdefault.dart';
import 'package:Cesta/component/padding.dart';
import 'package:Cesta/component/texts.dart';
import 'package:Cesta/view/home/plan/listplanscreen.dart';
import 'package:flutter/material.dart';

void showDraggableScrollablePlan(BuildContext context, String token) {
  showModalBottomSheet(
    barrierColor: nightColor.withOpacity(0.8),
    context: context,
    isScrollControlled: true, // Permite que o modal suba com o teclado
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) {
          return Container(
            color: lightColor,
            child: LayoutBuilder(builder: (context, constraints) {
              bool isDesktop = constraints.maxWidth > 800;

              return ListView(
                children: [
                  Padding(
                    padding: defaultPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 70,
                              child: Image.network(
                                "https://cdni.iconscout.com/illustration/premium/thumb/sad-girl-illustration-download-in-svg-png-gif-file-formats--public-depression-african-feel-negative-bullying-employee-pack-business-illustrations-2639225.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SubText(
                                      text: "Plano não suportado.",
                                      color: nightColor,
                                      align: TextAlign.start),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SecundaryText(
                                    text:
                                        "Infelizmente seu plano não possui suporte a essa função. Faça upgrade para ter acesso a esse e muitos outros benefícios!",
                                    align: TextAlign.start,
                                    color: nightColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListPlanScreen(),
                              ),
                            );
                          },
                          child: DefaultButton(
                            text: "Nossos planos!",
                            padding: defaultPadding,
                            color: SecudaryColor,
                            colorText: lightColor,
                            icon: Icons.upcoming,
                          ),
                        )
                      ],
                    ),
                  ),
                  // FutureBuilder<List<Banners>>(
                  //   future: RemoteAuthService()
                  //       .getCarrouselBanners(token: token, id: "1"),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.done &&
                  //         snapshot.hasData) {
                  //       if (snapshot.data!.isEmpty) {
                  //         return const SizedBox(
                  //             height: 50, child: Center(child: SizedBox()));
                  //       } else {
                  //         return CarouselSlider.builder(
                  //           itemCount: snapshot.data!.length,
                  //           itemBuilder: (context, index, realIndex) {
                  //             var renders = snapshot.data![index];
                  //             return Padding(
                  //               padding:
                  //                   const EdgeInsets.symmetric(vertical: 15),
                  //               child: BannerList(
                  //                 imageUrl: renders.urlimage.toString(),
                  //                 isInternalRedirect: false,
                  //                 redirectUrl: renders.urlroute.toString(),
                  //               ),
                  //             );
                  //           },
                  //           options: CarouselOptions(
                  //             height: isDesktop ? 280 : 150,
                  //             autoPlay: true,
                  //             autoPlayInterval: const Duration(seconds: 3),
                  //             enlargeCenterPage: true,
                  //             viewportFraction: 0.8,
                  //           ),
                  //         );
                  //       }
                  //     } else if (snapshot.hasError) {
                  //       return const Center(child: SizedBox());
                  //     }
                  //     return SizedBox(
                  //       height: 150,
                  //       child: const Center(child: CircularProgressIndicator()),
                  //     );
                  //   },
                  // )
                ],
              );
            }),
          );
        },
      );
    },
  );
}
