import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/app%20routes/app_routes.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';
import 'package:sadhana_cart/core/helper/main_helper.dart';
import 'dart:io';
import 'package:sadhana_cart/core/helper/permission_helper.dart';
import 'package:sadhana_cart/core/service/notification_service.dart';
import 'package:sadhana_cart/features/splash/view/splash_page_mobile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MainHelper.inits();
  final container = ProviderContainer();
  await NotificationService(container: container).initialize();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestNotificationPermission();
    });
  }

  Future<void> _requestNotificationPermission() async {
    // iOS permission is already requested inside NotificationService.initialize().
    // Avoid double prompts on iOS; still request on Android (Tiramisu+).
    if (Platform.isAndroid) {
      await PermissionHelper.askNotificationPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sadhana Cart",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColor.pureWhite,
        appBarTheme: const AppBarTheme(backgroundColor: AppColor.pureWhite),
      ),
      themeMode: ThemeMode.light,
      routes: AppRoutes.routes,
      navigatorKey: NotificationService.navigatorKey,
      home: const SplashPageMobile(),
    );
  }
}
