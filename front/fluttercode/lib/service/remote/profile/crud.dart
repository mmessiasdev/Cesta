import 'dart:convert';

import 'package:Cesta/env.dart';
import 'package:Cesta/model/profiles.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  String baseUrl = EnvSecret().BASEURL;
  final String token;

  ProfileService({required this.token});

  Future<Profile> getProfile(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Profile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao carregar perfil');
    }
  }
}
