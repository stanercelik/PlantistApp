import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantist_app_/Screen/AuthFlow/SignUpScreen/sign_up_viewmodel.dart';
import 'package:plantist_app_/Screen/AuthFlow/BaseAuth/base_auth_screen.dart';

class SignUpScreen extends StatelessWidget {
  final SignUpViewModel _signUpViewModel = Get.put(SignUpViewModel());

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseAuthScreen(
      title: 'Sign up with email',
      subtitle: 'Enter your email and password',
      buttonText: 'Create Account',
      emailController: _signUpViewModel.emailController,
      passwordController: _signUpViewModel.passwordController,
      isEmailValid: _signUpViewModel.isEmailValid,
      isPasswordValid: _signUpViewModel.isPasswordValid,
      isLoading: _signUpViewModel.isLoading,
      haveForgotPassword: false.obs,
      onButtonPressed: () => _signUpViewModel.createUser(),
    );
  }
}
