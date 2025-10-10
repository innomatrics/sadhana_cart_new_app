import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/auth%20service/auth_service.dart';
import 'package:sadhana_cart/core/common%20repo/auth/auth_notifier.dart';
import 'package:sadhana_cart/core/common%20repo/auth/onboard_notifier.dart';
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
import 'package:sadhana_cart/features/auth/view/forgot%20password/view/forgot_password_mobile.dart';
import 'package:sadhana_cart/features/auth/view/sign%20up/view/sign_up_mobile.dart';
import 'package:sadhana_cart/features/bottom%20nav/view/bottom_nav_bar_mobile.dart';
import 'package:sadhana_cart/features/bottom%20nav/view/bottom_nav_option.dart';
import 'package:sadhana_cart/features/profile/view%20model/user_notifier.dart';

class SignInMobile extends ConsumerStatefulWidget {
  const SignInMobile({super.key});

  @override
  ConsumerState<SignInMobile> createState() => _SignInMobileState();
}

class _SignInMobileState extends ConsumerState<SignInMobile> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loader = ref.watch(loadingProvider);
    final passwordEye = ref.watch(passEyeProvider);
    final auth = ref.watch(authNotifierProvider.notifier);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: AbsorbPointer(
              absorbing: loader,
              child: AutofillGroup(
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    const Text(
                      "Log into\nyour account",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      controller: emailController,
                      labelText: "Email address",
                      validator: ValidationHelper.emailValidate(),
                      autofillHints: [AutofillHints.email],
                    ),
                    CustomTextFormField(
                      controller: passwordController,
                      labelText: "Password",
                      validator: ValidationHelper.passwordValidate(
                        number: passwordController.text.length,
                      ),
                      autofillHints: [AutofillHints.password],
                      obscureText: passwordEye,
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordEye ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          ref.read(passEyeProvider.notifier).state =
                              !passwordEye;
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomTextButton(
                        text: "Forgot Password?",
                        onPressed: () {
                          navigateTo(
                            context: context,
                            screen: const ForgotPasswordMobile(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: CustomElevatedButton(
                        child: loader
                            ? const Loader()
                            : const Text(
                                "Sign In",
                                style: customElevatedButtonTextStyle,
                              ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final user = await AuthService.signIn(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              ref: ref,
                              context: context,
                            );
                            if (user != null && context.mounted) {
                              navigateTo(
                                context: context,
                                screen: const BottomNavBarMobile(),
                              );
                              ref.read(authNotifierProvider.notifier).login();
                              ref.invalidate(getCurrentUserProfile);
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
                    Center(
                      child: RoundedSigninButton(
                        imagePath: AppImages.googleSvg,
                        onTap: () async {
                          final bool isSuccess =
                              await GoogleLoginService.signInWithGoogle(
                                context: context,
                              );
                          ref.read(onboardProvider.notifier).setSeen();
                          auth.setLoggedIn(true);
                          auth.setLoggedIn(true);
                          ref.invalidate(getCurrentUserProfile);
                          if (isSuccess && context.mounted) {
                            navigateToReplacement(
                              context: context,
                              screen: const BottomNavOption(),
                            );
                          }
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        CustomTextButton(
                          text: "Sign Up",
                          onPressed: () async {
                            navigateTo(
                              context: context,
                              screen: const SignUpMobile(),
                            );
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
      ),
    );
  }
}
