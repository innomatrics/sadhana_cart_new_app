import 'package:flutter_riverpod/legacy.dart';
import 'package:sadhana_cart/core/helper/hive_helper.dart';

class AuthNotifier extends StateNotifier<bool> {
  static String isLoggedInKey = 'isLoggedIn';

  AuthNotifier() : super(false);

  void login() async {
    await HiveHelper.storeLocalData<bool>(key: isLoggedInKey, value: true);
    state = true;
  }

  void setLoggedIn(bool value) {
    state = value;
  }

  void logout() async {
    await HiveHelper.storeLocalData<bool>(key: isLoggedInKey, value: false);
    state = false;
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});
