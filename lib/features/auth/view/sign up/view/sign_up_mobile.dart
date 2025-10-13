import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/auth%20service/auth_service.dart';
import 'package:sadhana_cart/core/common%20repo/auth/auth_notifier.dart';
import 'package:sadhana_cart/core/common%20repo/auth/onboard_notifier.dart';
import 'package:sadhana_cart/core/common%20services/customer/customer_service.dart';
import 'package:sadhana_cart/core/constants/app_images.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/helper/validation_helper.dart';
import 'package:sadhana_cart/core/service/google_auth_service.dart';
import 'package:sadhana_cart/core/widgets/custom_elevated_button.dart';
import 'package:sadhana_cart/core/widgets/custom_text_button.dart';
import 'package:sadhana_cart/core/widgets/custom_text_form_field.dart';
import 'package:sadhana_cart/core/widgets/loader.dart';
import 'package:sadhana_cart/core/widgets/rounded_signin_button.dart';
import 'package:sadhana_cart/features/auth/view/sign%20up/view/sign_in_mobile.dart';
import 'package:sadhana_cart/features/bottom%20nav/view/bottom_nav_option.dart';
import 'package:sadhana_cart/features/profile/view%20model/user_notifier.dart';

class SignUpMobile extends ConsumerStatefulWidget {
  const SignUpMobile({super.key});

  @override
  ConsumerState<SignUpMobile> createState() => _SignUpMobileState();
}

class _SignUpMobileState extends ConsumerState<SignUpMobile> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final confirmEye = ref.watch(confirmPassEyeProvider);
    final passEye = ref.watch(passEyeProvider);
    final loader = ref.watch(loadingProvider);
    //final storageNotifier = ref.watch(secureStorageNotifier.notifier);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: AbsorbPointer(
              absorbing: loader,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Create\nyour account ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: nameController,
                    labelText: "Enter your name",
                    validator: ValidationHelper.validateTextField(text: "Name"),
                  ),
                  CustomTextFormField(
                    controller: emailController,
                    labelText: "Email address",
                    validator: ValidationHelper.emailValidate(),
                  ),
                  CustomTextFormField(
                    controller: passwordController,
                    labelText: "Password",
                    obscureText: passEye,
                    suffixIcon: IconButton(
                      onPressed: () =>
                          ref.read(passEyeProvider.notifier).state = !passEye,
                      icon: Icon(
                        passEye ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    validator: ValidationHelper.passwordValidate(
                      number: passwordController.text.length,
                    ),
                  ),
                  CustomTextFormField(
                    controller: confirmPasswordController,
                    obscureText: confirmEye,
                    suffixIcon: IconButton(
                      onPressed: () =>
                          ref.read(confirmPassEyeProvider.notifier).state =
                              !confirmEye,
                      icon: Icon(
                        confirmEye ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    labelText: "Confirm password",
                    validator: ValidationHelper.passwordValidate(
                      number: confirmPasswordController.text.length,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: CustomElevatedButton(
                      child: loader
                          ? const Loader()
                          : const Text(
                              "Sign Up",
                              style: customElevatedButtonTextStyle,
                            ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final bool isSuccess =
                              await AuthService.createAccount(
                                context: context,
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                ref: ref,
                              );
                          final bool profile =
                              await CustomerService.createUserProfile(
                                email: emailController.text.trim(),
                                name: nameController.text.trim(),
                              );
                          if (isSuccess && profile && context.mounted) {
                            navigateToReplacement(
                              context: context,
                              screen: const BottomNavOption(),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      "or continue with",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  // Center(
                  //   child: RoundedSigninButton(
                  //     imagePath: AppImages.googleSvg,
                  //     onTap: () async {
                  //       //store details for autofill data
                  //       // storageNotifier.setEmailandPassword(
                  //       //   email: emailController.text.trim(),
                  //       //   password: passwordController.text.trim(),
                  //       // );
                  //       final bool isSuccess =
                  //           await GoogleLoginService.signInWithGoogle(
                  //             context: context,
                  //           );

                  //       if (isSuccess) {
                  //         ref.read(onboardProvider.notifier).setSeen();
                  //         ref.invalidate(getCurrentUserProfile);

                  //         ref
                  //             .read(authNotifierProvider.notifier)
                  //             .setLoggedIn(true);

                  //         if (context.mounted) {
                  //           navigateToReplacement(
                  //             context: context,
                  //             screen: const BottomNavOption(),
                  //           );
                  //         }
                  //       }
                  //     },
                  //   ),
                  // ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      CustomTextButton(
                        text: "Sign In",
                        onPressed: () {
                          navigateTo(
                            context: context,
                            screen: const SignInMobile(),
                          );
                          ref.invalidate(getCurrentUserProfile);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
