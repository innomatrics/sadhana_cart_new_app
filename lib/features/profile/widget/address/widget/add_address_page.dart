import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/core/helper/geolocation_helper.dart';
import 'package:sadhana_cart/core/helper/validation_helper.dart';
import 'package:sadhana_cart/core/widgets/custom_drop_down.dart';
import 'package:sadhana_cart/core/widgets/custom_elevated_button.dart';
import 'package:sadhana_cart/core/widgets/custom_text_form_field.dart';
import 'package:sadhana_cart/core/widgets/loader.dart';
import 'package:sadhana_cart/features/profile/widget/address/model/address_helper.dart';
import 'package:sadhana_cart/features/profile/widget/address/service/address_service.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final streetNameController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();
  final phoneNumberController = TextEditingController();

  double? lattitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _fetchAndFillAddress();
  }

  Future<void> _fetchAndFillAddress() async {
    final addressModel =
        await GeolocationHelper.getCurrentLocationAndFillAddressDetails();
    log(addressModel.toString());
    if (addressModel != null && mounted) {
      setState(() {
        streetNameController.text = addressModel.streetName;
        cityController.text = addressModel.city;
        stateController.text = addressModel.state;
        zipCodeController.text = addressModel.pinCode.toString();
        lattitude = addressModel.lattitude;
        longitude = addressModel.longitude;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    streetNameController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Add Address here",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Consumer(
            builder: (context, ref, child) {
              final icon = ref.watch(userAdderssIconProvider);
              final title = ref.watch(userAddressTitleProvider);
              final loader = ref.watch(loadingProvider);

              return AbsorbPointer(
                absorbing: loader,
                child: Form(
                  key: formKey,
                  child: Column(
                    spacing: 20,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropDown<String>(
                              items: AddressIconType.values
                                  .map(
                                    (e) => DropdownMenuItem<String>(
                                      value: e.label,
                                      child: Text(e.label),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) =>
                                  ref
                                          .read(
                                            userAddressTitleProvider.notifier,
                                          )
                                          .state =
                                      value ?? "Home",
                              value: title,
                              labelText: "Select Address Type",
                            ),
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            child: CustomDropDown<IconData>(
                              items: AddressIconType.values
                                  .map(
                                    (e) => DropdownMenuItem<IconData>(
                                      value: e.icon,
                                      child: Icon(e.icon),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) =>
                                  ref
                                          .read(
                                            userAdderssIconProvider.notifier,
                                          )
                                          .state =
                                      value ?? Icons.home,
                              value: icon,
                              labelText: "Select Address Icon",
                            ),
                          ),
                        ],
                      ),
                      CustomTextFormField(
                        controller: nameController,
                        labelText: "Name",
                        validator: ValidationHelper.validateTextField(
                          text: "Name",
                        ),
                      ),
                      CustomTextFormField(
                        controller: streetNameController,
                        labelText: "Street Name",
                        validator: ValidationHelper.validateTextField(
                          text: "Street Name",
                        ),
                      ),
                      CustomTextFormField(
                        controller: cityController,
                        labelText: "City",
                        validator: ValidationHelper.validateTextField(
                          text: "City",
                        ),
                      ),
                      CustomTextFormField(
                        controller: stateController,
                        labelText: "State",
                        validator: ValidationHelper.validateTextField(
                          text: "State",
                        ),
                      ),
                      CustomTextFormField(
                        controller: zipCodeController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        labelText: "Zip Code",
                        validator: ValidationHelper.validateTextField(
                          text: "Zip Code",
                        ),
                      ),
                      CustomTextFormField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        labelText: "Phone Number",
                        validator: ValidationHelper.validateTextField(
                          text: "Phone Number",
                        ),
                      ),

                      const SizedBox(height: 30),
                      CustomElevatedButton(
                        child: loader
                            ? const Loader()
                            : const Text(
                                "Save",
                                style: customElevatedButtonTextStyle,
                              ),
                        onPressed: () async {
                          final valid = formKey.currentState?.validate();
                          if (!valid!) return;
                          if (valid) {
                            final isSuccess = await AddressService.addAddress(
                              context: context,
                              name: nameController.text.trim(),
                              streetName: streetNameController.text.trim(),
                              city: cityController.text.trim(),
                              state: stateController.text.trim(),
                              title: title,
                              pinCode: int.parse(zipCodeController.text.trim()),
                              phoneNumber: int.parse(
                                phoneNumberController.text.trim(),
                              ),
                              icon: icon,
                              ref: ref,
                              lattitude: lattitude ?? 0.0,
                              longitude: longitude ?? 0.0,
                            );
                            if (isSuccess && context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
