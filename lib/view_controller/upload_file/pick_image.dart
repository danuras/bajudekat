import 'package:file_picker/file_picker.dart';

class PickImage {
  static Future<FilePickerResult?> pickImage() async {
    return await FilePicker.platform
        .pickFiles(allowedExtensions: ['jpg', 'png', 'jpeg']);
  }
}
