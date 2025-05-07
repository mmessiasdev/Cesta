import 'dart:convert';

import 'package:Cesta/component/colors.dart';
import 'package:Cesta/component/padding.dart';
import 'package:Cesta/component/texts.dart';
import 'package:Cesta/component/widgets/header.dart';
import 'package:Cesta/component/widgets/plancontainer.dart';
import 'package:Cesta/model/plans.dart';
import 'package:Cesta/service/local/auth.dart';
import 'package:Cesta/service/remote/auth.dart';
import 'package:Cesta/service/remote/plan/crud.dart';
import 'package:Cesta/view/home/plan/listplanscreen.dart';
import 'package:Cesta/view/home/plan/planscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  var client = http.Client();
  var token;
  var idPlan;

  @override
  void initState() {
    super.initState();
    getString();
  }

  void getString() async {
    var strToken = await LocalAuthService().getSecureToken();

    setState(() {
      token = strToken.toString();
    });
  }

  // Método para converter string para cor
  Color getColorFromString(String color) {
    switch (color.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'black':
        return Colors.black;
      case 'yellow':
        return Colors.yellow;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      default:
        return PrimaryColor; // Cor padrão se a cor não for reconhecida
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      body: token == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: defaultPaddingHorizon,
                  child: MainHeader(title: "Cesta"),
                ),
                FutureBuilder(
                  future: RemoteAuthService().getProfile(token: token),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      print('Erro ao buscar perfil: ${snapshot.error}');
                      return Center(
                        child:
                            Text('Erro ao carregar perfil: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData) {
                      var response = snapshot.data as http.Response;
                      print('Resposta da API: ${response.body}');

                      if (response.statusCode == 200) {
                        try {
                          var render =
                              jsonDecode(response.body) as Map<String, dynamic>;

                          if (render != null && render['plan'] == null) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: defaultPaddingHorizon,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      PlanViewUpdated(planname: 'Cesta Free'),
                                      SizedBox(
                                        height: 35,
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: SizedBox(
                                            height: 235,
                                            child: Image.asset(
                                              "assets/images/illustrator/illustrator2.png",
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      SubText(
                                        text:
                                            "Adquira para aproveitar o máximo de benefícios que temos a oferecer para você, sua família e sua empresa! ",
                                        color: nightColor,
                                        align: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Icon(Icons.arrow_downward),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: defaultPadding,
                                  child: SecundaryText(
                                      text: "Conheça nossos planos!",
                                      color: nightColor,
                                      align: TextAlign.center),
                                ),
                                SizedBox(
                                  height: 600,
                                  child: Center(
                                    child: FutureBuilder<List<Plans>>(
                                      future:
                                          PlanService().getPlans(token: token),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                                color: nightColor),
                                          );
                                        } else if (snapshot.hasError) {
                                          print(
                                              'Erro no FutureBuilder: ${snapshot.error}');
                                          return Center(
                                            child: Text(
                                                'Erro ao carregar planos: ${snapshot.error}'),
                                          );
                                        } else if (snapshot.hasData) {
                                          var plans = snapshot.data!;
                                          if (plans.isEmpty) {
                                            return Center(
                                              child: Text(
                                                  'Nenhum plano disponível.'),
                                            );
                                          }
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: plans.length,
                                            itemBuilder: (context, index) {
                                              var plan = plans[index];
                                              return Padding(
                                                padding: defaultPaddingHorizon,
                                                child: SizedBox(
                                                  width:
                                                      300, // Largura fixa para teste
                                                  child: PlanContainer(
                                                    onClick: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              PlansScreen(
                                                                  id: plan.id),
                                                        ),
                                                      );
                                                    },
                                                    bgcolor: getColorFromString(
                                                        plan.color.toString()),
                                                    name: plan.name.toString(),
                                                    value:
                                                        plan.value.toString(),
                                                    rules:
                                                        plan.rules.toString(),
                                                    benefit: plan.benefits
                                                        .toString(),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        } else {
                                          return Center(
                                            child:
                                                Text('Nenhum dado encontrado.'),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            idPlan = render['plan']['id'].toString();
                            return Padding(
                              padding: defaultPaddingHorizon,
                              child: idPlan != null
                                  ? Padding(
                                      padding: defaultPaddingHorizon,
                                      child: idPlan != null
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                PlanViewUpdated(
                                                  planname: render['plan']
                                                      ['name'],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: SizedBox(
                                                      height: 205,
                                                      child: Image.asset(
                                                        "assets/images/illustrator/illustrator1.png",
                                                        fit: BoxFit.cover,
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: 35,
                                                ),
                                                Padding(
                                                  padding: defaultPadding,
                                                  child: SecundaryText(
                                                      text:
                                                          "Conheça nossos planos!",
                                                      color: nightColor,
                                                      align: TextAlign.center),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                SizedBox(
                                                  height: 600,
                                                  child: Center(
                                                    child: FutureBuilder<
                                                            List<Plans>>(
                                                        future: PlanService()
                                                            .getPlans(
                                                                token: token),
                                                        builder: (context,
                                                            planSnapshot) {
                                                          if (planSnapshot
                                                              .hasData) {
                                                            return ListView
                                                                .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    scrollDirection:
                                                                        Axis
                                                                            .horizontal,
                                                                    itemCount:
                                                                        planSnapshot
                                                                            .data!
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      var renders =
                                                                          planSnapshot
                                                                              .data![index];
                                                                      if (renders !=
                                                                              null &&
                                                                          renders.id !=
                                                                              render['plan']['id']) {
                                                                        return Padding(
                                                                          padding:
                                                                              defaultPaddingHorizon,
                                                                          child: PlanContainer(
                                                                              onClick: () {
                                                                                Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => PlansScreen(
                                                                                      id: renders.id,
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                              bgcolor: getColorFromString(renders.color.toString()),
                                                                              buttomtitle: "Contratar Agora!",
                                                                              name: renders.name.toString(),
                                                                              value: renders.value.toString(),
                                                                              rules: renders.rules.toString(),
                                                                              benefit: renders.benefits.toString()),
                                                                        );
                                                                      }
                                                                      return const SizedBox();
                                                                    });
                                                          }
                                                          return SizedBox(
                                                            height: 200,
                                                            child: Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color:
                                                                    PrimaryColor,
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : CircularProgressIndicator(),
                                    )
                                  : CircularProgressIndicator(),
                            );
                          }
                        } catch (e) {
                          print('Erro ao decodificar JSON: $e');
                          return Center(
                            child: Text('Erro ao processar a resposta: $e'),
                          );
                        }
                      } else {
                        print('Erro na requisição: ${response.statusCode}');
                        return Center(
                          child: Text(
                              'Erro na requisição: ${response.statusCode}'),
                        );
                      }
                    } else {
                      return Center(
                        child: Text('Nenhum dado encontrado.'),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
    );
  }
}

class PlanViewUpdated extends StatelessWidget {
  PlanViewUpdated({super.key, required this.planname});

  String planname;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SubTextSized(
                fontweight: FontWeight.w400,
                size: 12,
                text: "Seu Plano:",
                color: nightColor,
                align: TextAlign.start),
            SizedBox(
              width: 5,
            ),
            SubText(
              text: planname,
              align: TextAlign.start,
              over: TextOverflow.fade,
              maxl: 2,
            ),
          ],
        ),
        SizedBox(
          width: 5,
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
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: PrimaryColor,
            ),
            child: Padding(
              padding: defaultPadding,
              child: SubText(
                text: "Fazer Upgrade",
                align: TextAlign.center,
                color: lightColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
