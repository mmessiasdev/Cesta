// model/students.dart
class Student {
  final int id;
  final String name;
  final String father;
  final String phonenumber;
  final String birth;
  final String cpf;
  final String publishedAt;
  final String createdAt;
  final String updatedAt;
  final List<Basket> baskets;

  Student({
    required this.id,
    required this.name,
    required this.father,
    required this.phonenumber,
    required this.birth,
    required this.cpf,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.baskets,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      father: json['father'],
      phonenumber: json['phonenumber'],
      birth: json['birth'],
      cpf: json['cpf'],
      publishedAt: json['published_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      baskets: (json['baskets'] as List)
          .map((basket) => Basket.fromJson(basket))
          .toList(),
    );
  }
}

class Basket {
  final int id;
  final int profile;
  final int student;
  final String publishedAt;
  final String createdAt;
  final String updatedAt;
  final List<Comprovant> comprovants;

  Basket({
    required this.id,
    required this.profile,
    required this.student,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.comprovants,
  });

  factory Basket.fromJson(Map<String, dynamic> json) {
    return Basket(
      id: json['id'],
      profile: json['profile'],
      student: json['student'],
      publishedAt: json['published_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      comprovants: (json['comprovant'] as List)
          .map((comprovant) => Comprovant.fromJson(comprovant))
          .toList(),
    );
  }
}

class Comprovant {
  final int id;
  final String name;
  final String url;
  final String thumbnailUrl;
  final String mediumUrl;
  final String smallUrl;

  Comprovant({
    required this.id,
    required this.name,
    required this.url,
    required this.thumbnailUrl,
    required this.mediumUrl,
    required this.smallUrl,
  });

  factory Comprovant.fromJson(Map<String, dynamic> json) {
    final formats = json['formats'];
    return Comprovant(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      thumbnailUrl: formats['thumbnail']['url'],
      mediumUrl: formats['medium']['url'],
      smallUrl: formats['small']['url'],
    );
  }
}