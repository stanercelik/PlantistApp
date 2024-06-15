import 'package:flutter/material.dart';
import 'package:plantist_app_/Utils/ScreenUtil.dart';

class CustomWideButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData? icon;

  const CustomWideButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.backgroundColor,
    required this.foregroundColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil.screenWidth(context),
      child: icon != null
          ? ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(text),
              style: ElevatedButton.styleFrom(
                foregroundColor: foregroundColor,
                backgroundColor: backgroundColor,
                padding: const EdgeInsets.symmetric(vertical: 20),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                foregroundColor: foregroundColor,
                backgroundColor: backgroundColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
              ),
              child: Text(text),
            ),
    );
  }
}
