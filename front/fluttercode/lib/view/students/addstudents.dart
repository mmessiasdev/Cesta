import 'dart:io';
import 'dart:typed_data';

import 'package:Cesta/component/buttons.dart';
import 'package:Cesta/component/colors.dart';
import 'package:Cesta/component/padding.dart';
import 'package:Cesta/service/remote/students/crud.dart';
import 'package:Cesta/view/students/webcamerascreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AddStudentScreen extends StatefulWidget {
  final String token;

  const AddStudentScreen({Key? key, required this.token}) : super(key: key);

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late StudentsService apiService;

  // Controladores para os campos do formulário
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fatherController = TextEditingController();
  final TextEditingController _motherController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();

  DateTime? _selectedDate;
  bool _isLoading = false;

  XFile? _selectedPhoto;
  bool _isTakingPhoto = false;

  Uint8List? _selectedPhotoBytes; // Usado para web
  File? _selectedPhotoFile; // Usado para mobile/desktop

  @override
  void initState() {
    super.initState();
    apiService = StudentsService();
  }

  Future<void> _takePhoto() async {
    setState(() => _isTakingPhoto = true);

    try {
      if (kIsWeb) {
        // Solução para web
        final ImagePicker picker = ImagePicker();
        final XFile? photo = await picker.pickImage(source: ImageSource.camera);

        if (photo != null) {
          final bytes = await photo.readAsBytes();
          setState(() {
            _selectedPhotoBytes = bytes;
          });
        }
      } else {
        // Solução para mobile/desktop
        // final photo = await Navigator.of(context).push<Uint8List>(
        //   MaterialPageRoute(builder: (context) => WebCameraScreen()),
        // );

        // if (photo != null) {
        //   final directory = await getTemporaryDirectory();
        //   final file = File(
        //       '${directory.path}/student_photo_${DateTime.now().millisecondsSinceEpoch}.jpg');
        //   await file.writeAsBytes(photo);
        //   setState(() {
        //     _selectedPhotoFile = file;
        //   });
        // }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao capturar foto: $e')),
      );
    } finally {
      setState(() => _isTakingPhoto = false);
    }
  }

  Future<void> _pickPhoto() async {
    setState(() => _isTakingPhoto = true);

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (photo != null) {
        if (kIsWeb) {
          final bytes = await photo.readAsBytes();
          setState(() {
            _selectedPhotoBytes = bytes;
          });
        } else {
          setState(() {
            _selectedPhotoFile = File(photo.path);
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao selecionar foto: $e')),
      );
    } finally {
      setState(() => _isTakingPhoto = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // No seu formulário de cadastro:
        final result = await StudentsService().createStudent(
          name: _nameController.text,
          father: _fatherController.text,
          cpf: _cpfController.text,
          phonenumber: _phoneController.text,
          birth: _birthController.text,
          mother: _motherController.text,
          address: _addressController.text,
          neighborhood: _neighborhoodController.text,
          token: widget.token,
          // photo: _selectedPhoto, // XFile obtido do image_picker
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aluno cadastrado com sucesso!')),
        );
        Navigator.of(context).pop(true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar aluno: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _getPhoto({bool fromCamera = true}) async {
    setState(() => _isTakingPhoto = true);

    try {
      if (kIsWeb) {
        // Para web
        final picker = ImagePicker();
        final pickedFile = await (fromCamera
            ? picker.pickImage(source: ImageSource.camera)
            : picker.pickImage(source: ImageSource.gallery));

        if (pickedFile != null) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _selectedPhotoBytes = bytes;
            _selectedPhotoFile = null; // Não usado na web
          });
        }
      } else {
        // Para mobile/desktop
        if (fromCamera) {
          // final photo = await Navigator.of(context).push<Uint8List>(
          //   MaterialPageRoute(builder: (context) => WebCameraScreen()),
          // );
          // if (photo != null) {
          //   final directory = await getTemporaryDirectory();
          //   final file = File(
          //       '${directory.path}/student_photo_${DateTime.now().millisecondsSinceEpoch}.jpg');
          //   await file.writeAsBytes(photo);
          //   setState(() {
          //     _selectedPhotoFile = file;
          //     _selectedPhotoBytes = null; // Só usado na web
          //   });
          // }
        } else {
          final picker = ImagePicker();
          final pickedFile =
              await picker.pickImage(source: ImageSource.gallery);
          if (pickedFile != null) {
            setState(() {
              _selectedPhotoFile = File(pickedFile.path);
              _selectedPhotoBytes = null; // Só usado na web
            });
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Erro ao ${fromCamera ? 'capturar' : 'selecionar'} foto: $e')),
      );
    } finally {
      setState(() => _isTakingPhoto = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Novo Aluno'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do aluno';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fatherController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Pai',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do pai';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _motherController,
                decoration: const InputDecoration(
                  labelText: 'Nome da mãe',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o CPF';
                  }
                  if (value.length != 11) {
                    return 'CPF deve ter 11 dígitos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _neighborhoodController,
                decoration: const InputDecoration(
                  labelText: 'Bairro',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Endereço',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone';
                  }
                  return null;
                },
              ),
              // const SizedBox(height: 16),
              // // Replace the existing GestureDetector with this improved version
              // GestureDetector(
              //   onTap: () {
              //     showModalBottomSheet(
              //       context: context,
              //       builder: (context) => Column(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           ListTile(
              //             leading: Icon(Icons.camera),
              //             title: Text('Tirar Foto'),
              //             onTap: () {
              //               Navigator.pop(context);
              //               _takePhoto();
              //             },
              //           ),
              //           ListTile(
              //             leading: Icon(Icons.photo_library),
              //             title: Text('Escolher da Galeria'),
              //             onTap: () {
              //               Navigator.pop(context);
              //               _pickPhoto();
              //             },
              //           ),
              //         ],
              //       ),
              //     );
              //   },
              //   child: Container(
              //     height: 150,
              //     decoration: BoxDecoration(
              //       color: Colors.grey[200],
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: _isTakingPhoto
              //         ? Center(child: CircularProgressIndicator())
              //         : (_selectedPhotoFile != null ||
              //                 _selectedPhotoBytes != null)
              //             ? ClipRRect(
              //                 borderRadius: BorderRadius.circular(8),
              //                 child: kIsWeb
              //                     ? Image.memory(
              //                         _selectedPhotoBytes!,
              //                         width: double.infinity,
              //                         height: 150,
              //                         fit: BoxFit.cover,
              //                       )
              //                     : Image.file(
              //                         _selectedPhotoFile!,
              //                         width: double.infinity,
              //                         height: 150,
              //                         fit: BoxFit.cover,
              //                       ),
              //               )
              //             : Column(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 children: [
              //                   Icon(Icons.camera_alt,
              //                       size: 50, color: Colors.grey),
              //                   SizedBox(height: 8),
              //                   Text('Adicionar Foto',
              //                       style: TextStyle(color: Colors.grey)),
              //                 ],
              //               ),
              //   ),
              // ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _birthController,
                decoration: InputDecoration(
                  labelText: 'Data de Nascimento',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione a data de nascimento';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : DefaultButton(
                        text: 'Cadastrar Aluno',
                        padding: defaultPadding,
                        color: PrimaryColor,
                        colorText: lightColor,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _birthController.dispose();
    super.dispose();
  }
}
