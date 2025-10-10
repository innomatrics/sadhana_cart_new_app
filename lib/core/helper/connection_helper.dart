import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionHelper {
  static final List<ConnectivityResult> connection = [
    ConnectivityResult.mobile,
    ConnectivityResult.wifi,
    ConnectivityResult.ethernet,
    ConnectivityResult.vpn,
  ];
  static Future<bool> checkInternetConnection() async {
    if (connection.contains(ConnectivityResult.ethernet) ||
        connection.contains(ConnectivityResult.mobile) ||
        connection.contains(ConnectivityResult.vpn) ||
        connection.contains(ConnectivityResult.wifi)) {
      return true;
    } else {
      return false;
    }
  }
}
