import 'dart:async';

import 'package:Cesta/component/buttons.dart';
import 'package:Cesta/component/colors.dart';
import 'package:Cesta/component/padding.dart';
import 'package:Cesta/component/widgets/header.dart';
import 'package:Cesta/env.dart';
import 'package:Cesta/service/local/auth.dart';
import 'package:Cesta/view/home/plan/payment/creditcard/payment_processing.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/services.dart';

class PaymentFormScreen extends StatefulWidget {
  final double amount;
  final String description;
  final String idPlan;

  const PaymentFormScreen({
    Key? key,
    required this.amount,
    required this.description,
    required this.idPlan,
  }) : super(key: key);

  @override
  _PaymentFormScreenState createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<PaymentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  String cardNumber = '';
  String expMonth = '';
  String expYear = '';
  String cvv = '';
  String holder = '';
  String doc = '';

  bool _isLoading = false;

  var token;
  var idProfile;

  void initState() {
    super.initState();
    getString();
  }

  void getString() async {
    var strToken = await LocalAuthService().getSecureToken();
    var strIdProfile = await LocalAuthService().getProfileId();

    setState(() {
      token = strToken.toString();
      idProfile = strIdProfile.toString();
    });
  }

  // Formatadores de máscara para os campos
  final cardNumberFormatter = MaskTextInputFormatter(
    mask: '#### #### #### ####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final expiryDateFormatter = MaskTextInputFormatter(
    mask: '##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final baseUrl = EnvSecret().BASEURL;

  Future<void> processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http
          .post(
            Uri.parse('${baseUrl}/mercado-pago/card-token'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "card_number": cardNumber.replaceAll(' ', ''),
              "expiration_month": expMonth,
              "expiration_year": expYear,
              "security_code": cvv,
              "cardholder": {
                "name": holder,
                "identification": {
                  "type": "CPF",
                  "number": doc.replaceAll(RegExp(r'[^0-9]'), '')
                }
              }
            }),
          )
          .timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['card_token'] != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentProcessingScreen(
              cardToken: data['card_token'],
              doc: doc,
              amount: widget.amount,
              description: widget.description,
              idPlan: widget.idPlan,
              idProfile: idProfile,
              token: token,
            ),
          ),
        );
      } else {
        String errorMessage = 'Erro ao processar o cartão';
        if (data['message'] != null) {
          errorMessage += ': ${data['message']}';
        }
        if (data['cause'] != null && data['cause'].isNotEmpty) {
          errorMessage += '\nMotivo: ${data['cause'][0]['description']}';
        }

        _scaffoldKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on TimeoutException {
      _scaffoldKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('Tempo de conexão esgotado. Tente novamente.'),
          backgroundColor: Colors.red,
        ),
      );
    } on Exception catch (e) {
      _scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Erro inesperado: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );

    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        backgroundColor: lightColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Resumo do pagamento
                Padding(
                  padding: defaultPaddingVertical,
                  child: MainHeader(
                    icon: Icons.arrow_back_ios,
                    title: "Pagamento",
                    onClick: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Resumo do Pagamento',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 10),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     const Text('Descrição:'),
                        //     Text(
                        //       widget.description,
                        //       style:
                        //           const TextStyle(fontWeight: FontWeight.bold),
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Valor:'),
                            Text(
                              currencyFormat.format(widget.amount),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Número do cartão
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Número do Cartão',
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    cardNumberFormatter,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o número do cartão';
                    }
                    if (value.replaceAll(' ', '').length < 16) {
                      return 'Número do cartão inválido';
                    }
                    return null;
                  },
                  onChanged: (value) => cardNumber = value,
                  onSaved: (value) => cardNumber = value!,
                ),
                const SizedBox(height: 15),

                // Data de expiração e CVV
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Validade (MM/AAAA)',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          expiryDateFormatter,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe a validade';
                          }
                          if (!value.contains('/') || value.length < 7) {
                            return 'Formato inválido (MM/AAAA)';
                          }
                          final parts = value.split('/');
                          final month = int.tryParse(parts[0]);
                          final year = int.tryParse(parts[1]);

                          if (month == null || year == null) {
                            return 'Data inválida';
                          }
                          if (month < 1 || month > 12) {
                            return 'Mês inválido';
                          }

                          final now = DateTime.now();
                          if (year < now.year ||
                              (year == now.year && month < now.month)) {
                            return 'Cartão expirado';
                          }

                          return null;
                        },
                        onChanged: (value) {
                          if (value.length == 7) {
                            final parts = value.split('/');
                            expMonth = parts[0];
                            expYear = parts[1];
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'CVV',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o CVV';
                          }
                          if (value.length < 3) {
                            return 'CVV inválido';
                          }
                          return null;
                        },
                        onChanged: (value) => cvv = value,
                        onSaved: (value) => cvv = value!,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // Nome do titular
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nome do Titular (como no cartão)',
                    prefixIcon: Icon(Icons.person),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o nome do titular';
                    }
                    return null;
                  },
                  onChanged: (value) => holder = value,
                  onSaved: (value) => holder = value!,
                ),
                const SizedBox(height: 15),

                // CPF do titular
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'CPF do Titular',
                    prefixIcon: Icon(Icons.badge),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    cpfFormatter,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o CPF';
                    }
                    if (value.replaceAll(RegExp(r'[^0-9]'), '').length != 11) {
                      return 'CPF inválido';
                    }
                    return null;
                  },
                  onChanged: (value) => doc = value,
                  onSaved: (value) => doc = value!,
                ),
                const SizedBox(height: 30),

                // Botão de pagamento
                GestureDetector(
                  onTap: _isLoading ? null : processPayment,
                  child: DefaultButton(
                    text:
                        "Pagar ${widget.amount.toString().replaceAll('.', ',')}R\$",
                    padding: defaultPadding,
                    colorText: lightColor,
                    color: SecudaryColor,
                  ),
                ),

                // Bandeiras aceitas
                const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Text(
                    'Bandeiras aceitas:',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network('https://i.imgur.com/Rfu1WhU.png',
                        height: 10),
                    const SizedBox(width: 5),
                    Image.network('https://i.imgur.com/s9qVwBu.png',
                        height: 10),
                    const SizedBox(width: 5),
                    Image.network('https://i.imgur.com/5z10vcC.png',
                        height: 10),
                    const SizedBox(width: 5),
                    Image.network('https://i.imgur.com/4pqYqNq.png',
                        height: 10),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
