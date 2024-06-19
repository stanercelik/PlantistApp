import 'package:get/get.dart';

class WelcomeViewModel extends GetxController {
  void signIn() {
    Get.toNamed('/signin');
  }

  void signUp() {
    Get.toNamed('/signup');
  }
}
