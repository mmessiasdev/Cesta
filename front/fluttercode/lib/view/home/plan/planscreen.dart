import 'package:Cesta/component/buttons.dart';
import 'package:Cesta/component/colors.dart';
import 'package:Cesta/component/padding.dart';
import 'package:Cesta/component/texts.dart';
import 'package:Cesta/component/widgets/header.dart';
import 'package:Cesta/controller/auth.dart';
import 'package:Cesta/service/local/auth.dart';
import 'package:Cesta/service/remote/auth.dart';
import 'package:Cesta/service/remote/plan/crud.dart';
import 'package:Cesta/view/home/plan/payment/creditcard/payment_form.dart';
import 'package:Cesta/view/home/plan/payment/pix/pixqrcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Para usar kIsWeb

class PlansScreen extends StatefulWidget {
  PlansScreen({super.key, required this.id});
  var id;

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  @override
  var token;

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: lightColor,
        body: ListView(
          children: [
            FutureBuilder<Map>(
                future: PlanService()
                    .getOnePlan(token: token, id: widget.id.toString()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var render = snapshot.data!;
                    return SizedBox(
                      child: Padding(
                        padding: defaultPadding,
                        child: Column(
                          children: [
                            MainHeader(
                                maxl: 2,
                                over: TextOverflow.fade,
                                title: render["name"],
                                icon: Icons.arrow_back_ios,
                                onClick: () {
                                  (Navigator.pop(context));
                                }),
                            render['illustrationurl'] != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      height: 100,
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      child: render['illustrationurl'] != null
                                          ? Image.network(
                                              render['illustrationurl'],
                                              height: 100,
                                              fit: BoxFit.cover,
                                            )
                                          : SizedBox(),
                                    ),
                                  )
                                : SizedBox(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  SubText(
                                      text: "${render['desc']}",
                                      align: TextAlign.start),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  SubText(
                                      text: "Benefícios:",
                                      align: TextAlign.start),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  SubText(
                                      text: "${render['benefits']}"
                                          .replaceAll("\\n", "\n\n"),
                                      color: nightColor,
                                      align: TextAlign.start),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      SubText(
                                          text: "${render['rules']}"
                                              .replaceAll("\\n", "\n\n"),
                                          color: OffColor,
                                          align: TextAlign.start),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 60,
                                  ),
                                  PrimaryText(
                                    align: TextAlign.end,
                                    color: nightColor,
                                    text: "${render['value']}R\$",
                                  ),
                                  Padding(
                                    padding: defaultPaddingVertical,
                                    child: Column(
                                      children: [
                                        SubText(
                                          text: "Meios de pagamento:",
                                          align: TextAlign.start,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            if (kIsWeb) {
                                              // Exibir alerta no navegador
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: const Text(
                                                      "Pagamento indisponível no momento"),
                                                  content: const Text(
                                                    "Os pagamentos estão inidisponiveis no momento na versão web. \n\nPara comprar um plano você só precisa baixar nosso APP na sua loja de aplicativos, entrar com sua conta e escolher o plano que deseja! ;)",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: const Text("OK"),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else {
                                              // Executar pagamento normalmente no mobile
                                              final paymentData =
                                                  await AuthController()
                                                      .iniciarPagamentoMercadoPago(
                                                          render['value']);

                                              if (paymentData != null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        QrCodeBuyPlanScreen(
                                                      idPlan: render['id'],
                                                      paymentId: paymentData[
                                                          'paymentId']!,
                                                      qrCode: paymentData[
                                                          'qrCodeBase64']!,
                                                      qrCodeCopyPaste:
                                                          paymentData[
                                                              'qrCodeCopyPaste']!,
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                print(
                                                    "Falha ao iniciar o pagamento.");
                                              }
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              DefaultButton(
                                                color: SeventhColor,
                                                colorText: lightColor,
                                                padding: defaultPadding,
                                                text: "Pix",
                                                icon: Icons.pix,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            if (kIsWeb) {
                                              // Exibir alerta no navegador
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: const Text(
                                                      "Pagamento indisponível no momento"),
                                                  content: const Text(
                                                    "Os pagamentos estão inidisponiveis no momento na versão web. \n\nPara comprar um plano você só precisa baixar nosso APP na sua loja de aplicativos, entrar com sua conta e escolher o plano que deseja! ;)",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: const Text("OK"),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PaymentFormScreen(
                                                            amount: 1,
                                                            description:
                                                                "Pagamento via cartão de crédito",
                                                            idPlan: render['id']
                                                                .toString())),
                                              );
                                            }
                                          },
                                          child: DefaultButton(
                                            color: SeventhColor,
                                            colorText: lightColor,
                                            padding: defaultPadding,
                                            text: "Cartão de crédito",
                                            icon: Icons.credit_card,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Expanded(
                      child: Center(
                          child: SubText(
                        text: 'Erro ao pesquisar Plano',
                        color: PrimaryColor,
                        align: TextAlign.center,
                      )),
                    );
                  }
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: PrimaryColor,
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
