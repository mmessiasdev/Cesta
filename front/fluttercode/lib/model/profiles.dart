// models/profile_model.dart
class Profile {
  final int id;
  final String email;
  final int user;
  final String fullname;
  final int plan;
  final String? birth;
  final String? father;
  final String publishedAt;
  final String createdAt;
  final String updatedAt;

  Profile({
    required this.id,
    required this.email,
    required this.user,
    required this.fullname,
    required this.plan,
    this.birth,
    this.father,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      email: json['email'],
      user: json['user'],
      fullname: json['fullname'],
      plan: json['plan'],
      birth: json['birth'],
      father: json['father'],
      publishedAt: json['published_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'user': user,
      'fullname': fullname,
      'plan': plan,
      'birth': birth,
      'father': father,
      'published_at': publishedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}