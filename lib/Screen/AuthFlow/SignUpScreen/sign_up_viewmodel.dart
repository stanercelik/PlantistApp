import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantist_app_/Service/auth_service.dart';

class SignUpViewModel extends GetxController {
  final AuthService _authService = AuthService();

  var user = Rx<User?>(null);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isEmailValid = false.obs;
  var isPasswordValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(validateEmail);
    passwordController.addListener(validatePassword);

    user.bindStream(_authService.authStateChanges);
  }

  void validateEmail() {
    isEmailValid.value = GetUtils.isEmail(emailController.text);
  }

  void validatePassword() {
    isPasswordValid.value = passwordController.text.length >= 6;
  }

  Future<void> createUser() async {
    try {
      await _authService.createUser(
        email: emailController.text,
        password: passwordController.text,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> signIn() async {
    try {
      await _authService.signIn(
        email: emailController.text,
        password: passwordController.text,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
