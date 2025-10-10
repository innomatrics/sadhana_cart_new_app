import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper {
  static final Reference storageRef = FirebaseStorage.instance.ref();
  static const String customerCollection = "customer";

  static Future<String> uploadImageToFirebaseStorage({
    required File file,
  }) async {
    final TaskSnapshot taskSnapshot = await storageRef
        .child(customerCollection)
        .putFile(file);
    return taskSnapshot.ref.getDownloadURL();
  }
}
