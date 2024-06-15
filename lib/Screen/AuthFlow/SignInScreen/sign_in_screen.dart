import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantist_app_/Screen/AuthFlow/SignInScreen/forgot_password_bottomsheet.dart';
import 'package:plantist_app_/Screen/AuthFlow/SignInScreen/sign_in_viewmodel.dart';
import 'package:plantist_app_/Screen/AuthFlow/base_auth_screen.dart';

class SignInScreen extends StatelessWidget {
  final SignInViewModel _signInViewModel = Get.put(SignInViewModel());

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
            isEmailValid: _signInViewModel.isEmailValid,
            emailController: _signInViewModel.forgotPasswordEmailController,
            onSendPressed: () => _signInViewModel.forgotPassword(
                email: _signInViewModel.forgotPasswordEmailController.text),
            isLoading: _signInViewModel.isForgotPasswordLoading,
          ),
        );
      },
    );
  }
}
