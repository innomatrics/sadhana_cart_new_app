import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20services/shiprocket_api/shiprocket_api_services.dart';
import 'package:sadhana_cart/core/common%20services/shiprocket_api/token_manager.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://apiv2.shiprocket.in/v1/external/',
      headers: {'Content-Type': 'application/json'},
    ),
  );
});

// TokenManager provider
final tokenManagerProvider = Provider<TokenManager>((ref) {
  return TokenManager();
});

// ShiprocketApiServices provider
final shiprocketApiServiceProvider = Provider<ShiprocketApiServices>((ref) {
  final dio = ref.watch(dioProvider);
  final tokenManager = ref.watch(tokenManagerProvider);
  return ShiprocketApiServices(dio, tokenManager);
});
