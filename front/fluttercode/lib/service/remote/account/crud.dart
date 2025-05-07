import 'dart:convert';

import 'package:Cesta/env.dart';
import 'package:Cesta/model/profiles.dart';
import 'package:http/http.dart' as http;

class AccountService {
  
  final url = EnvSecret().BASEURL;

  var client = http.Client();
  Future<Map> getProfile({
    required String id,
    required String? token,
  }) async {
    var response = await client.get(
      Uri.parse('${url.toString()}/profile/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        'ngrok-skip-browser-warning': "true"
      },
    );
    var itens = json.decode(response.body);
    print("Seus itens ${itens}");
    return itens;
  }

  Future<int?> fetchPlanId(String token, String profileId) async {
    try {
      var response =
          await AccountService().getProfile(id: profileId, token: token);
      if (response != null) {
        var profile = response as Map<String, dynamic>;
        return profile["plan"]["id"]; // Retorna o planId
      }
    } catch (e) {
      print("Erro ao buscar planId: $e");
    }
    return null; // Retorna null em caso de erro
  }
}
