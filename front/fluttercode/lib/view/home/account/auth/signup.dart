import 'package:Cesta/component/buttons.dart';
import 'package:Cesta/component/inputlogin.dart';
import 'package:Cesta/component/padding.dart';
import 'package:Cesta/component/widgets/title.dart';
import 'package:Cesta/controller/controllers.dart';
import 'package:Cesta/view/home/account/auth/signin.dart';
import 'package:Cesta/view/home/dashboard/screen.dart';
import 'package:flutter/material.dart';
import 'package:Cesta/component/colors.dart';
import 'package:Cesta/component/texts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: defaultPaddingHorizon,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/logo/white.png",
                      width: 80,
                    ),
                    PrimaryText(
                      color: nightColor,
                      text: "Crie sua conta!",
                    )
                  ],
                ),
                DefaultTitle(
                  buttom: false,
                  subtitle: "Para desfrutar de todos benefícios ",
                  subbuttom: SubTextSized(
                    align: TextAlign.start,
                    fontweight: FontWeight.w600,
                    text: "que preparamos pra você!",
                    size: 20,
                    color: nightColor,
                  ),
                ),
                const SizedBox(height: 40),
                Column(
                  children: [
                    InputLogin(
                      title: 'CPF',
                      controller: usernameController,
                      keyboardType: TextInputType.number,
                    ),
                    InputLogin(
                      title: 'Nome Completo',
                      controller: fullnameController,
                      keyboardType: TextInputType.text,
                    ),
                    InputLogin(
                      title: 'Email',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    InputLogin(
                      title: 'Senha',
                      controller: passwordController,
                      obsecureText: true,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          authController.signUp(
                            fullname: fullnameController.text,
                            email: emailController.text,
                            username: usernameController.text,
                            password: passwordController.text,
                          );
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DefaultButton(
                            text: "Criar conta",
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
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        (
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInScreen(),
                            ),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DefaultButton(
                            text: "Já tenho conta",
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
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
