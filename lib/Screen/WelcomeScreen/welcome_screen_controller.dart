import 'package:get/get.dart';
import 'package:plantist_app_/Screen/WelcomeScreen/welcome_screen_VM.dart';

class WelcomeController extends GetxController {
  final WelcomeScreenViewModel viewModel = WelcomeScreenViewModel();

  // Ana sayfaya yönlendirme
  void signIn() {
    Get.toNamed('/signin');
  }

  // Kayıt sayfasına yönlendirme
  void signUp() {
    Get.toNamed('/signup');
  }
}
