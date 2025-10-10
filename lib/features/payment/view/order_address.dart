import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';
import 'package:sadhana_cart/core/skeletonizer/rating_tile_loader.dart';
import 'package:sadhana_cart/core/widgets/custom_icon_button.dart';
import 'package:sadhana_cart/features/order%20confirm/widget/payment/view/saved_address_page.dart';
import 'package:sadhana_cart/features/profile/widget/address/model/address_model.dart';
import 'package:sadhana_cart/features/profile/widget/address/view%20model/address_notifier.dart';
import 'package:sadhana_cart/features/profile/widget/address/widget/user_address_tile.dart';

class OrderAddress extends ConsumerStatefulWidget {
  const OrderAddress({super.key});

  @override
  ConsumerState<OrderAddress> createState() => _OrderAddressState();
}

class _OrderAddressState extends ConsumerState<OrderAddress> {
  AddressModel? addressModel;
  @override
  Widget build(BuildContext context) {
    final address = ref.watch(addressprovider);

    if (address.isLoading) {
      return const RatingTileLoader();
    }

    if (address.addresses.isEmpty) {
      return const Center(child: Text("No address found."));
    }
    return Column(
      children: [
        address.addresses.isEmpty
            ? CustomIconButton(icon: Icons.add, onPressed: () {})
            : UserAddressTile(
                margin: const EdgeInsets.symmetric(vertical: 8),
                address: addressModel ?? address.addresses.first,
              ),
        GestureDetector(
          onTap: () async {
            final AddressModel selectedAddress = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SavedAddressPage()),
            );
            //user setstate becuase of i added addres widget above
            setState(() {
              addressModel = selectedAddress;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.lightGrey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Edit Address", style: TextStyle(color: Colors.black)),
                Icon(
                  Icons.edit_location_alt_outlined,
                  color: AppColor.dartPrimaryColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
