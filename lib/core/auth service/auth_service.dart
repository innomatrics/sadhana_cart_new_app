import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20repo/auth/onboard_notifier.dart';
import 'package:sadhana_cart/core/common%20services/customer/customer_service.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/core/helper/firebase_message_helper.dart';
import 'package:sadhana_cart/core/widgets/snack_bar.dart';
import 'package:sadhana_cart/features/profile/view%20model/user_notifier.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Current user id
  static String? get currentUser => _auth.currentUser?.uid;

  static final CollectionReference userRef = FirebaseFirestore.instance
      .collection("users");

  // Method to create an account
  static Future<bool> createAccount({
    required String email,
    required String password,
    required String name,
    int? contact,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    ref.read(loadingProvider.notifier).state = true;

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await CustomerService.createUserProfile(name: name, email: email);

      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: "Verification mail sent",
          type: ToastType.success,
        );
      }
      return true;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: e.message.toString(),
          type: ToastType.error,
        );
      }
      rethrow;
    } catch (e) {
      throw Exception('Account creation failed: ${e.toString()}');
    } finally {
      ref.read(loadingProvider.notifier).state = false;
    }
  }

  // Sign in with email and password
  static Future<User?> signIn({
    required String email,
    required String password,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      ref.read(loadingProvider.notifier).state = true;

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final fcmToken = await FirebaseMessageHelper.createFcmToken();

      if (fcmToken != null && credential.user != null) {
        await userRef.doc(credential.user!.uid).update({'fcmToken': fcmToken});
      }

      ref.read(loadingProvider.notifier).state = false;

      return credential.user;
    } on FirebaseAuthException catch (e) {
      ref.read(loadingProvider.notifier).state = false;

      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: e.message.toString(),
          type: ToastType.error,
        );
      }

      if (e.code == 'user-not-found') {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user found for that email.',
        );
      } else if (e.code == 'wrong-password') {
        throw FirebaseAuthException(
          code: 'wrong-password',
          message: 'Incorrect password provided.',
        );
      } else if (e.code == 'invalid-email') {
        throw FirebaseAuthException(
          code: 'invalid-email',
          message: 'The email address is not valid.',
        );
      } else {
        throw FirebaseAuthException(
          code: e.code,
          message: e.message ?? 'An error occurred while signing in.',
        );
      }
    } catch (e) {
      ref.read(loadingProvider.notifier).state = false;

      log("General exception caught: $e");

      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Sign out method
  static Future<void> signOut({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'fcmToken': FieldValue.delete(),
        });
      }

      await FirebaseAuth.instance.signOut();

      ref.invalidate(loadingProvider);
      ref.invalidate(getCurrentUserProfile);
      ref.read(onboardProvider.notifier).setSeen();

      if (context.mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/signup', (route) => false);
      }
    } catch (e) {
      log("Error during sign out: $e");
      throw Exception("Error while signing out: $e");
    }
  }

  // Reset password
  static Future<void> sendPasswordResetEmail(
    String email,
    BuildContext context,
  ) async {
    if (email.isEmpty) {
      showCustomSnackbar(
        context: context,
        message: "Please enter an email",
        type: ToastType.info,
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: "Password reset email sent to $email",
          type: ToastType.success,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "An error occurred";
      if (e.code == 'user-not-found') {
        message = "No user found with this email.";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email format.";
      } else {
        message = e.message ?? message;
      }
      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: message,
          type: ToastType.error,
        );
      }
    } catch (e) {
      log("Unexpected error: $e");
      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: "An unexpected error occurred",
          type: ToastType.error,
        );
      }
    }
  }
}
