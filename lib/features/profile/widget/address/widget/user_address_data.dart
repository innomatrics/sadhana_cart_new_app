import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/widgets/custom_text_button.dart';
import 'package:sadhana_cart/features/profile/widget/address/view model/address_notifier.dart';
import 'package:sadhana_cart/features/profile/widget/address/widget/address_loader_page.dart';
import 'package:sadhana_cart/features/profile/widget/address/widget/edit_address_page.dart';

class UserAddressData extends ConsumerStatefulWidget {
  const UserAddressData({super.key});

  @override
  ConsumerState<UserAddressData> createState() => _UserAddressDataState();
}

class _UserAddressDataState extends ConsumerState<UserAddressData> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(addressprovider.notifier).updateAddress();
    });
  }

  @override
  Widget build(BuildContext context) {
    final addressState = ref.watch(addressprovider);
    final Size size = MediaQuery.of(context).size;

    if (addressState.isLoading) {
      return const AddressLoaderPage();
    }

    if (addressState.error != null) {
      return Center(child: Text('Error: ${addressState.error}'));
    }

    if (addressState.addresses.isEmpty) {
      return const Center(child: Text("No address found."));
    }

    return ListView.builder(
      itemCount: addressState.addresses.length,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final address = addressState.addresses[index];
        final icons = IconData(address.icon ?? 0, fontFamily: 'MaterialIcons');

        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          height: size.height * 0.15,
          width: size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(icons, size: 40),
                title: Text(address.title ?? ""),
                subtitle: Text(address.city),
                trailing: CustomTextButton(
                  text: "Edit",
                  textDecoration: TextDecoration.underline,
                  color: Colors.red,
                  onPressed: () => navigateTo(
                    context: context,
                    screen: EditAddressPage(address: address),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "${address.streetName} ${address.city}, ${address.state},",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
