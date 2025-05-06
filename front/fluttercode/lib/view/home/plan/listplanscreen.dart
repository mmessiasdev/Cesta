import 'package:NIDE/component/colors.dart';
import 'package:NIDE/component/padding.dart';
import 'package:NIDE/component/planid.dart';
import 'package:NIDE/component/widgets/header.dart';
import 'package:NIDE/component/widgets/plancontainer.dart';
import 'package:NIDE/model/plans.dart';
import 'package:NIDE/service/local/auth.dart';
import 'package:NIDE/service/remote/account/crud.dart';
import 'package:NIDE/service/remote/auth.dart';
import 'package:NIDE/service/remote/plan/crud.dart';
import 'package:NIDE/view/home/plan/planscreen.dart';
import 'package:flutter/material.dart';

class ListPlanScreen extends StatefulWidget {
  const ListPlanScreen({super.key});

  @override
  State<ListPlanScreen> createState() => _ListPlanScreenState();
}

class _ListPlanScreenState extends State<ListPlanScreen> {
  var token;
  var profileId;

  @override
  void initState() {
    super.initState();
    getString();
  }

  void getString() async {
    var strToken = await LocalAuthService().getSecureToken();
    var strProfileId = await LocalAuthService().getProfileId();

    setState(() {
      token = strToken?.toString() ?? ""; // Valor padrão para token
      profileId = strProfileId?.toString() ?? ""; // Valor padrão para profileId
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
      case 'pink':
        return Colors.pink;
      case 'purple':
        return Colors.purple;
      case 'blue':
        return Colors.blue;
      default:
        return PrimaryColor; // Cor padrão se a cor não for reconhecida
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: lightColor,
        body: ListView(
          children: [
            Padding(
              padding: defaultPaddingHorizonTop,
              child: MainHeader(
                title: "Nossos Planos!",
                maxl: 2,
                icon: Icons.arrow_back_ios,
                onClick: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 600,
              child: Center(
                child: FutureBuilder<int?>(
                  future: token != null && profileId != null
                      ? AccountService().fetchPlanId(token, profileId)
                      : Future.value(
                          null), // Retorna null se token ou profileId forem null
                  builder: (context, planIdSnapshot) {
                    if (planIdSnapshot.connectionState ==
                        ConnectionState.done) {
                      if (planIdSnapshot.hasData) {
                        int? planId = planIdSnapshot.data;

                        return FutureBuilder<List<Plans>>(
                          future: PlanService().getPlans(token: token),
                          builder: (context, planSnapshot) {
                            if (planSnapshot.hasData) {
                              return ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: planSnapshot.data!.length,
                                itemBuilder: (context, index) {
                                  var renders = planSnapshot.data![index];

                                  // Verifica se renders.id e renders.name são null
                                  final planIdStr =
                                      renders.id?.toString() ?? "";
                                  final planName =
                                      renders.name?.toString() ?? "";

                                  if (planIdStr != planId?.toString()) {
                                    if (renders.id !=
                                            PlanConstants.dependentplan &&
                                        renders.id !=
                                            PlanConstants.sellerplan &&
                                        renders.id != PlanConstants.freeplan) {
                                      return Padding(
                                        padding: defaultPaddingHorizon,
                                        child: PlanContainer(
                                          onClick: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PlansScreen(
                                                  id: renders.id ??
                                                      0, // Valor padrão para id
                                                ),
                                              ),
                                            );
                                          },
                                          bgcolor: getColorFromString(renders
                                                  .color
                                                  ?.toString() ??
                                              ""), // Valor padrão para color
                                          name: planName,
                                          buttomtitle: "Contratar Agora!",
                                          value: renders.value
                                                  ?.toStringAsFixed(2) ??
                                              "0.00", // Valor padrão para value
                                          rules: renders.rules?.toString() ??
                                              "", // Valor padrão para rules
                                          benefit: renders.benefits
                                                  ?.toString() ??
                                              "", // Valor padrão para benefits
                                        ),
                                      );
                                    }
                                    return SizedBox();
                                  }
                                  return Padding(
                                    padding: defaultPaddingHorizon,
                                    child: PlanContainer(
                                      onClick: () {},
                                      bgcolor: OffColor,
                                      contractPlan: true,
                                      buttomtitle: "Esse é seu plano.",
                                      name: planName,
                                      value: renders.value?.toString() ??
                                          "0.00", // Valor padrão para value
                                      rules: renders.rules?.toString() ??
                                          "", // Valor padrão para rules
                                      benefit: renders.benefits?.toString() ??
                                          "", // Valor padrão para benefits
                                    ),
                                  );
                                },
                              );
                            }
                            return SizedBox(
                              height: 300,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: nightColor,
                                ),
                              ),
                            );
                          },
                        );
                      } else if (planIdSnapshot.hasError) {
                        return Center(
                          child: Text("Erro ao buscar planId"),
                        );
                      }
                    }
                    return SizedBox(
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: nightColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
