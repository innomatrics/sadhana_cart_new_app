import 'package:sadhana_cart/core/common%20model/order/order_model.dart';

class OrderState {
  final bool isLoading;
  final List<OrderModel> orders;
  final String? error;
  OrderState({this.isLoading = false, this.orders = const [], this.error});

  factory OrderState.initial() =>
      OrderState(isLoading: false, orders: [], error: null);

  OrderState copyWith({
    bool? isLoading,
    List<OrderModel>? orders,
    String? error,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      error: error ?? this.error,
    );
  }
}
