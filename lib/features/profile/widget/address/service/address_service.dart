import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/core/helper/avoid_null_values.dart';
import 'package:sadhana_cart/core/widgets/snack_bar.dart';
import 'package:sadhana_cart/features/profile/widget/address/model/address_model.dart';
import 'package:sadhana_cart/features/profile/widget/address/view%20model/address_notifier.dart';

class AddressService {
  static const String addressCollection = "address";
  static const String userCollection = "users";
  static final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  static final CollectionReference addressRef = FirebaseFirestore.instance
      .collection(userCollection)
      .doc(currentUserId)
      .collection(addressCollection);

  static Future<bool> addAddress({
    required BuildContext context,
    required String name,
    required String streetName,
    required String city,
    required String state,
    required String title,
    required int pinCode,
    required int phoneNumber,
    required IconData icon,
    required WidgetRef ref,
    required double lattitude,
    required double longitude,
  }) async {
    try {
      ref.read(loadingProvider.notifier).state = true;
      final docRef = addressRef.doc();
      final iconCode = icon.codePoint;
      final AddressModel addressModel = AddressModel(
        title: title,
        icon: iconCode,
        id: docRef.id,
        name: name,
        streetName: streetName,
        city: city,
        state: state,
        pinCode: pinCode,
        phoneNumber: phoneNumber,
        lattitude: lattitude,
        longitude: longitude,
        timestamp: Timestamp.now(),
      );
      await docRef.set(addressModel.toMap());
      //store in local state
      ref.read(addressprovider.notifier).addAddress(address: addressModel);
      //store in local storage
      if (context.mounted) {
        showCustomSnackbar(
          type: ToastType.success,
          message: "Address added successfully",
          context: context,
        );
      }
      ref.read(loadingProvider.notifier).state = false;
      return true;
    } catch (e) {
      ref.read(loadingProvider.notifier).state = false;
      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: "Something went wrong",
          type: ToastType.error,
        );
      }
      log("address service error $e");
      return false;
    }
  }

  static Future<List<AddressModel>> fetchAllAddress() async {
    try {
      final QuerySnapshot querySnapshot = await addressRef.get();
      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs
            .map((e) => AddressModel.fromMap(e.data() as Map<String, dynamic>))
            .toList();
        return data;
      }
    } catch (e) {
      log("address service error $e");
    }
    return [];
  }

  static Future<bool> deleteAddress({
    required String id,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      ref.read(addressDeleteLoader.notifier).state = true;
      final QuerySnapshot querySnapshot = await addressRef
          .where("id", isEqualTo: id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
        final document = querySnapshot.docs
            .map((e) => AddressModel.fromMap(e.data() as Map<String, dynamic>))
            .first;
        ref.read(addressprovider.notifier).deleteAddress(address: document);
        ref.read(addressDeleteLoader.notifier).state = false;
        if (context.mounted) {
          showCustomSnackbar(
            message: "Address deleted",
            context: context,
            type: ToastType.success,
          );
        }
        return true;
      }
    } catch (e) {
      log("address service error $e");
      ref.read(addressDeleteLoader.notifier).state = false;
      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: "Failed to delete address",
          type: ToastType.error,
        );
      }
      return false;
    }
    return false;
  }

  static Future<bool> updateAddress({
    required BuildContext context,
    required String id,
    required String name,
    required String streetName,
    required String city,
    required String state,
    required String title,
    required int pinCode,
    required double lattitude,
    required double longitude,
    required int phoneNumber,
    required IconData icon,
    required WidgetRef ref,
  }) async {
    try {
      ref.read(loadingProvider.notifier).state = true;
      final DocumentSnapshot documentSnapshot = await addressRef.doc(id).get();
      if (documentSnapshot.exists) {
        final iconCode = icon.codePoint;
        final AddressModel addressModel = AddressModel(
          id: id,
          name: name,
          streetName: streetName,
          city: city,
          state: state,
          pinCode: pinCode,
          phoneNumber: phoneNumber,
          lattitude: lattitude,
          longitude: longitude,
          timestamp: Timestamp.now(),
          title: title,
          icon: iconCode,
        );
        final newData = AvoidNullValues.removeNullValuesDeep(
          addressModel.toMap(),
        );
        await documentSnapshot.reference.update(newData);
        ref.read(addressprovider.notifier).updateAddress();
        ref.read(loadingProvider.notifier).state = false;
        if (context.mounted) {
          showCustomSnackbar(
            type: ToastType.success,
            message: "Address Updated Successfully",
            context: context,
          );
        }
        return true;
      }
    } catch (e) {
      ref.read(loadingProvider.notifier).state = false;
      log("address service error $e");
      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: "Failed to update address",
          type: ToastType.error,
        );
      }
      return false;
    }
    return false;
  }
}
