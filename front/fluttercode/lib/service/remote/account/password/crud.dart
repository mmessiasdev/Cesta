import 'dart:convert';
import 'package:NIDE/env.dart';
import 'package:http/http.dart' as http;

class PasswordService {
  final url = EnvSecret().BASEURL;
  final http.Client client = http.Client();

  Future<bool> sendResetCode(String email) async {
    final response = await client.post(
      Uri.parse('$url/auth/forgot-password'),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': "true"
      },
      body: json.encode({'email': email}),
    );
    return response.statusCode == 200;
  }

  // Future<bool> validateCode(String email, String code) async {
  //   final response = await client.post(
  //     Uri.parse('$url/auth/validate-code'),
  //     headers: {
  //       "Content-Type": "application/json",
  //       'ngrok-skip-browser-warning': "true"
  //     },
  //     body: json.encode({'email': email, 'code': code}),
  //   );

  //   if (response.statusCode == 200) {
  //     return json.decode(response.body)['valid'];
  //   }
  //   return false;
  // }

  Future<Map<String, dynamic>> validateResetCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$url/auth/validate-reset-code'),
        headers: {
          "Content-Type": "application/json",
          'ngrok-skip-browser-warning': "true"
        },
        body: json.encode({
          'email': email,
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'valid': false,
          'message': 'Erro na validação: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'valid': false, 'message': 'Erro de conexão: ${e.toString()}'};
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    final response = await client.post(
      Uri.parse('$url/auth/reset-password'),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': "true"
      },
      body: json.encode({
        'email': email,
        'code': code,
        'password': newPassword,
      }),
    );
    return response.statusCode == 200;
  }
}
