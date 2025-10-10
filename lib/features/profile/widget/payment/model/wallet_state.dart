// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:sadhana_cart/features/profile/widget/payment/model/wallet_model.dart';

class WalletState {
  final List<WalletModel> wallet;
  final bool isLoading;
  final String? error;
  WalletState({this.wallet = const [], this.isLoading = false, this.error});

  factory WalletState.initial() {
    return WalletState(wallet: [], isLoading: false, error: null);
  }
  @override
  String toString() =>
      'WalletState(wallet: $wallet, isLoading: $isLoading, error: $error)';

  WalletState copyWith({
    List<WalletModel>? wallet,
    bool? isLoading,
    String? error,
  }) {
    return WalletState(
      wallet: wallet ?? this.wallet,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
