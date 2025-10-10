import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sadhana_cart/core/common%20services/shiprocket_api/token_manager.dart';

class ShiprocketApiServices {
  final Dio dio;
  final TokenManager tokenManager;
  ShiprocketApiServices(this.dio, this.tokenManager);

  static const String getWarehouseAddress =
      "https://apiv2.shiprocket.in/v1/external/settings/company/pickup";

  static const String trackingUrl =
      "https://apiv2.shiprocket.in/v1/external/courier/track/shipment/";

  static const String checkShippingCharges =
      "https://apiv2.shiprocket.in/v1/external/courier/serviceability/";

  static const String cancelOrderUrl =
      "https://apiv2.shiprocket.in/v1/external/orders/cancel";

  //we are storing this here only because we
  static const String email = "appasharan@gmail.com";
  static const String password = "sadhanaCart@83";

  Future<String> _login(String email, String password) async {
    final url = "https://apiv2.shiprocket.in/v1/external/auth/login";
    final response = await dio.post(
      url,
      data: {'email': email, 'password': password},
    );

    final token = response.data['token'] as String?;
    if (token == null) throw Exception("Failed to get token");

    tokenManager.setToken(token);
    return token;
  }

  Future<String> _getValidToken() async {
    if (tokenManager.token == null || tokenManager.isTokenExpired()) {
      return await _login(email, password);
    }
    return tokenManager.token!;
  }

  Future<double> getShippingCharges({
    required String pinCode,
    required double weight,
  }) async {
    try {
      final response = await dio.get(
        'https://apiv2.shiprocket.in/v1/external/courier/serviceability/',
        queryParameters: {
          'pickup_postcode': 583227,
          'delivery_postcode': pinCode,
          'weight': weight,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer YOUR_AUTH_TOKEN',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final availableCouriers =
            data['data']['available_courier_companies'] as List<dynamic>?;

        if (availableCouriers != null && availableCouriers.isNotEmpty) {
          final firstCourier = availableCouriers[0];
          final rate = firstCourier['rate'] as double? ?? 0.0;
          return rate;
        }
      }
      return 0.0;
    } catch (e) {
      log("Error getting shipping charges: $e");
      return 0.0;
    }
  }

  Future<Map<String, dynamic>> createOrder(
    Map<String, dynamic> orderData,
  ) async {
    final token = await _getValidToken();
    final url = 'https://apiv2.shiprocket.in/v1/external/orders/create/adhoc';
    debugPrint(url);
    final response = await dio.post(
      url,
      data: orderData,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        validateStatus: (_) => true,
      ),
    );

    log("Status Code Creating order: ${response.statusCode}");
    log("Response: Creating order ${response.data}");

    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getTrackingDetails({
    required int shipmentId,
  }) async {
    try {
      final token = await _getValidToken();
      final response = await dio.get(
        "$trackingUrl$shipmentId",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 202) {
        final data = response.data as Map<String, dynamic>;
        log("tracking data $data");
        return data;
      } else {
        log("tracking error ${response.data}");
        return {};
      }
    } catch (e) {
      log(e.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    final token = await _getValidToken();

    final url = 'orders/show/$orderId';
    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (_) => true,
        ),
      );

      // log("Order Details status code: ${response.statusCode}");
      // log("Order Details body: ${response.data}");

      return response.data as Map<String, dynamic>;
    } catch (e) {
      //  log("Error fetching order details: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAllOrders() async {
    final token = await _getValidToken();

    final fullUrl = dio.options.baseUrl;

    log("Calling Shiprocket API GET: $fullUrl");
    log("Using token: $token");

    try {
      final response = await dio.get(
        fullUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (_) => true,
        ),
      );

      log("Orders API status code: ${response.statusCode}");
      log("Orders API body: ${response.data}");

      return response.data as Map<String, dynamic>;
    } catch (e) {
      log("Error calling Orders API: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> trackOrder(String shipmentId) async {
    try {
      final token = await _getValidToken();
      final response = await dio.get(
        'https://apiv2.shiprocket.in/v1/external/courier/track/shipment/$shipmentId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log(response.data);
      return response.data;
    } catch (e) {
      throw Exception('Failed to track order: $e');
    }
  }

  Future<Map<String, dynamic>> cancelOrder({required int orderId}) async {
    final token = await _getValidToken();
    final response = await dio.post(
      'orders/cancel/',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      data: {"ids": orderId},
    );
    return response.data as Map<String, dynamic>;
  }
}
