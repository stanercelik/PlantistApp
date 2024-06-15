import 'package:flutter/material.dart';
import 'package:plantist_app_/Utils/screen_util.dart';

class CustomWideButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool isLoading;
  final IconData? icon;

  const CustomWideButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.backgroundColor,
    required this.foregroundColor,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil.screenWidth(context),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 24),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          splashFactory: NoSplash.splashFactory, // Disable the ripple effect
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: isLoading ? 0 : 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) Icon(icon),
                  if (icon != null) const SizedBox(width: 0),
                  Text(text),
                ],
              ),
            ),
            if (isLoading)
              CircularProgressIndicator(
                color: foregroundColor,
              ),
          ],
        ),
      ),
    );
  }
}
