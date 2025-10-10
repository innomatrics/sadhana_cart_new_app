import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FilePickerHelper {
  static Future<File?> pickImage() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (pickedFile != null) {
      return File(pickedFile.files.single.path!);
    }
    return null;
  }
}
