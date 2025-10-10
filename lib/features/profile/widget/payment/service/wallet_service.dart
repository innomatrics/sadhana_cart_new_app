import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/helper/string_helper.dart';
import 'package:sadhana_cart/core/widgets/snack_bar.dart';
import 'package:sadhana_cart/features/profile/widget/payment/model/wallet_model.dart';
import 'package:sadhana_cart/features/profile/widget/payment/view%20model/wallet_notifier.dart';

class WalletService {
  static const String walletCollection = 'wallet';

  static final CollectionReference walletRef = FirebaseFirestore.instance
      .collection(walletCollection);

  static final userId = FirebaseAuth.instance.currentUser!.uid;

  static Future<bool> addWallet({
    required BuildContext context,
    required String maskedNumber,
    required String expiryDate,
    required String cardHolderName,
    required String paymentToken,
    required String color,
    required String cardBrand,
    required String last4Digits,
    required WidgetRef ref,
  }) async {
    try {
      ref.read(walletLoader.notifier).state = true;
      final docRef = walletRef.doc();
      final masked = StringHelper.maskCardNumber(maskedNumber);
      final WalletModel walletModel = WalletModel(
        cardId: docRef.id,
        customerId: userId,
        maskedNumber: masked,
        expiryDate: expiryDate,
        cardHolderName: cardHolderName,
        paymentToken: paymentToken,
        cardBrand: cardBrand,
        last4Digits: last4Digits,
        color: color,
      );
      await docRef.set(walletModel.toMap());
      if (context.mounted) {
        showCustomSnackbar(
          message: "Wallet added successfully",
          context: context,
          type: ToastType.success,
        );
      }
      ref.read(walletStateProvider.notifier).addWallet(wallet: walletModel);
      ref.read(walletLoader.notifier).state = false;
      return true;
    } catch (e) {
      ref.read(walletLoader.notifier).state = false;
      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: "Failed to add wallet",
          type: ToastType.error,
        );
      }
      log("wallet service error $e");
      return false;
    }
  }

  static Future<bool> deleteWallet({
    required String cardId,
    required WidgetRef ref,
  }) async {
    try {
      final QuerySnapshot querySnapshot = await walletRef
          .where('cardid', isEqualTo: cardId)
          .where('customerId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
        ref.read(walletStateProvider.notifier).deletWallet(cardId: cardId);
        return true;
      }
    } catch (e) {
      log("wallet service error $e");
      return false;
    }
    return false;
  }

  static Future<List<WalletModel>> fetchWallet() async {
    try {
      final QuerySnapshot querySnapshot = await walletRef
          .where("customerId", isEqualTo: userId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((e) => WalletModel.fromMap(e.data() as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      log("wallet service error $e");
      return [];
    }
    return [];
  }
}
