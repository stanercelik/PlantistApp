import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantist_app_/Components/custom_text_field.dart';
import 'package:plantist_app_/Screen/AuthFlow/SignUpScreen/sign_up_viewmodel.dart';
import 'package:plantist_app_/Components/custom_wide_button.dart';
import 'package:plantist_app_/Resources/app_colors.dart';

class SignUpScreen extends StatelessWidget {
  final SignUpViewModel _signUpViewModel = Get.put(SignUpViewModel());

  SignUpScreen({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sign up with email',
              style: TextStyle(
                  color: AppColors.textPrimaryColor,
                  fontSize: 32,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your email and password',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 32),
            Obx(
              () => CustomTextField(
                controller: _signUpViewModel.emailController,
                hintText: 'E-mail',
                keyboardType: TextInputType.emailAddress,
                isValid: _signUpViewModel.isEmailValid.value,
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => CustomTextField(
                controller: _signUpViewModel.passwordController,
                hintText: 'Password',
                obscureText: true,
                isValid: _signUpViewModel.isPasswordValid.value,
              ),
            ),
            const SizedBox(height: 32),
            Obx(
              () {
                var isAllValid = _signUpViewModel.isEmailValid.value &&
                    _signUpViewModel.isPasswordValid.value;
                return CustomWideButton(
                  onPressed:
                      isAllValid ? () => _signUpViewModel.createUser() : null,
                  text: 'Create Account',
                  backgroundColor: isAllValid
                      ? AppColors.enabledButtonColor
                      : AppColors.disabledButtonColor,
                  foregroundColor: Colors.white,
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
                        const SnackBar(content: Text('Privacy Policy tapped')),
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
    );
  }
}
