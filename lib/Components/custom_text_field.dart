import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantist_app_/Resources/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final InputBorder? borderStyle;
  final InputBorder? disabledBorderStyle;
  final bool isValid;
  final bool showValidationIcon;
  final int maxLine;
  final IconButton? suffixIcon;
  final Function? onSubmitted;
  final TextStyle hintStyle;
  final RxBool obscureTextRx;

  CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.isValid = false,
    this.borderStyle = const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.textFieldUnderlineColor)),
    this.disabledBorderStyle = const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.textFieldUnderlineColor)),
    this.maxLine = 1,
    this.hintStyle = const TextStyle(
      color: AppColors.textFieldHintcolor,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
    this.showValidationIcon = true,
    this.suffixIcon,
    this.onSubmitted,
  })  : obscureTextRx = obscureText.obs,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextField(
        maxLines: maxLine,
        controller: controller,
        obscureText: obscureTextRx.value,
        style: const TextStyle(
          color: AppColors.textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        cursorColor: Colors.deepPurpleAccent,
        keyboardType: keyboardType,
        onSubmitted: (value) => onSubmitted,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: hintStyle,
            enabledBorder: disabledBorderStyle,
            focusedBorder: borderStyle,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            suffixIcon: suffixIcon ??
                (showValidationIcon && isValid
                    ? const Icon(
                        Icons.check_circle,
                        color: AppColors.textPrimaryColor,
                        size: 24,
                      )
                    : obscureText
                        ? IconButton(
                            icon: Icon(
                              obscureTextRx.value
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              color: AppColors.textFieldHintcolor,
                              size: 24,
                            ),
                            onPressed: () {
                              obscureTextRx.value = !obscureTextRx.value;
                            },
                          )
                        : null)),
      ),
    );
  }
}
