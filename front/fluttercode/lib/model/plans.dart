class Plans {
  final int id;
  final String name;
  final String desc;
  final String benefits;
  final String rules;
  final double value; // Campo como double
  final String color;
  final String publishedAt;
  final String createdAt;
  final String updatedAt;
  final List<dynamic> profiles;
  final List<dynamic> planStores;

  Plans({
    required this.id,
    required this.name,
    required this.desc,
    required this.benefits,
    required this.rules,
    required this.value,
    required this.color,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.profiles,
    required this.planStores,
  });

  factory Plans.fromJson(Map<String, dynamic> json) {
    return Plans(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      benefits: json['benefits'],
      rules: json['rules'],
      value: json['value'].toDouble(), // Converte para double
      color: json['color'],
      publishedAt: json['published_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      profiles: json['profiles'] ?? [],
      planStores: json['plan_stores'] ?? [],
    );
  }
}

class Profiles {
  int? id;
  String? email;
  int? user;
  String? fullname;
  int? plan;
  String? publishedAt;
  String? createdAt;
  String? updatedAt;

  Profiles(
      {this.id,
      this.email,
      this.user,
      this.fullname,
      this.plan,
      this.publishedAt,
      this.createdAt,
      this.updatedAt});

  Profiles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    user = json['user'];
    fullname = json['fullname'];
    plan = json['plan'];
    publishedAt = json['published_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['user'] = this.user;
    data['fullname'] = this.fullname;
    data['plan'] = this.plan;
    data['published_at'] = this.publishedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class PlanStores {
  int? id;
  String? name;
  String? desc;
  String? benefits;
  Null? profile;
  int? plan;
  String? urlLogo;
  String? publishedAt;
  String? createdAt;
  String? updatedAt;

  PlanStores(
      {this.id,
      this.name,
      this.desc,
      this.benefits,
      this.profile,
      this.plan,
      this.urlLogo,
      this.publishedAt,
      this.createdAt,
      this.updatedAt});

  PlanStores.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    desc = json['desc'];
    benefits = json['benefits'];
    profile = json['profile'];
    plan = json['plan'];
    urlLogo = json['urlLogo'];
    publishedAt = json['published_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['desc'] = this.desc;
    data['benefits'] = this.benefits;
    data['profile'] = this.profile;
    data['plan'] = this.plan;
    data['urlLogo'] = this.urlLogo;
    data['published_at'] = this.publishedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
