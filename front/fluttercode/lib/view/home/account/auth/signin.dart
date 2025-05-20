import 'package:Cesta/component/buttons.dart';
import 'package:Cesta/component/defaultButton.dart';
import 'package:Cesta/component/inputlogin.dart';
import 'package:Cesta/component/padding.dart';
import 'package:Cesta/component/widgets/contheader.dart';
import 'package:Cesta/controller/auth.dart';
import 'package:Cesta/view/home/account/auth/signup.dart';
import 'package:Cesta/view/home/account/password/forgotpass.dart';
import 'package:flutter/material.dart';
import 'package:Cesta/component/colors.dart';
import 'package:Cesta/component/widgets/header.dart';
import 'package:Cesta/component/texts.dart';
import 'package:Cesta/component/inputdefault.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool checked = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  // List<Widget> get _pages => [
  //       InputLogin(
  //         title: "Email ou CPF",
  //         controller: emailController,
  //         keyboardType: TextInputType.emailAddress,
  //       ),
  //       InputLogin(
  //         title: "Senha",
  //         controller: passwordController,
  //         obsecureText: true,
  //       ),
  //     ];

  // void _previousPage() {
  //   if (_currentPage > 0) {
  //     _pageController.previousPage(
  //       duration: Duration(milliseconds: 300),
  //       curve: Curves.easeIn,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: lightColor,
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isDesktop = constraints.maxWidth > 800;
            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  Padding(
                    padding: defaultPaddingHorizon,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 95,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/logo/white.png",
                              width: 80,
                            ),
                            PrimaryText(
                              color: nightColor,
                              text: "Cesta",
                            )
                          ],
                        ),
                        SizedBox(
                          height: 95,
                        ),
                        Column(
                          children: [
                            InputLogin(
                              title: "Email ou CPF",
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            InputLogin(
                              title: "Senha",
                              controller: passwordController,
                              obsecureText: true,
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: RichDefaultText(
                            text: 'Esqueceu sua senha? ',
                            size: 12,
                            wid: GestureDetector(
                              onTap: () {
                                (
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordScreen(),
                                    ),
                                  ),
                                );
                              },
                              child: SubText(
                                text: 'Clique aqui!',
                                align: TextAlign.start,
                                color: SecudaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 95,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => _isLoading = true);

                                  authController.signIn(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DefaultButton(
                                    text: "Entrar",
                                    color: PrimaryColor,
                                    colorText: lightColor,
                                    padding: defaultPadding,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                (
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUpScreen(),
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DefaultButton(
                                    text: "Criar conta",
                                    color: SeventhColor,
                                    colorText: lightColor,
                                    padding: defaultPadding,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
