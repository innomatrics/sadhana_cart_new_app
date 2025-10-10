class PaymentState {
  final bool isLoading;
  final bool success;
  final String? paymentId;
  final String? error;

  PaymentState({
    required this.isLoading,
    required this.success,
    this.paymentId,
    this.error,
  });

  factory PaymentState.initial() =>
      PaymentState(isLoading: false, success: false);

  PaymentState copyWith({
    bool? isLoading,
    bool? success,
    String? paymentId,
    String? error,
  }) {
    return PaymentState(
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      paymentId: paymentId ?? this.paymentId,
      error: error ?? this.error,
    );
  }
}
