import 'dart:convert';
import 'package:NIDE/env.dart';
import 'package:http/http.dart' as http;

class MercadoPagoService {
  final String _baseUrl = 'https://api.mercadopago.com';
  final String _accessToken =
      EnvSecret().MERCADOPAGOTOKEN; // Obtenha no painel do Mercado Pago

  // Cria um token para o cartão de crédito
  Future<String> createCardToken({
    required String cardNumber,
    required String expirationMonth,
    required String expirationYear,
    required String securityCode,
    required String cardholderName,
  }) async {
    final response = await http.post(
      Uri.parse('https://api.mercadopago.com/v1/card_tokens'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "card_number": cardNumber.replaceAll(RegExp(r'\s+'), ''),
        "expiration_month": expirationMonth,
        "expiration_year": expirationYear,
        "security_code": securityCode,
        "cardholder": {
          "name": cardholderName,
        }
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['id'];
    } else {
      throw Exception('Falha ao criar token: ${response.body}');
    }
  }

  Future<String> createCreditCardPayment({
    required double transactionAmount,
    required String description,
    required String cardToken,
    required String payerEmail,
    required String planId, // Novo parâmetro
    int installments = 1,
    String paymentMethodId = 'visa',
  }) async {
    final response = await http.post(
      Uri.parse('https://api.mercadopago.com/v1/payments'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "transaction_amount": transactionAmount,
        "description":
            "$description (Plano ID: $planId)", // Inclui o planId na descrição
        "payment_method_id": paymentMethodId,
        "installments": installments,
        "payer": {
          "email": payerEmail,
        },
        "token": cardToken,
        "metadata": {
          // Adiciona metadados com o planId
          "plan_id": planId,
          "internal_reference": "NIDE_$planId"
        },
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['id'].toString();
    } else {
      throw Exception('Falha ao criar pagamento: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> createBoletoPayment({
    required double amount,
    required String description,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/v1/payments'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'transaction_amount': amount,
        'description': description,
        'payment_method_id': 'bolbradesco',
        'payer': {
          'email': 'user@example.com', // Substitua pelo e-mail do usuário
          'first_name': 'Nome',
          'last_name': 'Sobrenome',
          'identification': {
            'type': 'CPF',
            'number': '12345678909' // Substitua pelo CPF do usuário
          },
        }
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return {
        'boleto_url': data['transaction_details']['external_resource_url'],
        'barcode': data['barcode']['content'],
        'due_date': data['date_of_expiration'],
        'payment_id': data['id'].toString(),
      };
    } else {
      throw Exception('Falha ao gerar boleto: ${response.body}');
    }
  }

  // Verifica o status de um pagamento
  Future<String> checkPaymentStatus(String paymentId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/v1/payments/$paymentId'),
      headers: {'Authorization': 'Bearer $_accessToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status']; // 'approved', 'pending', 'rejected'
    } else {
      throw Exception('Falha ao verificar status: ${response.body}');
    }
  }
}
