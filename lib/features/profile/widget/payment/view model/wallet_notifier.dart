import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/features/profile/widget/payment/model/wallet_model.dart';
import 'package:sadhana_cart/features/profile/widget/payment/model/wallet_state.dart';
import 'package:sadhana_cart/features/profile/widget/payment/service/wallet_service.dart';

final walletStateProvider = StateNotifierProvider<WalletNotifier, WalletState>(
  (ref) => WalletNotifier(),
);
final walletLoader = StateProvider.autoDispose<bool>((ref) => false);

class WalletNotifier extends StateNotifier<WalletState> {
  WalletNotifier() : super(WalletState.initial());

  void addWallet({required WalletModel wallet}) {
    state = state.copyWith(wallet: [...state.wallet, wallet]);
  }

  void deletWallet({required String cardId}) {
    state = state.copyWith(
      wallet: state.wallet.where((e) => e.cardId != cardId).toList(),
    );
  }

  void fetchWallet() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final wallet = await WalletService.fetchWallet();
      state = state.copyWith(isLoading: false, wallet: wallet);
    } catch (e) {
      log("wallet service error $e");
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void getWalletDataCount() {
    state = state.copyWith(wallet: state.wallet);
  }
}
