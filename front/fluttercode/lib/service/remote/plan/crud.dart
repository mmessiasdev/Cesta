import 'dart:convert';

import 'package:NIDE/env.dart';
import 'package:NIDE/model/plans.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PlanService {
  var client = http.Client();
  final storage = FlutterSecureStorage();
  final url = EnvSecret().BASEURL;

  Future<List<Plans>> getPlans({
    required String? token,
  }) async {
    List<Plans> listItens = [];
    var response = await client.get(
      Uri.parse('${url.toString()}/plans'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
    );
    var body = jsonDecode(response.body);
    var itemCount = body;
    for (var i = 0; i < itemCount.length; i++) {
      listItens.add(Plans.fromJson(itemCount[i]));
    }
    return listItens;
  }

  Future<Map> getOnePlan({
    required String id,
    required String? token,
  }) async {
    var response = await client.get(
      Uri.parse('${url.toString()}/plans/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
    );
    var itens = json.decode(response.body);
    return itens;
  }

  Future addProfilePlan({
    required int? idProfile,
    required String? idPlan,
    required String? token,
  }) async {
    if (idProfile == null || idPlan == null || token == null) {
      throw Exception('Um ou mais parâmetros estão faltando!');
    }

    final body = {
      "profiles": [idProfile]
    };

    var response = await client.put(
      Uri.parse('${url.toString()}/plans/$idPlan'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "ngrok-skip-browser-warning": "true"
      },
      body: jsonEncode(body),
    );

    // Verifique a resposta
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Requisição bem-sucedida');
      print('Resposta: ${response.body}');
    } else {
      print('Falha na requisição: ${response.statusCode}');
      print('Erro: ${response.body}');
    }

    return response;
  }
}
