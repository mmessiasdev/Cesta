class Student {
  final int id;
  final String name;
  final String father;
  final String phonenumber;
  final String? birth;
  final String cpf;
  final String? publishedAt;
  final String? createdAt;
  final String? updatedAt;
  final List<Basket> baskets;

  Student({
    required this.id,
    required this.name,
    required this.father,
    required this.phonenumber,
    this.birth,
    required this.cpf,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    required this.baskets,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      father: json['father'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
      birth: json['birth']?.toString(),
      cpf: json['cpf'] ?? '',
      publishedAt: json['published_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      baskets: (json['baskets'] as List? ?? [])
          .map((basket) => Basket.fromJson(basket))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'father': father,
      'phonenumber': phonenumber,
      'birth': birth,
      'cpf': cpf,
      'published_at': publishedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Basket {
  final int id;
  final int profile;
  final int student;
  final String? publishedAt;
  final String? createdAt;
  final String? updatedAt;
  final List<Comprovant> comprovants;

  Basket({
    required this.id,
    required this.profile,
    required this.student,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    required this.comprovants,
  });

  factory Basket.fromJson(Map<String, dynamic> json) {
    return Basket(
      id: json['id'] ?? 0,
      profile: json['profile'] ?? 0,
      student: json['student'] ?? 0,
      publishedAt: json['published_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      comprovants: (json['comprovant'] as List? ?? [])
          .map((c) => Comprovant.fromJson(c))
          .toList(),
    );
  }
}

class Comprovant {
  final int id;
  final String name;
  final String url;
  final String? thumbnailUrl;
  final String? mediumUrl;
  final String? smallUrl;

  Comprovant({
    required this.id,
    required this.name,
    required this.url,
    this.thumbnailUrl,
    this.mediumUrl,
    this.smallUrl,
  });

  factory Comprovant.fromJson(Map<String, dynamic> json) {
    final formats = json['formats'] ?? {};
    return Comprovant(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      thumbnailUrl: formats['thumbnail']?['url']?.toString(),
      mediumUrl: formats['medium']?['url']?.toString(),
      smallUrl: formats['small']?['url']?.toString(),
    );
  }
}
