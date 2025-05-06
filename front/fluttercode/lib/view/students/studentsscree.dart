import 'package:NIDE/component/buttons/iconlist.dart';
import 'package:NIDE/component/colors.dart';
import 'package:NIDE/component/padding.dart';
import 'package:NIDE/component/widgets/header.dart';
import 'package:NIDE/model/students.dart';
import 'package:NIDE/service/remote/students/crud.dart';
import 'package:NIDE/view/students/addstudents.dart';
import 'package:flutter/material.dart';

class StudentsScreen extends StatefulWidget {
  final String token;

  const StudentsScreen({Key? key, required this.token}) : super(key: key);

  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  late Future<List<Student>> futureStudents;
  late StudentsService apiService;
  TextEditingController searchController = TextEditingController();
  String currentSearch = '';

  @override
  void initState() {
    super.initState();
    apiService = StudentsService(token: widget.token);
    futureStudents = apiService.fetchStudents();
  }

  void _searchStudents() {
    setState(() {
      currentSearch = searchController.text;
      futureStudents = apiService.fetchStudents(searchQuery: currentSearch);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      body: Padding(
        padding: defaultPaddingHorizon,
        child: Column(
          children: [
            MainHeader(title: "Cesta"),
            SizedBox(
              height: 40,
            ),
            IconList(
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddStudentScreen(
                      token: widget.token,
                    ),
                  ),
                );
              },
              icon: Icons.add,
              title: "Adicionar aluno",
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar estudante',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchStudents,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (_) => _searchStudents(),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder<List<Student>>(
                future: futureStudents,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        currentSearch.isEmpty
                            ? 'Nenhum estudante encontrado'
                            : 'Nenhum resultado para "$currentSearch"',
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Student student = snapshot.data![index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('Pai: ${student.father}'),
                                Text('CPF: ${student.cpf}'),
                                Text('Telefone: ${student.phonenumber}'),
                                Text('Nascimento: ${student.birth}'),
                                const SizedBox(height: 8),
                                Text(
                                  'Cadastrado em: ${student.createdAt}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
