import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantist_app_/Components/custom_text_field.dart';
import 'package:plantist_app_/Resources/app_colors.dart';
import 'package:plantist_app_/Components/custom_wide_button.dart';

class ForgotPasswordBottomSheet extends StatelessWidget {
  final TextEditingController emailController;
  final VoidCallback onSendPressed;
  final RxBool isLoading;
  final RxBool isEmailValid;

  const ForgotPasswordBottomSheet({
    super.key,
    required this.emailController,
    required this.onSendPressed,
    required this.isLoading,
    required this.isEmailValid,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
            () {
              return CustomWideButton(
                onPressed: isEmailValid.value && !isLoading.value
                    ? () {
                        onSendPressed();
                        FocusScope.of(context).unfocus();
                        Navigator.pop(context);
                      }
                    : null,
                text: 'Send',
                backgroundColor: isEmailValid.value
                    ? AppColors.enabledButtonColor
                    : AppColors.disabledButtonColor,
                foregroundColor: Colors.white,
                isLoading: isLoading.value,
              );
            },
          ),
        ],
      ),
    );
  }
}
