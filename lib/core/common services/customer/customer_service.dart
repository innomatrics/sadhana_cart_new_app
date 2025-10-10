import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20model/customer/customer_model.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/core/helper/avoid_null_values.dart';
import 'package:sadhana_cart/core/helper/firebase_message_helper.dart';
import 'package:sadhana_cart/core/helper/firebase_storage_helper.dart';
import 'package:sadhana_cart/core/widgets/snack_bar.dart';

class CustomerService {
  static const String customer = 'users';
  static final CollectionReference customerRef = FirebaseFirestore.instance
      .collection(customer);
  static final String customerId = FirebaseAuth.instance.currentUser!.uid;

  static Future<CustomerModel?> fetCurrentUserDetails({
    required Ref ref,
  }) async {
    try {
      ref.read(loadingProvider.notifier).state = true;
      final DocumentSnapshot documentSnapshot = await customerRef
          .doc(customerId)
          .get();
      if (documentSnapshot.exists) {
        return CustomerModel.fromMap(
          documentSnapshot.data() as Map<String, dynamic>,
        );
      } else {
        log("customer service error");
      }
    } catch (e) {
      log("customer service error $e");
      return null;
    }
    return null;
  }

  static Future<bool> createUserProfile({
    required String name,
    required String email,
    String? profileImage,
  }) async {
    try {
      final String safeName = name.length >= 6 ? name.substring(0, 6) : name;

      final String referralCode = "${safeName.toUpperCase()}$customerId";

      final token = await FirebaseMessageHelper.createFcmToken();

      final CustomerModel customerModel = CustomerModel(
        customerId: customerId,
        name: name,
        email: email,
        contactNo: null,
        referralCode: referralCode,
        referredBy: null,
        gender: null,
        fcmToken: token,
        profileImage: profileImage,
      );

      await customerRef.doc(customerId).set(customerModel.toMap());
      return true;
    } catch (e) {
      log("customer service error $e");
      return false;
    }
  }

  static Future<bool> referCustomer({required String referralCode}) async {
    try {
      final QuerySnapshot querySnapshot = await customerRef
          .where('referralCode', isEqualTo: referralCode)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = await customerRef
            .doc(customerId)
            .get();
        if (documentSnapshot.exists) {
          await documentSnapshot.reference.update({"referredBy": referralCode});
          return true;
        } else {
          log("failed to refer");
          return false;
        }
      }
    } catch (e) {
      log("customer profile service $e");
      return false;
    }
    return false;
  }

  static Future<bool> updateCustomerProfile({
    required WidgetRef ref,
    required BuildContext context,
    required String name,
    File? profileImage,
    required int contactNo,
    String? gender,
  }) async {
    try {
      ref.read(loadingProvider.notifier).state = true;

      final DocumentSnapshot documentSnapshot = await customerRef
          .doc(customerId)
          .get();

      if (!documentSnapshot.exists) throw Exception("Customer not found");

      String? imageUrl;
      if (profileImage != null) {
        imageUrl = await FirebaseStorageHelper.uploadImageToFirebaseStorage(
          file: profileImage,
        );
      }

      final customerModel = CustomerModel(
        customerId: customerId,
        name: name,
        profileImage: imageUrl,
        contactNo: contactNo,
        gender: gender,
      );

      final cleanedData = AvoidNullValues.removeNullValuesDeep(
        customerModel.toMap(),
      );

      await documentSnapshot.reference.update(cleanedData);

      if (context.mounted) {
        showCustomSnackbar(
          type: ToastType.success,
          message: "Profile updated successfully",
          context: context,
        );
      }

      return true;
    } catch (e) {
      ref.read(loadingProvider.notifier).state = false;
      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: "Failed to update profile",
          type: ToastType.error,
        );
      }
      log("customer profile service error: $e");
      return false;
    }
  }

  static Future<CustomerModel?> getCurrentUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final doc = await customerRef.doc(user.uid).get();
      if (!doc.exists) return null;

      return CustomerModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      log('Error fetching user profile: $e');
      return null;
    }
  }
}
