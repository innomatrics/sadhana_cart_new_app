import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sadhana_cart/core/common%20services/customer/customer_service.dart';
import 'package:sadhana_cart/core/constants/constants.dart';

class GoogleLoginService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static bool _initialized = false;

  static Future<void> _initialize() async {
    if (!_initialized) {
      await _googleSignIn.initialize(clientId: Constants.webClientId);
      _initialized = true;
    }
  }

  static Future<bool> signInWithGoogle({required BuildContext context}) async {
    try {
      await _initialize();
      try {
        final silent = _googleSignIn.attemptLightweightAuthentication();
        if (silent is Future) await silent;
      } catch (_) {}
      if (!_googleSignIn.supportsAuthenticate()) {
        throw UnsupportedError('Platform does not support authenticate().');
      }

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email'],
      );

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCred = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final user = userCred.user;
      await CustomerService.createUserProfile(
        name: user!.displayName!,
        email: user.email ?? "",
        profileImage: user.photoURL ?? "",
      );
      log('Google Sign-In successful for ${user.email}');
      return true;
    } on GoogleSignInException catch (e) {
      log('GoogleSignInException: code=${e.code.name}, desc=${e.description}');
      return false;
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException: ${e.message}');
      return false;
    } catch (e) {
      log('Unexpected error: $e');
      return false;
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }
}
