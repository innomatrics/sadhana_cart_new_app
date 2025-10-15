import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sadhana_cart/features/order/widgets/my%20orders/model/order_cancel_request_model.dart';
import 'package:sadhana_cart/features/order/widgets/my%20orders/service/order_util_service.dart';

final orderCancelProvider =
    StateNotifierProvider<OrderCancelNotifier, OrderCancelState>(
      (ref) => OrderCancelNotifier(ref),
    );

class OrderCancelNotifier extends StateNotifier<OrderCancelState> {
  final Ref ref;
  OrderCancelNotifier(this.ref) : super(OrderCancelState.initial());

  Future<bool> addCancelRequest({
    required int orderId,
    required String reason,
  }) async {
    try {
      state = state.copyWith(isLoading: true, request: [], error: null);
      final bool isSuccess = await OrderUtilService.cancelOrder(
        shiprocketOrderId: orderId,
        reason: reason,
        ref: ref,
      );
      if (isSuccess) {
        final data = await OrderUtilService.getAllRequest();
        state = state.copyWith(isLoading: false, request: data, error: null);
      }
      return isSuccess;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> changeOrderStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      final bool isSuccess = await OrderUtilService.changeOrderStatus(
        orderId: orderId,
        status: status,
      );

      return isSuccess;
    } catch (e) {
      return false;
    }
  }
}
