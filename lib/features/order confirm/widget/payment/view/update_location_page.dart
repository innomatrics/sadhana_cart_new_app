import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/core/helper/validation_helper.dart';
import 'package:sadhana_cart/core/widgets/custom_elevated_button.dart';
import 'package:sadhana_cart/core/widgets/custom_text_form_field.dart';
import 'package:sadhana_cart/core/widgets/loader.dart';
import 'package:sadhana_cart/features/profile/widget/address/service/address_service.dart';

class UpdateLocationPage extends ConsumerStatefulWidget {
  const UpdateLocationPage({super.key});

  @override
  ConsumerState<UpdateLocationPage> createState() => _UpdateLocationPageState();
}

class _UpdateLocationPageState extends ConsumerState<UpdateLocationPage> {
  final nameController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Dropdown variables
  String? selectedTitle;
  final List<String> titleOptions = ["Home", "Work", "Other"];

  @override
  void dispose() {
    nameController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _addNewAddress() async {
    if (!formKey.currentState!.validate()) return;

    final success = await AddressService.addAddress(
      context: context,
      name: nameController.text.trim(),
      streetName: streetController.text.trim(),
      city: cityController.text.trim(),
      state: stateController.text.trim(),
      title: selectedTitle ?? "Other",
      pinCode: int.parse(zipCodeController.text.trim()),
      phoneNumber: int.parse(phoneNumberController.text.trim()),
      icon: Icons.location_on_outlined,
      ref: ref,
      lattitude: 0.0,
      longitude: 0.0,
    );

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loader = ref.watch(loadingProvider);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomElevatedButton(
          onPressed: _addNewAddress,
          child: loader
              ? const Loader()
              : const Text("Add Address", style: customElevatedButtonTextStyle),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 26),
                child: Text(
                  "Shipping",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    spacing: 20,
                    children: [
                      // Dropdown for Title
                      DropdownButtonFormField<String>(
                        value: selectedTitle,
                        decoration: const InputDecoration(
                          labelText: "Title",
                          border: OutlineInputBorder(),
                        ),
                        items: titleOptions.map((String title) {
                          return DropdownMenuItem<String>(
                            value: title,
                            child: Text(title),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedTitle = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select a title";
                          }
                          return null;
                        },
                      ),
                      CustomTextFormField(
                        controller: nameController,
                        labelText: "Name",
                        validator: ValidationHelper.validateTextField(
                          text: "Name",
                        ),
                      ),

                      CustomTextFormField(
                        controller: streetController,
                        labelText: "Street",
                        validator: ValidationHelper.validateTextField(
                          text: "Street",
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
                        labelText: "Zip Code",
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        validator: ValidationHelper.validateTextField(
                          text: "Zip Code",
                        ),
                      ),
                      CustomTextFormField(
                        controller: phoneNumberController,
                        labelText: "Phone Number",
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        validator: ValidationHelper.validateTextField(
                          text: "Phone Number",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
