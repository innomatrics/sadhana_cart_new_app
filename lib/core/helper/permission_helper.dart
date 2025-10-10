import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> checkLocationPermission() async {
    final Permission locationPermission = Permission.location;
    var status = await locationPermission.status;

    if (status.isDenied || status.isRestricted) {
      status = await locationPermission.request();
      if (!status.isGranted) {
        return false;
      }
    }
    return true;
  }

  static Future<bool> askNotificationPermission() async {
    final Permission permission = Permission.notification;
    var status = await permission.status;
    if (status.isDenied || status.isRestricted) {
      status = await permission.request();
      if (!status.isGranted) {
        return false;
      }
    }
    return true;
  }
}
