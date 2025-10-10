import 'package:sadhana_cart/features/profile/widget/address/model/address_model.dart';

class AddressState {
  final List<AddressModel> addresses;
  final bool isLoading;
  final String? error;
  AddressState({this.addresses = const [], this.isLoading = false, this.error});

  factory AddressState.initial() {
    return AddressState(isLoading: true, addresses: [], error: null);
  }
  AddressState copyWith({
    List<AddressModel>? addresses,
    bool? isLoading,
    String? error,
  }) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
