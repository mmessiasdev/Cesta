import 'package:Cesta/component/colors.dart';
import 'package:Cesta/component/inputdefault.dart';
import 'package:Cesta/component/texts.dart';
import 'package:flutter/material.dart';

class InputLogin extends StatelessWidget {
  InputLogin(
      {super.key,
      this.title,
      this.inputTitle,
      required this.controller,
      this.keyboardType,
      this.validation,
      this.obsecureText});

  String? title;
  String? inputTitle;

  TextEditingController controller;
  bool? obsecureText;
  TextInputType? keyboardType;
  String? Function(String?)? validation;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubText(
          color: nightColor,
          text: title ?? "",
          align: TextAlign.start,
        ),
        const SizedBox(
          height: 5,
        ),
        InputTextField(
          validation: validation,
          obsecureText: obsecureText ?? false,
          textEditingController: controller,
          textInputType: keyboardType ?? TextInputType.text,
          title: inputTitle ?? "",
          fill: true,
          maxLines: 1, // Define maxLines para 1
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
