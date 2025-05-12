import 'package:path/path.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isLoading = true;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      _controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );

      _initializeControllerFuture = _controller.initialize();
      await _initializeControllerFuture;

      setState(() => _isLoading = false);
    } catch (e) {
      print("Erro ao inicializar câmera: $e");
      if (mounted) {
        Navigator.pop(context as BuildContext);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String?> _takePicture() async {
    if (!_controller.value.isInitialized || _isRecording) {
      return null;
    }

    setState(() => _isRecording = true);

    try {
      final XFile file = await _controller.takePicture(); // Método atualizado
      return file.path; // Retorna o caminho do arquivo
    } catch (e) {
      print("Erro ao tirar foto: $e");
      return null;
    } finally {
      if (mounted) {
        setState(() => _isRecording = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.flash_on, color: Colors.white),
            onPressed: () {
              if (_controller.value.flashMode == FlashMode.off) {
                _controller.setFlashMode(FlashMode.torch);
              } else {
                _controller.setFlashMode(FlashMode.off);
              }
              setState(() {});
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: CameraPreview(_controller),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: _isRecording
                    ? null
                    : () async {
                        final path = await _takePicture();
                        if (path != null && mounted) {
                          Navigator.pop(context, path);
                        }
                      },
                child: Icon(Icons.camera, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
