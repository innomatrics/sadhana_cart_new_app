// address_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/helper/geolocation_helper.dart';
import 'package:sadhana_cart/features/profile/widget/address/model/address_model.dart';
import 'package:sadhana_cart/features/profile/widget/address/model/address_state.dart';
import 'package:sadhana_cart/features/profile/widget/address/service/address_service.dart';

final addressprovider = StateNotifierProvider<AddressNotifier, AddressState>(
  (ref) => AddressNotifier(),
);

final getCurrentLocationProvider = FutureProvider<AddressModel?>((ref) async {
  return await GeolocationHelper.getCurrentLocationAndFillAddressDetails();
});

class AddressNotifier extends StateNotifier<AddressState> {
  AddressNotifier() : super(AddressState.initial());

  Future<void> updateAddress() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final addresses = await AddressService.fetchAllAddress();
      state = state.copyWith(isLoading: false, addresses: addresses);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void deleteAddress({required AddressModel address}) {
    final updatedList = state.addresses
        .where((e) => e.id != address.id)
        .toList();
    state = state.copyWith(addresses: updatedList);
  }

  void addAddress({required AddressModel address}) {
    state = state.copyWith(addresses: [...state.addresses, address]);
  }
}
