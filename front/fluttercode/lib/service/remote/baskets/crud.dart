import 'dart:io';
import 'package:NIDE/env.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class BasketService {
  final String token;
  final String baseUrl = EnvSecret().BASEURL;

  BasketService({required this.token});

  String _getBasename(String filePath) {
    return filePath.split(RegExp(r'[\\/]')).last;
  }

  Future<http.Response> addBasket({
    required int studentId,
    required List<File> comprovantImages,
  }) async {
    final uri = Uri.parse('$baseUrl/baskets');
    var request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['student'] = studentId.toString();

    for (var image in comprovantImages) {
      final mimeType = lookupMimeType(image.path) ?? 'image/jpeg';
      final fileType = mimeType.split('/');

      request.files.add(
        await http.MultipartFile.fromPath(
          'files.comprovant',
          image.path,
          filename: _getBasename(image.path),
          contentType: MediaType(fileType[0], fileType[1]),
        ),
      );
    }

    final streamedResponse = await request.send();
    return http.Response.fromStream(streamedResponse);
  }
}
