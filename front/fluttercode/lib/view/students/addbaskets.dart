import 'dart:io';
import 'dart:io' as io;
import 'package:Cesta/component/buttons.dart';
import 'package:Cesta/component/padding.dart';
import 'package:Cesta/service/remote/baskets/crud.dart';
import 'package:Cesta/view/students/camerascreen.dart';
import 'package:Cesta/view/students/webcamerascreen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:Cesta/component/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
// import 'package:image_picker_web/image_picker_web.dart';

class AddBasketScreen extends StatefulWidget {
  final String token;
  final int studentId;
  final int profileId;

  const AddBasketScreen({
    Key? key,
    required this.token,
    required this.profileId,
    required this.studentId,
  }) : super(key: key);

  @override
  _AddBasketScreenState createState() => _AddBasketScreenState();
}

class _AddBasketScreenState extends State<AddBasketScreen> {
  late BasketService _basketService;
  final ImagePicker _picker = ImagePicker();
  List<XFile> _comprovantImages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _basketService = BasketService(token: widget.token);
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

  Widget _buildImagePreview(XFile image) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: _getImageProvider(image),
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

  ImageProvider _getImageProvider(XFile image) {
    if (kIsWeb) {
      return NetworkImage(image.path);
    } else {
      return FileImage(File(image.path));
    }
  }

  void _takePhoto() async {
    final ImagePicker picker = ImagePicker();

    try {
      XFile? image;

      if (kIsWeb) {
        // Para Web
        image = await picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1800,
          maxHeight: 1800,
          imageQuality: 90,
        );
      } else if (io.Platform.isAndroid || io.Platform.isIOS) {
        // Para Android/iOS
        image = await picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1800,
          maxHeight: 1800,
          imageQuality: 90,
        );
      } else {
        print("Plataforma não suportada para captura de foto.");
        return;
      }

      if (image != null) {
        setState(() => _comprovantImages.add(image!));
      }
    } catch (e) {
      print("Erro ao capturar foto: $e");
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 90,
      );
      if (images.isNotEmpty) {
        setState(() {
          _comprovantImages.addAll(images);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao selecionar imagens: ${e.toString()}')),
      );
    }
  }

  void _removeImage(XFile image) {
    setState(() {
      _comprovantImages.remove(image);
    });
  }

  Future<void> _saveBasket() async {
    try {
      final response = await _basketService.addBasket(
          studentId: widget.studentId,
          comprovantImages: _comprovantImages,
          profileId: widget.profileId);

      if (response.statusCode == 200) {
        setState(() => _isLoading = true);
        Navigator.of(context).pop(true); // Retorna true indicando sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cesta básica adicionada com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro no servidor: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
