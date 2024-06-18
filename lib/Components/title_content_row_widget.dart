import 'package:flutter/material.dart';
import 'package:plantist_app_/Resources/app_colors.dart';

class TitleContentRow extends StatelessWidget {
  final String title;
  final String content;
  final TextStyle titleStyle;
  final TextStyle contentStyle;

  const TitleContentRow({
    Key? key,
    required this.title,
    required this.content,
    this.contentStyle = const TextStyle(
        color: AppColors.textSecondaryColor,
        fontSize: 20,
        fontWeight: FontWeight.w400),
    this.titleStyle = const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryColor,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: titleStyle,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            content,
            style: contentStyle,
          ),
        ),
      ],
    );
  }
}
