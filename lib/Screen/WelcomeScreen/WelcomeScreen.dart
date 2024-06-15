import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantist_app_/Components/CustomWideButton.dart';
import 'package:plantist_app_/Screen/WelcomeScreen/WelcomeScreenController.dart';
import 'package:plantist_app_/Utils/ScreenUtil.dart';
import 'package:plantist_app_/Resources/AppColors';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final WelcomeController controller = Get.put(WelcomeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 4),
              Image.asset(
                'assets/images/plantist_logo.png',
                height: ScreenUtil.screenHeightPercentage(context, 0.4),
                fit: BoxFit.contain,
              ),
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
              const Spacer(flex: 1),
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
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
