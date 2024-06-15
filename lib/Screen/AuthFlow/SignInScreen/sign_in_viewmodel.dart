import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantist_app_/Service/auth_service.dart';

class SignInViewModel extends GetxController {
  final AuthService _authService = AuthService();

  var user = Rx<User?>(null);

  final emailController = TextEditingController();
  final forgotPasswordEmailController = TextEditingController();
  final passwordController = TextEditingController();

  var isEmailValid = false.obs;
  var isPasswordValid = false.obs;
  var isLoading = false.obs;
  var isForgotPasswordLoading = false.obs;

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

  Future<void> signIn() async {
    isLoading.value = true;
    try {
      await _authService.signIn(
        email: emailController.text,
        password: passwordController.text,
      );
      Get.snackbar(
        'Success',
        'Signed in successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword({required String email}) async {
    isForgotPasswordLoading.value = true;
    try {
      await _authService.resetPassword(email: email);
      Get.snackbar('Success', 'Password reset email sent to $email');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isForgotPasswordLoading.value = false;
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
