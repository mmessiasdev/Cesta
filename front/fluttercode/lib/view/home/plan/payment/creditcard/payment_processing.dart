import 'package:Cesta/env.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'result/payment_success.dart';
import 'result/payment_rejected.dart';
import 'result/payment_pending.dart';

class PaymentProcessingScreen extends StatefulWidget {
  final String cardToken;
  final String doc;
  final double amount;
  final String description;
  final String idPlan;
  final String idProfile;
  final String token;

  const PaymentProcessingScreen(
      {Key? key,
      required this.cardToken,
      required this.doc,
      required this.amount,
      required this.description,
      required this.idPlan,
      required this.token,
      required this.idProfile})
      : super(key: key);

  @override
  _PaymentProcessingScreenState createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen> {
  bool _isProcessing = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => processPayment());
  }

  Future<void> processPayment() async {
    try {
      final accessToken = EnvSecret().MERCADOPAGOTOKEN;
      final idempotencyKey = Uuid().v4();

      final response = await http.post(
        Uri.parse('https://api.mercadopago.com/v1/payments'),
        headers: {
          "Content-Type": "application/json",
          "X-Idempotency-Key": idempotencyKey,
          "Authorization": "Bearer $accessToken"
        },
        body: jsonEncode({
          "token": widget.cardToken,
          "transaction_amount": widget.amount,
          "description": widget.description,
          "installments": 1,
          "payment_method_id": "master",
          "payer": {
            "email": "mmessiasltk@gmail.com",
            "identification": {"type": "CPF", "number": "19119119100"}
          },
        }),
      );

      final data = jsonDecode(response.body);
      print("Response body: ${response.body}");

      if (response.statusCode == 201) {
        handlePaymentResponse(data);
      } else {
        handlePaymentError(data, response.statusCode);
      }
    } catch (e) {
      handleException(e);
    }
  }

  void handlePaymentResponse(Map<String, dynamic> data) {
    switch (data['status']) {
      case 'approved':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentSuccessScreen(
              paymentId: data['id'].toString(),
              authorizationCode: data['authorization_code'] ?? '',
              amount: widget.amount,
              description: widget.description,
              idPlan: widget.idPlan,
              idProfile: widget.idProfile,
              token: widget.token,
            ),
          ),
        );
        break;
      case 'rejected':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentRejectedScreen(
              statusDetail: data['status_detail'] ?? 'cc_rejected_other',
              paymentId: data['id'].toString(),
              amount: widget.amount,
              description: widget.description,
            ),
          ),
        );
        break;
      case 'in_process':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentPendingScreen(
              statusDetail: data['status_detail'] ?? 'pending_contingency',
              paymentId: data['id'].toString(),
              amount: widget.amount,
              description: widget.description,
            ),
          ),
        );
        break;
      default:
        setState(() {
          _isProcessing = false;
          _errorMessage = 'Status de pagamento desconhecido: ${data['status']}';
        });
    }
  }

  void handlePaymentError(Map<String, dynamic> data, int statusCode) {
    setState(() {
      _isProcessing = false;
      _errorMessage =
          data['message'] ?? 'Erro ao processar pagamento (${statusCode})';
      if (data['cause'] != null) {
        _errorMessage =
            '${_errorMessage}\nMotivo: ${data['cause'][0]['description']}';
      }
    });
  }

  void handleException(dynamic e) {
    setState(() {
      _isProcessing = false;
      _errorMessage = 'Erro ao processar pagamento: ${e.toString()}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Processando Pagamento'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: _isProcessing
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Processando seu pagamento...'),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 50),
                  const SizedBox(height: 20),
                  Text(
                    _errorMessage ?? 'Erro desconhecido',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Voltar'),
                  ),
                ],
              ),
      ),
    );
  }
}
