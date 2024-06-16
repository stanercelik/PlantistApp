import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantist_app_/Components/custom_text_field.dart';
import 'package:plantist_app_/Components/custom_wide_button.dart';
import 'package:plantist_app_/Resources/app_colors.dart';

class BaseAuthScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final RxBool isEmailValid;
  final RxBool isPasswordValid;
  final RxBool isLoading;
  final RxBool haveForgotPassword;
  final VoidCallback onButtonPressed;
  final VoidCallback? onForgotPasswordPressed;

  const BaseAuthScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.emailController,
    required this.passwordController,
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isLoading,
    required this.onButtonPressed,
    required this.haveForgotPassword,
    this.onForgotPasswordPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: AppColors.backgroundColor,
        leading: IconButton(
          padding: const EdgeInsets.only(top: 40),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimaryColor,
            size: 20,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: AppColors.textPrimaryColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 32),
              Obx(
                () => CustomTextField(
                  controller: emailController,
                  hintText: 'E-mail',
                  keyboardType: TextInputType.emailAddress,
                  isValid: isEmailValid.value,
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  isValid: isPasswordValid.value,
                  keyboardType: TextInputType.visiblePassword,
                  showValidationIcon: false,
                ),
              ),
              haveForgotPassword.value
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: onForgotPasswordPressed,
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(
                                  color: AppColors.textBlueColor,
                                  fontWeight: FontWeight.w500),
                            )),
                      ],
                    )
                  : const SizedBox(height: 64),
              Obx(
                () {
                  var isAllValid = isEmailValid.value && isPasswordValid.value;
                  return CustomWideButton(
                    onPressed:
                        isAllValid && !isLoading.value ? onButtonPressed : null,
                    text: buttonText,
                    backgroundColor: isAllValid
                        ? AppColors.enabledButtonColor
                        : AppColors.disabledButtonColor,
                    foregroundColor: Colors.white,
                    isLoading: isLoading.value,
                  );
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Text(
                      'By continuing, you agree to our',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14, color: AppColors.textSecondaryColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Privacy Policy tapped')),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          'Privacy Policy',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimaryColor,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    const Text(
                      'and ',
                      style: TextStyle(
                          fontSize: 14, color: AppColors.textSecondaryColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Terms of Use tapped')),
                        );
                      },
                      child: const Text(
                        'Terms of Use',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimaryColor,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    const Text(
                      '.',
                      style: TextStyle(
                          fontSize: 14, color: AppColors.textSecondaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
