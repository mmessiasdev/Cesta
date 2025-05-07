import 'package:Cesta/model/profiles.dart';
import 'package:Cesta/model/students.dart';

class Basket {
  final int id;
  final dynamic profile;
  final dynamic student;
  final DateTime publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Comprovant> comprovant;

  Basket({
    required this.id,
    required this.profile,
    required this.student,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.comprovant,
  });

  factory Basket.fromJson(Map<String, dynamic> json) {
    return Basket(
      id: json['id'],
      profile: Profile.fromJson(json['profile']),
      student: Student.fromJson(json['student']),
      publishedAt: DateTime.parse(json['published_at']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      comprovant: List<Comprovant>.from(
          json['comprovant'].map((x) => Comprovant.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile': profile.toJson(),
      'student': student.toJson(),
      'published_at': publishedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
