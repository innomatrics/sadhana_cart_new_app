import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sadhana_cart/features/order%20confirm/widget/payment/controller/payment_state.dart';

class PaymentController extends StateNotifier<PaymentState> {
  late Razorpay _razorpay;
  bool _isPaymentProcessing = false;

  PaymentController() : super(PaymentState.initial()) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void resetPaymentState() {
    state = PaymentState.initial();
    _isPaymentProcessing = false;
  }

  void startPayment({
    required double amount,
    required String contact,
    required String email,
  }) {
    if (_isPaymentProcessing) {
      log("Payment is already processing.");
      return;
    }

    _isPaymentProcessing = true;

    state = PaymentState.initial().copyWith(isLoading: true);
    amount = amount * 100;
    //test key rzp_test_1DP5mmChF5G5ag
    var options = {
      'key': 'rzp_live_RF5gE7NCdAsEIs',
      // 'rzp_test_RCgP4dyI1pibjj',
      // ,
      'amount': amount,
      'name': 'Sadhana Cart',
      'description': 'Order Payment',
      'prefill': {'contact': contact, 'email': email},
    };

    try {
      _razorpay.open(options);
      log("Razorpay opened for payment of ₹${amount / 100}");
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      log("Error opening Razorpay: $e");
      _isPaymentProcessing = false;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (!_isPaymentProcessing) return;

    _isPaymentProcessing = false;

    state = state.copyWith(
      isLoading: false,
      success: true,
      paymentId: response.paymentId,
    );
    log("Payment successful! Payment ID: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (!_isPaymentProcessing) return;

    _isPaymentProcessing = false;

    state = state.copyWith(isLoading: false, error: response.message);
    log(
      "Payment failed or cancelled. Code: ${response.code}, Message: ${response.message}",
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log("External wallet selected: ${response.walletName}");
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}

final paymentProvider = StateNotifierProvider<PaymentController, PaymentState>(
  (ref) => PaymentController(),
);
