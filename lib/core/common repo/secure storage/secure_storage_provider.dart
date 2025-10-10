// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:sadhana_cart/core/common%20repo/secure%20storage/email_and_pass_model.dart';

// final secureStorageNotifier =
//     StateNotifierProvider<SecureStorageProvider, EmailAndPassModel>(
//       (ref) => SecureStorageProvider(),
//     );

// class SecureStorageProvider extends StateNotifier<EmailAndPassModel> {
//   final storage = const FlutterSecureStorage();
//   SecureStorageProvider() : super(EmailAndPassModel.inital());

//   void storeDetails() async {
//     await storage.write(key: 'email', value: state.email);
//     await storage.write(key: 'password', value: state.password);
//   }

//   void setEmailandPassword({required String email, required String password}) {
//     state = EmailAndPassModel(email: email, password: password);
//   }

//   void loadDetails() async {
//     final email = await storage.read(key: 'email');
//     final password = await storage.read(key: 'password');

//     state = EmailAndPassModel(email: email ?? "", password: password ?? "");
//   }
// }
