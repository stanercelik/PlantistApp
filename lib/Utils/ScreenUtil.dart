import 'package:flutter/material.dart';

class ScreenUtil {
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeightPercentage(BuildContext context, double percentage) {
    return screenHeight(context) * percentage;
  }

  static double screenWidthPercentage(BuildContext context, double percentage) {
    return screenWidth(context) * percentage;
  }
}
