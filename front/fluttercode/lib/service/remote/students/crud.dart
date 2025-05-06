import 'dart:convert';
import 'package:NIDE/env.dart';
import 'package:NIDE/model/students.dart';
import 'package:http/http.dart' as http;

class StudentsService {
  final String baseUrl = EnvSecret().BASEURL;
  final String token; // Seu token Bearer

  StudentsService({required this.token});

  Future<List<Student>> fetchStudents({String? searchQuery}) async {
    Uri uri;

    if (searchQuery != null && searchQuery.isNotEmpty) {
      // Para Strapi 3.6, usamos _q para busca textual
      uri = Uri.parse('$baseUrl/students?_q=$searchQuery');
    } else {
      uri = Uri.parse('$baseUrl/students');
    }

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Student> students =
          body.map((item) => Student.fromJson(item)).toList();
      return students;
    } else {
      throw Exception('Failed to load students: ${response.statusCode}');
    }
  }

  Future<Student> createStudent({
  required String name,
  required String father,
  required String cpf,
  required String phonenumber,
  required String birth,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/students'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'name': name,
      'father': father,
      'cpf': cpf,
      'phonenumber': phonenumber,
      'birth': birth,
    }),
  );

  if (response.statusCode == 200) {
    return Student.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create student: ${response.statusCode}');
  }
}
}
