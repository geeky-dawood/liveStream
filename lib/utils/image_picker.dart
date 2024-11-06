import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  // Capture a photo
  final XFile? photo = await picker.pickImage(source: ImageSource.camera);
  return photo;
}
