import 'dart:convert';
import 'package:Cesta/env.dart';
import 'package:Cesta/model/students.dart';
import 'package:http/http.dart' as http;

class StudentsService {
  final String baseUrl = EnvSecret().BASEURL;

  StudentsService();

  Future<List<Student>> fetchStudents({
    String? searchQuery, 
    required String token
  }) async {
    try {
      Uri uri;

      if (searchQuery != null && searchQuery.isNotEmpty) {
        uri = Uri.parse('$baseUrl/students?_q=$searchQuery');
      } else {
        uri = Uri.parse('$baseUrl/students');
      }

      print('Making request to: ${uri.toString()}');
      print('Using token: $token');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => Student.fromJson(item)).toList();
      } else {
        throw Exception(
          'Failed to load students: ${response.statusCode} - ${response.body}'
        );
      }
    } catch (e) {
      print('Error in fetchStudents: $e');
      throw Exception('Failed to load students: $e');
    }
  }

  Future<Student> createStudent({
    required String token,
    required String name,
    required String father,
    required String cpf,
    required String phonenumber,
    required String birth,
    required String mother,
    required String address,
    required String neighborhood,
  }) async {
    try {
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
          'mother': mother,
          'address': address,
          'neighborhood': neighborhood
        }),
      );

      if (response.statusCode == 200) {
        return Student.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create student: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in createStudent: $e');
      throw Exception('Failed to create student: $e');
    }
  }
}