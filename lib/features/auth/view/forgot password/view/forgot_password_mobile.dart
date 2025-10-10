import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/auth%20service/auth_service.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/core/widgets/custom_elevated_button.dart';
import 'package:sadhana_cart/core/widgets/custom_text_form_field.dart';
import 'package:sadhana_cart/core/widgets/loader.dart';

class ForgotPasswordMobile extends StatefulWidget {
  const ForgotPasswordMobile({super.key});

  @override
  State<ForgotPasswordMobile> createState() => _ForgotPasswordMobileState();
}

class _ForgotPasswordMobileState extends State<ForgotPasswordMobile> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer(
          builder: (context, ref, child) {
            final loader = ref.watch(loadingProvider);
            return CustomElevatedButton(
              child: loader
                  ? const Loader()
                  : const Text("Submit", style: customElevatedButtonTextStyle),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                ref.read(loadingProvider.notifier).state = true;
                await AuthService.sendPasswordResetEmail(
                  emailController.text.trim(),
                  context,
                );
                ref.read(loadingProvider.notifier).state = false;
              },
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            const Text(
              "Forgot Password",
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Enter email associated with your account and we will send you a link to reset your password",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 40),
            CustomTextFormField(
              controller: emailController,
              labelText: "Email address",
              prefixIcon: Icon(Icons.email, color: Colors.grey.shade300),
            ),
          ],
        ),
      ),
    );
  }
}
