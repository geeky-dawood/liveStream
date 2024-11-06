import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImagePicker _picker = ImagePicker();
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );
  XFile? _imageFile;
  List<Face> _faces = [];
  Future<void> _detectFaces() async {
    if (_imageFile == null) return;
    final inputImage = InputImage.fromFilePath(_imageFile!.path);
    final faces = await _faceDetector.processImage(inputImage);

    if (kDebugMode) {
      print(faces.length);
    }
    setState(() => _faces = faces);
  }

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = pickedImage;
      _faces = [];
    });
    await _detectFaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: _imageFile == null
            ? const Text('Take a picture to detect faces.')
            : Stack(
                alignment: Alignment.center,
                children: [
                  Image.file(File(_imageFile!.path)),
                  if (_faces.isNotEmpty)
                    CustomPaint(
                      painter: FacePainter(_faces),
                    ),
                  if (_faces.isEmpty) const Text('No faces detected'),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Capture Image',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }
}

class FacePainter extends CustomPainter {
  final List<Face> faces;
  FacePainter(this.faces);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    for (Face face in faces) {
      canvas.drawRect(face.boundingBox, paint);
      for (final landmark in face.landmarks.values) {
        final position = landmark?.position;
        if (position != null) {
          canvas.drawCircle(
            Offset(position.x.toDouble(), position.y.toDouble()),
            4,
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
