class Student {
  final int id;
  final String name;
  final String father;
  final String cpf;
  final String phonenumber;
  final String birth;
  final String publishedAt;
  final String createdAt;
  final String updatedAt;

  Student({
    required this.id,
    required this.name,
    required this.father,
    required this.cpf,
    required this.phonenumber,
    required this.birth,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      father: json['father'],
      cpf: json['cpf'],
      phonenumber: json['phonenumber'],
      birth: json['birth'],
      publishedAt: json['published_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}