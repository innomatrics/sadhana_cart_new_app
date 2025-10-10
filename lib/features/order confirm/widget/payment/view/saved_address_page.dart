import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/core/widgets/custom_elevated_button.dart';
import 'package:sadhana_cart/core/widgets/custom_ratio_button.dart';
import 'package:sadhana_cart/features/profile/widget/address/view model/address_notifier.dart';
import 'package:sadhana_cart/features/profile/widget/address/widget/address_loader_page.dart';

class SavedAddressPage extends ConsumerStatefulWidget {
  const SavedAddressPage({super.key});

  @override
  ConsumerState<SavedAddressPage> createState() => _SavedAddressPageState();
}

class _SavedAddressPageState extends ConsumerState<SavedAddressPage> {
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
    final currentIndex = ref.watch(addressRadioButtonProvider);

    if (addressState.isLoading) {
      return const AddressLoaderPage();
    }

    if (addressState.error != null) {
      return Center(child: Text('Error: ${addressState.error}'));
    }

    if (addressState.addresses.isEmpty) {
      return const Scaffold(body: Center(child: Text("No address found.")));
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Saved Address",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomElevatedButton(
          child: const Text(
            "Use Address",
            style: customElevatedButtonTextStyle,
          ),
          onPressed: () {
            final selected = addressState.addresses[currentIndex];
            log("Using address: ${selected.title}");
            Navigator.pop(context, selected);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: addressState.addresses.length,
          itemBuilder: (context, index) {
            final address = addressState.addresses[index];
            final icons = IconData(
              address.icon ?? 0,
              fontFamily: 'MaterialIcons',
            );

            return Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: Border.all(
                  color: currentIndex == index
                      ? Colors.black
                      : Colors.transparent,
                  width: 2,
                ),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(icons, size: 40),
                    title: Text(address.title ?? ""),
                    subtitle: Text(address.city),
                    trailing: CustomRatioButton<int>(
                      value: index,
                      groupValue: currentIndex,
                      onChanged: (value) {
                        ref.read(addressRadioButtonProvider.notifier).state =
                            value!;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "${address.streetName}, ${address.city}, ${address.state}, ${address.pinCode}",
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
        ),
      ),
    );
  }
}
