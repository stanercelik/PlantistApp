import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantist_app_/Screen/AuthFlow/SignInFlow/ForgotPasswordBottomSheet/forgot_password_view.dart';
import 'package:plantist_app_/Screen/AuthFlow/SignInFlow/ForgotPasswordBottomSheet/forgot_password_viewmodel.dart';
import 'package:plantist_app_/Screen/AuthFlow/SignInFlow/SignInScreen/sign_in_viewmodel.dart';
import 'package:plantist_app_/Screen/AuthFlow/BaseAuth/base_auth_view.dart';

class SignInScreen extends StatelessWidget {
  final SignInViewModel _signInViewModel = Get.put(SignInViewModel());
  final ForgotPasswordBottomSheetViewModel _bottomSheetViewModel =
      Get.put(ForgotPasswordBottomSheetViewModel());

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseAuthScreen(
      title: 'Sign in with email',
      subtitle: 'Enter your email and password',
      buttonText: 'Sign In',
      emailController: _signInViewModel.emailController,
      passwordController: _signInViewModel.passwordController,
      isEmailValid: _signInViewModel.isEmailValid,
      isPasswordValid: _signInViewModel.isPasswordValid,
      isLoading: _signInViewModel.isLoading,
      haveForgotPassword: true.obs,
      onButtonPressed: () => _signInViewModel.signIn(),
      onForgotPasswordPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => ForgotPasswordBottomSheet(
            isEmailValid: _bottomSheetViewModel.isForgotPasswordEmailValid,
            emailController:
                _bottomSheetViewModel.forgotPasswordEmailController,
            onSendPressed: () => _bottomSheetViewModel.forgotPassword(
                email:
                    _bottomSheetViewModel.forgotPasswordEmailController.text),
            isLoading: _bottomSheetViewModel.isForgotPasswordLoading,
          ),
        );
      },
      onBiometricAuthPressed: () => _signInViewModel.signInWithBiometrics(),
    );
  }
}
