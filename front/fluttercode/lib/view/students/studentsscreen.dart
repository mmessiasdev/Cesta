import 'package:Cesta/model/students.dart';
import 'package:Cesta/service/remote/students/crud.dart';
import 'package:flutter/material.dart';
import 'package:Cesta/component/buttons/iconlist.dart';
import 'package:Cesta/component/colors.dart';
import 'package:Cesta/component/padding.dart';
import 'package:Cesta/component/widgets/header.dart';
import 'package:Cesta/view/students/addstudents.dart';
import 'package:Cesta/view/students/studentdetail.dart';

class StudentsScreen extends StatefulWidget {
  final String token;
  final int profileId;

  const StudentsScreen({Key? key, required this.token, required this.profileId})
      : super(key: key);

  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  late Future<List<Student>> futureStudents;
  late StudentsService apiService;
  final TextEditingController searchController = TextEditingController();
  String currentSearch = '';

  @override
  void initState() {
    super.initState();
    apiService = StudentsService();
    // Inicializa imediatamente com um Future vazio
    futureStudents = Future.value([]);

    // Executa após o build inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.token.isNotEmpty) {
        _refreshStudents();
      } else {
        print('Token ausente!');
      }
    });
  }

  void _refreshStudents() {
    setState(() {
      futureStudents = apiService.fetchStudents(
        searchQuery: currentSearch,
        token: widget.token,
      );
    });
  }

  void _searchStudents() {
    setState(() {
      currentSearch = searchController.text;
      futureStudents = apiService.fetchStudents(
        searchQuery: currentSearch,
        token: widget.token,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      body: Padding(
        padding: defaultPaddingHorizon,
        child: ListView(
          children: [
            MainHeader(title: "Cesta"),
            const SizedBox(height: 40),
            IconList(
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddStudentScreen(token: widget.token),
                  ),
                ).then((_) => _refreshStudents());
              },
              icon: Icons.add,
              title: "Adicionar aluno",
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _refreshStudents,
                tooltip: 'Atualizar lista',
              ),
            ),
            const SizedBox(height: 5),
            FutureBuilder<List<Student>>(
              future: futureStudents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text('Erro ao carregar estudantes'),
                          SizedBox(height: 10),
                          Text(
                            '${snapshot.error}',
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          ElevatedButton(
                            onPressed: _refreshStudents,
                            child: Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        currentSearch.isEmpty
                            ? 'Nenhum estudante encontrado.'
                            : 'Nenhum resultado para "$currentSearch".',
                      ),
                    ),
                  );
                } else {
                  return Column(
                    children: snapshot.data!.map((student) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentDetailScreen(
                                student: student,
                                token: widget.token,
                                profileId: widget.profileId,
                              ),
                            ),
                          ).then(
                              (_) => _refreshStudents()); // REMOVA ESTA LINHA
                        },
                        child: Card(
                          margin: defaultPadding,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Container(
                            width: double.infinity,
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
                                Text(
                                    'Nascimento: ${student.birth ?? "Não informado"}'),
                                const SizedBox(height: 8),
                                Text(
                                  'Cadastrado em: ${student.createdAt ?? "Não informado"}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
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
