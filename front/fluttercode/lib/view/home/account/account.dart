import 'package:NIDE/component/buttons/iconlist.dart';
import 'package:NIDE/component/colors.dart';
import 'package:NIDE/component/defaultTitleButtom.dart';
import 'package:NIDE/component/padding.dart';
import 'package:NIDE/component/widgets/header.dart';
import 'package:NIDE/component/widgets/infotext.dart';
import 'package:NIDE/controller/controllers.dart';
import 'package:NIDE/service/local/auth.dart';
import 'package:NIDE/view/home/plan/listplanscreen.dart';
import 'package:flutter/material.dart';
import 'auth/signin.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen(
      {Key? key,
      required this.buttom,
      required this.isClickableAddDependent,
      required this.isClickableSeller})
      : super(key: key);
  bool buttom;
  bool isClickableAddDependent;
  bool isClickableSeller;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  var email;
  var fullname;
  var cpf;
  var id;
  var token;

  @override
  void initState() {
    super.initState();
    getString();
  }

  void getString() async {
    var strEmail = await LocalAuthService().getEmail();
    var strFullname = await LocalAuthService().getFullName();
    var strId = await LocalAuthService().getProfileId();
    var strToken = await LocalAuthService().getSecureToken();

    if (mounted) {
      setState(() {
        email = strEmail.toString();
        fullname = strFullname.toString();
        id = strId.toString();
        token = strToken.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: lightColor,
      child: Padding(
        padding: defaultPaddingHorizon,
        child: ListView(
          children: [
            MainHeader(
                title: "Seu Perfil",
                maxl: 1,
                icon: Icons.arrow_back_ios,
                onClick: () {
                  Navigator.pop(context);
                }),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 50,
            ),
            Column(
              children: [
                InfoText(
                  title: "Nome:",
                  stitle: fullname == "null" ? "" : fullname,
                  icon: Icons.people,
                ),
                SizedBox(
                  height: 20,
                ),
                InfoText(
                  title: "Email:",
                  stitle: email == "null" ? "" : email,
                  icon: Icons.email,
                ),
                SizedBox(
                  height: 35,
                ),
                SizedBox(
                  height: 20,
                ),

                // InfoText(title: "Username:", stitle: cpf == "null" ? "" : cpf),
                SizedBox(
                  height: 70,
                ),
                DefaultTitleButton(
                  title: email == "null" ? "Entrar na conta" : "Sair da conta",
                  onClick: () {
                    if (token != "null") {
                      authController.signOut(context);
                      // Navigator.pop(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const SignInScreen(),
                      //   ),
                      // );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                      );
                    }
                  },
                  color: FifthColor,
                  iconColor: nightColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
