import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});
  @override
  _CamereraScreenState createState() => _CamereraScreenState();
}

class _CamereraScreenState extends State<CameraScreen> {
  List<CameraDescription> cameras = [];
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    _setupCameras();
  }

  Future<void> _setupCameras() async {
    try {
      cameras = await availableCameras();
      await _initCameraController();
    } on CameraException catch (e) {
      print('Error al obtener las cámaras: $e');
    }
  }

  Future<void> _initCameraController() async {
    if (cameras.isEmpty) {
      return;
    }

    final camera = cameras.first;
    controller = CameraController(
      camera,
      ResolutionPreset.medium,
    );

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      print('Error al inicializar la cámara: $e');
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Cámara')),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final image = await controller.takePicture();
                print('Imagen capturada en: ${image.path}');
                // TODO : SEND THE IMAGE TO THE DB
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Imagen guardada en: ${image.path}')),
                  );
                }
              } catch (e) {
                print('Error al tomar la foto: $e');
              }
            },
            child: Text('Tomar Foto'),
          ),
        ],
      ),
    );
  }
}
