import 'dart:convert';
import 'package:Cesta/env.dart';
import 'package:Cesta/service/local/auth.dart';
import 'package:Cesta/service/remote/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  final urlEnv = EnvSecret().BASEURL;

  final MERCADOPAGOTOKEN = EnvSecret().MERCADOPAGOTOKEN;

  @override
  void onInit() async {
    super.onInit();
  }

  void signUp({
    required String fullname,
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      // Mostrar loading
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );

      // Chamar o serviço de autenticação para registrar o usuário
      var result = await RemoteAuthService().signUp(
        email: email,
        username: username,
        password: password,
      );

      // Verificar se a resposta foi bem-sucedida
      if (result.statusCode == 200) {
        // Extrair o token JWT da resposta
        String token = json.decode(result.body)['jwt'];

        // Fazer a requisição para criar o perfil
        var userResult = await RemoteAuthService().createProfile(
          fullname: fullname,
          token: token,
        );

        // Verificar se a criação do perfil foi bem-sucedida
        if (userResult.statusCode == 200) {
          EasyLoading.showSuccess("Conta criada. Confirme suas informações.");
          // Redirecionar para a tela de login
          Navigator.of(Get.overlayContext!).pushReplacementNamed('/login');
        } else {
          // Mostrar erro se a criação do perfil falhou
          EasyLoading.showError('Alguma coisa deu errado. Tente novamente!');
        }
      } else {
        // Mostrar erro se o registro do usuário falhou
        EasyLoading.showError('Alguma coisa deu errado. Tente novamente!');
      }
    } catch (e) {
      // Mostrar erro em caso de exceção
      EasyLoading.showError('Alguma coisa deu errado. Tente novamente!');
    } finally {
      // Fechar o loading
      EasyLoading.dismiss();
    }
  }

  void signIn({required String email, required String password}) async {
    try {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );

      // Faz a chamada para signIn
      var result = await RemoteAuthService().signIn(
        email: email,
        password: password,
      );

      if (result.statusCode == 200) {
        // Pega o token do corpo da resposta
        String token = json.decode(result.body)['jwt'];

        // Faz a chamada para getProfile
        var userResult = await RemoteAuthService().getProfile(token: token);

        if (userResult.statusCode == 200) {
          // Decodifica o corpo da resposta (apenas depois de checar o statusCode)
          var userData = jsonDecode(userResult.body);

          var email = userData['email'];
          var id = userData['id'];
          var fullname = userData['fullname'];
          var username = userData['user']['username'];

          await LocalAuthService().storeToken(token);
          await LocalAuthService().storeAccount(
            id: id,
            email: email,
            fullname: fullname,
            cpf: username,
          );

          EasyLoading.showSuccess("Bem vindo ao Analytics");
          Navigator.of(Get.overlayContext!).pushReplacementNamed('/');
          
        } else {
          EasyLoading.showError(
              'Alguma coisa deu errado. Tente novamente mais tarde...');
        }
      } else {
        EasyLoading.showError('Email ou senha incorreto.');
      }
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.showError('Alguma coisa deu errado. Tente novamente!');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<Map<String, String?>?> iniciarPagamentoMercadoPago(
      double valor) async {
    var uuid = Uuid();
    String idempotencyKey = uuid.v4();

    final url = Uri.parse("https://api.mercadopago.com/v1/payments");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer ${MERCADOPAGOTOKEN}",
        "X-Idempotency-Key": idempotencyKey,
      },
      body: jsonEncode({
        "transaction_amount": valor,
        "description": "Acesso especial",
        "payment_method_id": "pix",
        "payer": {"email": "mmessiasdev@gmail.com"}
      }),
    );

    if (response.statusCode == 201) {
      final paymentResponse = jsonDecode(response.body);
      final qrCodeBase64 = paymentResponse['point_of_interaction']
          ['transaction_data']['qr_code_base64'];
      final qrCodeCopyPaste = paymentResponse['point_of_interaction']
          ['transaction_data']['qr_code'];
      final paymentId = paymentResponse['id']
          .toString(); // ID do pagamento para futuras verificações

      return {
        "qrCodeBase64": qrCodeBase64,
        "qrCodeCopyPaste": qrCodeCopyPaste,
        "paymentId": paymentId,
      };
    } else {
      print("Erro no pagamento: ${response.statusCode}");
      return null;
    }
  }

  Future<bool> verificarStatusPagamento(String paymentId) async {
    final url = Uri.parse("https://api.mercadopago.com/v1/payments/$paymentId");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${MERCADOPAGOTOKEN}",
      },
    );

    if (response.statusCode == 200) {
      final paymentResponse = jsonDecode(response.body);

      // Verifique se o status do pagamento é "approved"
      if (paymentResponse['status'] == "approved") {
        return true; // Retorna true se o status for "approved"
      } else {
        print("Pagamento não aprovado. Status: ${paymentResponse['status']}");
        return false; // Retorna false se o status não for "approved"
      }
    } else {
      print("Erro ao verificar o status: ${response.statusCode}");
      return false; // Retorna false se o status code não for 200
    }
  }

  void signOut(BuildContext context) async {
    await LocalAuthService().clear();
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
