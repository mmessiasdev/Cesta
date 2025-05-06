import 'dart:io';
import 'package:NIDE/component/buttons.dart';
import 'package:NIDE/component/padding.dart';
import 'package:NIDE/service/remote/baskets/crud.dart';
import 'package:flutter/material.dart';
import 'package:NIDE/component/colors.dart';
import 'package:image_picker/image_picker.dart';

class AddBasketScreen extends StatefulWidget {
  final String token;
  final int studentId;

  const AddBasketScreen({
    Key? key,
    required this.token,
    required this.studentId,
  }) : super(key: key);

  @override
  _AddBasketScreenState createState() => _AddBasketScreenState();
}

class _AddBasketScreenState extends State<AddBasketScreen> {
  final BasketService _basketService;
  final ImagePicker _picker = ImagePicker();
  List<File> _comprovantImages = [];
  bool _isLoading = false;

  _AddBasketScreenState() : _basketService = BasketService(token: '');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        title: const Text('Adicionar Cesta Básica'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comprovantes de Entrega',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Adicione fotos que comprovem a entrega da cesta básica',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Preview das imagens
            if (_comprovantImages.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _comprovantImages
                    .map((image) => _buildImagePreview(image))
                    .toList(),
              ),

            const SizedBox(height: 20),

            // Botões para adicionar fotos
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Tirar Foto'),
                    onPressed: _takePhoto,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galeria'),
                    onPressed: _pickFromGallery,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            GestureDetector(
              onTap: _comprovantImages.isEmpty ? null : _saveBasket,
              child: DefaultButton(
                padding: defaultPadding,
                colorText: lightColor,
                text: "Salvar Cesta Básica",
                icon: Icons.save,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(File image) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(image),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _comprovantImages.add(File(image.path));
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _comprovantImages.addAll(images.map((xfile) => File(xfile.path)));
      });
    }
  }

  void _removeImage(File image) {
    setState(() {
      _comprovantImages.remove(image);
    });
  }

  Future<void> _saveBasket() async {
    setState(() => _isLoading = true);

    try {
      final response = await _basketService.addBasket(
        studentId: widget.studentId,
        comprovantImages: _comprovantImages,
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${response.body}')),
        );
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
