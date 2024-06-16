import 'package:flutter/material.dart';
import 'package:plantist_app_/Resources/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final InputBorder? borderStyle;
  final InputBorder? disabledBorderStyle;
  final bool isValid;
  final bool showValidationIcon;
  final int maxLine;
  final TextStyle hintStyle;

  const CustomTextField(
      {Key? key,
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
      this.showValidationIcon = true})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: widget.maxLine,
      controller: widget.controller,
      obscureText: _obscureText,
      style: const TextStyle(
        color: AppColors.textPrimaryColor,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: Colors.deepPurpleAccent,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        enabledBorder: widget.disabledBorderStyle,
        focusedBorder: widget.borderStyle,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        suffixIcon: widget.showValidationIcon && widget.isValid
            ? const Icon(
                Icons.check_circle,
                color: AppColors.textPrimaryColor,
                size: 24,
              )
            : widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: AppColors.textFieldHintcolor,
                      size: 24,
                    ),
                    onPressed: _toggleObscureText,
                  )
                : null,
      ),
    );
  }
}
