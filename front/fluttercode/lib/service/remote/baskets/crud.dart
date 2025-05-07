// services/basket_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:Cesta/env.dart';
import 'package:Cesta/model/students.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_io/io.dart' as io;

class BasketService {
  String baseUrl = EnvSecret().BASEURL;
  final String token;

  BasketService({
    required this.token,
  });

  Future<http.Response> addBasket({
    required int studentId,
    required List<XFile> comprovantImages,
    required int profileId,
  }) async {
    try {
      // Primeiro, fazer upload das imagens
      final List<int> comprovantIds = [];
      for (final image in comprovantImages) {
        final id = await _uploadImage(image);
        if (id != null) {
          comprovantIds.add(id);
        }
      }

      if (comprovantIds.isEmpty) {
        throw Exception('Nenhuma imagem foi enviada com sucesso');
      }

      // Criar o corpo da requisição
      final body = {
        'student': studentId.toString(),
        'comprovant': comprovantIds,
        'profile': profileId,
      };

      // Fazer a requisição POST
      final response = await http.post(
        Uri.parse('$baseUrl/baskets'), // Ajuste o endpoint conforme necessário
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );

      return response;
    } catch (e) {
      throw Exception('Erro ao adicionar cesta básica: $e');
    }
  }

  Future<int?> _uploadImage(XFile image) async {
    print('Seu toke $token');
    try {
      final url = Uri.parse('$baseUrl/upload');

      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $token';

      // Adicionar a imagem
      if (kIsWeb) {
        // Para web
        final bytes = await image.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'files',
          bytes,
          filename: image.name,
          contentType: MediaType('image', 'jpeg'),
        ));
      } else {
        // Para mobile/desktop
        final file = io.File(image.path);
        request.files.add(await http.MultipartFile.fromPath(
          'files',
          file.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      // Campos adicionais (ajuste conforme sua API)
      request.fields['ref'] = 'basket';
      request.fields['field'] = 'comprovant';

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = json.decode(responseData);
        return jsonData[0]
            ['id']; // Assumindo que a API retorna uma lista com o ID
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<Basket>> getBaskets() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/baskets'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Basket.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar cestas básicas');
    }
  }
}
