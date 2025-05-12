import 'package:Cesta/component/colors.dart';
import 'package:Cesta/component/padding.dart';
import 'package:Cesta/component/planid.dart';
import 'package:Cesta/component/texts.dart';
import 'package:Cesta/component/widgets/header.dart';
import 'package:Cesta/service/local/auth.dart';
import 'package:Cesta/service/remote/account/crud.dart';
import 'package:Cesta/view/home/account/account.dart';
import 'package:Cesta/view/home/plan/listplanscreen.dart';
import 'package:Cesta/view/students/studentsscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var client = http.Client();

  String screen = "online";

  String? token;
  String? fullname;
  var id;
  bool public = false;
  String? profileId;

  @override
  void initState() {
    super.initState();
    getString();
  }

  void getString() async {
    var strToken = await LocalAuthService().getSecureToken();
    var strProfileId = await LocalAuthService().getProfileId();
    var strFullname = await LocalAuthService().getFullName();

    if (mounted) {
      setState(() {
        token = strToken;
        profileId = strProfileId.toString();
        fullname = strFullname;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isDesktop = constraints.maxWidth > 800;

      return SafeArea(
          child: token == null
              ? const SizedBox()
              : ListView(
                  children: [
                    FutureBuilder<Map>(
                        future: AccountService()
                            .getProfile(id: profileId.toString(), token: token),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              var profile =
                                  snapshot.data! as Map<String, dynamic>;
                              int planId = profile["plan"]["id"];

                              // Verifica se o planId é 1 para definir se o CashbackSection é clicável

                              return Column(
                                children: [
                                  Padding(
                                    padding: defaultPaddingHorizon,
                                    child: MainHeader(
                                        iconColor: nightColor,
                                        title: "Cesta",
                                        icon: Icons.person,
                                        titleColor: nightColor,
                                        onClick: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AccountScreen(
                                                buttom: true,
                                                isClickableAddDependent:
                                                    planId ==
                                                        PlanConstants
                                                            .familyplan,
                                                isClickableSeller: planId ==
                                                    PlanConstants.sellerplan,
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,

                                    // Lista de itens irão ficar aqui

                                    children: [],
                                  ),
                                  Padding(
                                    padding: defaultPadding,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SubText(
                                            text:
                                                "Seu plano: ${profile["plan"]["name"]}",
                                            align: TextAlign.start),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ListPlanScreen(), // Substitua pela tela correta
                                              ),
                                            );
                                          },
                                          child: Container(
                                            color: PrimaryColor,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.upcoming,
                                                    color: SecudaryColor,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  SubText(
                                                      text: "Fazer upgrade",
                                                      color: SecudaryColor,
                                                      align: TextAlign.center),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                            return SizedBox(
                              height: 300,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: PrimaryColor,
                                ),
                              ),
                            );
                          }
                          return SizedBox(
                            height: 300,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: PrimaryColor,
                              ),
                            ),
                          );
                        }),
                  ],
                ));
    });
  }
}
