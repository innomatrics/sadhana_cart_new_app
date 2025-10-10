import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessageHelper {
  static Future<String?> createFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }
}
