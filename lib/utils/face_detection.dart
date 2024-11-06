import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

final FaceDetector faceDetector = GoogleMlKit.vision.faceDetector(
  FaceDetectorOptions(
    enableLandmarks: true,
    enableClassification: true,
  ),
);

Future<void> detectFaces(XFile? imageFile) async {
  final inputImage = InputImage.fromFilePath(imageFile?.path ?? '');
  final List<Face> faces = await faceDetector.processImage(inputImage);

  // Handle the detected faces
  for (Face face in faces) {
    // Get the bounding box of the face
    final Rect boundingBox = face.boundingBox;

    // You can also get other properties of the face, such as landmarks
    final FaceLandmark? leftEye = face.landmarks[FaceLandmarkType.leftEye];

    // Get the probability of the face being smiling
    final double? smilingProbability = face.smilingProbability;

    // Get the probability of the face having its eyes open

    final double? leftEyeOpenProbability = face.leftEyeOpenProbability;

    // Get the probability of the face having its eyes open
    final double? rightEyeOpenProbability = face.rightEyeOpenProbability;

//print results
    if (kDebugMode) {
      print('Bounding box: $boundingBox');
      print('Left eye: $leftEye');
      print('Smiling probability: $smilingProbability');
      print('Left eye open probability: $leftEyeOpenProbability');
      print('Right eye open probability: $rightEyeOpenProbability');
    }
  }
}
