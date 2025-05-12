import 'dart:async';
import 'dart:typed_data';
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

class WebCameraScreen extends StatefulWidget {
  const WebCameraScreen({Key? key}) : super(key: key);

  @override
  _WebCameraScreenState createState() => _WebCameraScreenState();
}

class _WebCameraScreenState extends State<WebCameraScreen> {
  html.MediaStream? _mediaStream;
  html.VideoElement? _videoElement;
  bool _isLoading = true;
  bool _isRecording = false;
  static const String _viewType = 'camera-view';

  @override
  void initState() {
    super.initState();
    _registerViewFactory();
    _startCamera();
  }

  void _registerViewFactory() {
    // Registra a fábrica de visualização
    ui.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) => html.DivElement()
        ..style.width = '100%'
        ..style.height = '100%',
    );
  }

  Future<void> _startCamera() async {
    try {
      final mediaStream =
          await html.window.navigator.mediaDevices?.getUserMedia({
        'video': {'facingMode': 'environment'},
        'audio': false
      });

      if (mediaStream != null) {
        _mediaStream = mediaStream;
        _videoElement = html.VideoElement()
          ..srcObject = mediaStream
          ..autoplay = true
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.objectFit = 'cover';

        // Adiciona o elemento de vídeo ao DOM
        final platformView = html.document.getElementById(_viewType);
        if (platformView != null) {
          platformView.children.clear();
          platformView.append(_videoElement!);
        }

        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Erro ao acessar câmera: $e");
      if (mounted) Navigator.pop(context);
    }
  }

  Future<Uint8List?> _takePicture() async {
    if (_videoElement == null || _isRecording) return null;

    setState(() => _isRecording = true);

    try {
      final canvas = html.CanvasElement(
        width: _videoElement!.videoWidth,
        height: _videoElement!.videoHeight,
      );
      final ctx = canvas.context2D;
      ctx.drawImage(_videoElement!, 0, 0);

      // Método corrigido para obter os bytes da imagem
      final completer = Completer<Uint8List>();
      canvas.toBlob('image/jpeg', 0.9).then((blob) {
        final reader = html.FileReader();
        reader.onLoadEnd.listen((e) {
          if (reader.result != null) {
            completer.complete(Uint8List.fromList(reader.result as List<int>));
          } else {
            completer.complete(null);
          }
        });
        reader.readAsArrayBuffer(blob!);
      });

      return await completer.future;
    } catch (e) {
      print("Erro ao capturar foto: $e");
      return null;
    } finally {
      if (mounted) {
        setState(() => _isRecording = false);
      }
    }
  }

  @override
  void dispose() {
    _mediaStream?.getTracks().forEach((track) => track.stop());
    super.dispose();
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
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: HtmlElementView(
              viewType: _viewType,
              key: UniqueKey(),
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
                        final bytes = await _takePicture();
                        if (bytes != null && mounted) {
                          Navigator.pop(context, bytes);
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
