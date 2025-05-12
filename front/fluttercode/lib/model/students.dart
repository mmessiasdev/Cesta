class Student {
  final int id;
  final String name;
  final String father;
  final String phonenumber;
  final String birth;
  final String cpf;
  final String mother;
  final String? address;
  final String? neighborhood;
  final String? publishedAt;
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
    required this.mother,
    this.address,
    this.neighborhood,
    this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.baskets,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      father: json['father'] as String? ?? '',
      phonenumber: json['phonenumber'] as String? ?? '',
      birth: json['birth'] as String? ?? '',
      cpf: json['cpf'] as String? ?? '',
      mother: json['mother'] as String? ?? '',
      address: json['address'] as String?,
      neighborhood: json['neighborhood'] as String?,
      publishedAt: json['published_at'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      baskets: (json['baskets'] as List<dynamic>?)
              ?.map((basket) => Basket.fromJson(basket as Map<String, dynamic>))
              .toList() ??
          [],
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
      'mother': mother,
      'address': address,
      'neighborhood': neighborhood,
      'published_at': publishedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'baskets': baskets.map((basket) => basket.toJson()).toList(),
    };
  }
}

class Basket {
  final int id;
  final int profile;
  final int student;
  final String? publishedAt;
  final String createdAt;
  final String updatedAt;
  final List<Comprovant> comprovants;

  Basket({
    required this.id,
    required this.profile,
    required this.student,
    this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.comprovants,
  });

  factory Basket.fromJson(Map<String, dynamic> json) {
    return Basket(
      id: json['id'] as int? ?? 0,
      profile: json['profile'] as int? ?? 0,
      student: json['student'] as int? ?? 0,
      publishedAt: json['published_at'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      comprovants: (json['comprovant'] as List<dynamic>?)
              ?.map((comp) => Comprovant.fromJson(comp as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile': profile,
      'student': student,
      'published_at': publishedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'comprovant': comprovants.map((comp) => comp.toJson()).toList(),
    };
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
    final formats = json['formats'] as Map<String, dynamic>? ?? {};
    final thumbnail = formats['thumbnail'] as Map<String, dynamic>?;
    final medium = formats['medium'] as Map<String, dynamic>?;
    final small = formats['small'] as Map<String, dynamic>?;

    return Comprovant(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
      thumbnailUrl: thumbnail?['url'] as String?,
      mediumUrl: medium?['url'] as String?,
      smallUrl: small?['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'formats': {
        'thumbnail': thumbnailUrl != null ? {'url': thumbnailUrl} : null,
        'medium': mediumUrl != null ? {'url': mediumUrl} : null,
        'small': smallUrl != null ? {'url': smallUrl} : null,
      },
    };
  }
}