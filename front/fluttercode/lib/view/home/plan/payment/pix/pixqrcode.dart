import 'dart:async';
import 'dart:convert';

import 'package:Cesta/component/buttons.dart';
import 'package:Cesta/component/colors.dart';
import 'package:Cesta/component/padding.dart';
import 'package:Cesta/component/texts.dart';
import 'package:Cesta/component/widgets/header.dart';
import 'package:Cesta/controller/auth.dart';
import 'package:Cesta/service/local/auth.dart';
import 'package:Cesta/service/remote/auth.dart';
import 'package:Cesta/service/remote/plan/crud.dart';
import 'package:Cesta/view/home/dashboard/binding.dart';
import 'package:Cesta/view/home/dashboard/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QrCodeBuyPlanScreen extends StatefulWidget {
  QrCodeBuyPlanScreen(
      {super.key,
      required this.qrCode,
      required this.qrCodeCopyPaste,
      required this.idPlan,
      required this.paymentId});

  String qrCode;
  String qrCodeCopyPaste;
  String paymentId;
  int idPlan;

  @override
  State<QrCodeBuyPlanScreen> createState() => _QrCodeBuyPlanScreenState();
}

class _QrCodeBuyPlanScreenState extends State<QrCodeBuyPlanScreen> {
  var token;
  var idProfile;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    getString();
    startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancela o timer quando o widget é destruído
    super.dispose();
  }

  void startPolling() {
    const interval = Duration(seconds: 2); // Intervalo de 10 segundos
    _timer = Timer.periodic(interval, (Timer timer) async {
      bool isPaymentApproved =
          await AuthController().verificarStatusPagamento(widget.paymentId);
      if (isPaymentApproved) {
        timer.cancel(); // Para o timer quando o pagamento é aprovado
        if (mounted) {
          PlanService().addProfilePlan(
              idProfile: int.parse(idProfile),
              idPlan: widget.idPlan.toString(),
              token: token);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(),
            ),
          );
        }
      }
    });
  }

  void getString() async {
    var strToken = await LocalAuthService().getSecureToken();
    var strId = await LocalAuthService().getProfileId();

    if (mounted) {
      setState(() {
        idProfile = strId;
        token = strToken;
      });
    }
  }

  Widget _buildQrCodeImage(String base64String) {
    // Remove a parte 'data:image/png;base64,' da string
    final decodedBytes = base64Decode(
        base64String.split(',').last); // Decodifica a string Base64

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: lightColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.memory(
                decodedBytes,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: lightColor,
      body: ListView(
        children: [
          const SizedBox(width: 20),
          Padding(
            padding: defaultPaddingHorizon,
            child: Column(
              children: [
                MainHeader(
                  title: "Finalizar compra",
                  icon: Icons.pix,
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(child: _buildQrCodeImage(widget.qrCode)),
                ),
                SizedBox(
                  child: GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: widget.qrCodeCopyPaste));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            backgroundColor: PrimaryColor,
                            content: Text(
                                "Texto copiado para a área de transferência!")),
                      );
                    },
                    child: Column(
                      children: [
                        SecundaryText(
                            text: "Pix Copia e cola",
                            color: nightColor,
                            align: TextAlign.start),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.pix,
                              size: 30,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: SubText(
                                text: widget.qrCodeCopyPaste,
                                color: nightColor,
                                align: TextAlign.center,
                                maxl: 2,
                                over: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DefaultButton(
                          text: "Copiar",
                          icon: Icons.paste_rounded,
                          color: SecudaryColor,
                          padding: defaultPadding,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Divider(),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    bool isPaymentApproved = await AuthController()
                        .verificarStatusPagamento(widget.paymentId);
                    if (isPaymentApproved) {
                      print('Pagamento aprovado.');
                      print(idProfile);
                      PlanService().addProfilePlan(
                          idProfile: int.parse(idProfile),
                          idPlan: widget.idPlan.toString(),
                          token: token);
                      // Navega para outra tela se o pagamento foi aprovado
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardScreen(),
                        ),
                      );
                    } else {
                      // Mostra uma mensagem de erro se o pagamento não foi aprovado
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: FifthColor,
                          content: Text("O pagamento ainda não foi realizado."),
                        ),
                      );
                    }
                  },
                  child: DefaultButton(
                    text: "Já fiz o pagamento!",
                    padding: defaultPadding,
                    color: FourtyColor,
                    colorText: lightColor,
                    icon: Icons.check,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardScreen(),
                      ),
                    );
                  },
                  child: DefaultButton(
                    text: "Desistir",
                    padding: defaultPadding,
                    color: FifthColor,
                    colorText: lightColor,
                    icon: Icons.error,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
