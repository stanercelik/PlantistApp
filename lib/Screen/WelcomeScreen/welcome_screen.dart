import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantist_app_/Components/custom_wide_button.dart';
import 'package:plantist_app_/Screen/WelcomeScreen/welcome_screen_controller.dart';
import 'package:plantist_app_/Utils/screen_util.dart';
import 'package:plantist_app_/Resources/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final WelcomeController controller = Get.put(WelcomeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2), // Boşluk bırakmak için
                    Image.asset(
                      'assets/images/plantist_logo.png',
                      height: ScreenUtil.screenHeightPercentage(context, 0.4),
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Welcome back to',
                      style: TextStyle(
                          color: AppColors.textPrimaryColor,
                          fontSize: 42,
                          fontWeight: FontWeight.w200),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Plantist',
                      style: TextStyle(
                          color: AppColors.textPrimaryColor,
                          fontSize: 42,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Start your productive life now!',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomWideButton(
                      onPressed: controller.signIn,
                      text: "Sign in with email",
                      backgroundColor: AppColors.welcomeButtonBackgroundColor,
                      foregroundColor: AppColors.textPrimaryColor,
                      icon: Icons.email,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't you have an account?",
                          style: TextStyle(color: AppColors.textSecondaryColor),
                        ),
                        TextButton(
                          onPressed: controller.signUp,
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                                color: AppColors.textPrimaryColor,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(flex: 1), // Boşluk bırakmak için
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
