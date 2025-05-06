class ProfileModel {
  int? id;
  String? email;
  User? user;
  String? fullname;
  ProfilePlans? plan;
  Null? enterprise;
  Null? student;
  String? curriculumdesc;
  String? birth;
  int? permission;
  String? publishedAt;
  String? createdAt;
  String? updatedAt;
  List<Null>? verifiquedBuyLocalStores;
  List<Null>? verfiquedExitBalances;
  List<Null>? ProfilePlanstores;
  List<Null>? favcourses;
  List<Null>? coursescerfiticates;
  List<Null>? vacancies;
  List<Null>? father;
  List<Dependents>? dependents;

  ProfileModel(
      {this.id,
      this.email,
      this.user,
      this.fullname,
      this.plan,
      this.enterprise,
      this.student,
      this.curriculumdesc,
      this.birth,
      this.permission,
      this.publishedAt,
      this.createdAt,
      this.updatedAt,
      this.verifiquedBuyLocalStores,
      this.verfiquedExitBalances,
      this.ProfilePlanstores,
      this.favcourses,
      this.coursescerfiticates,
      this.vacancies,
      this.father,
      this.dependents});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    fullname = json['fullname'];
    plan = json['plan'] != null ? ProfilePlans.fromJson(json['plan']) : null;
    enterprise = json['enterprise'];
    student = json['student'];
    curriculumdesc = json['curriculumdesc'];
    birth = json['birth'];
    permission = json['permission'];
    publishedAt = json['published_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['dependents'] != null) {
      dependents = <Dependents>[];
      json['dependents'].forEach((v) {
        dependents!.add(new Dependents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['fullname'] = this.fullname;
    if (this.plan != null) {
      data['plan'] = this.plan!;
    }
    data['enterprise'] = this.enterprise;
    data['student'] = this.student;
    data['curriculumdesc'] = this.curriculumdesc;
    data['birth'] = this.birth;
    data['permission'] = this.permission;
    data['published_at'] = this.publishedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.dependents != null) {
      data['dependents'] = this.dependents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? id;
  String? username;
  String? email;
  String? provider;
  bool? confirmed;
  bool? blocked;
  int? role;
  int? profile;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.username,
      this.email,
      this.provider,
      this.confirmed,
      this.blocked,
      this.role,
      this.profile,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    provider = json['provider'];
    confirmed = json['confirmed'];
    blocked = json['blocked'];
    role = json['role'];
    profile = json['profile'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['provider'] = this.provider;
    data['confirmed'] = this.confirmed;
    data['blocked'] = this.blocked;
    data['role'] = this.role;
    data['profile'] = this.profile;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;

    return data;
  }
}

class ProfilePlans {
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
  final List<dynamic> ProfilePlanstores;

  ProfilePlans({
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
    required this.ProfilePlanstores,
  });

  factory ProfilePlans.fromJson(Map<String, dynamic> json) {
    return ProfilePlans(
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
      ProfilePlanstores: json['plan_stores'] ?? [],
    );
  }
}

class Dependents {
  int? id;
  String? email;
  int? user;
  String? fullname;
  int? plan;
  Null? enterprise;
  Null? student;
  Null? curriculumdesc;
  Null? birth;
  int? father;
  String? publishedAt;
  String? createdAt;
  String? updatedAt;

  Dependents(
      {this.id,
      this.email,
      this.user,
      this.fullname,
      this.plan,
      this.enterprise,
      this.student,
      this.curriculumdesc,
      this.birth,
      this.father,
      this.publishedAt,
      this.createdAt,
      this.updatedAt});

  Dependents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    user = json['user'];
    fullname = json['fullname'];
    plan = json['plan'];
    enterprise = json['enterprise'];
    student = json['student'];
    curriculumdesc = json['curriculumdesc'];
    birth = json['birth'];
    father = json['father'];
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
    data['enterprise'] = this.enterprise;
    data['student'] = this.student;
    data['curriculumdesc'] = this.curriculumdesc;
    data['birth'] = this.birth;
    data['father'] = this.father;
    data['published_at'] = this.publishedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
