import 'package:get/get.dart';
import 'package:plantist_app_/Screen/WelcomeScreen/WelcomeScreenVM.dart';

class WelcomeController extends GetxController {
  final WelcomeScreenViewModel viewModel = WelcomeScreenViewModel();

  void signIn() {
    // Giriş işlemleri burada yapılabilir
    Get.toNamed('/signin'); // Ana sayfaya yönlendirme
  }

  void signUp() {
    // Kayıt işlemleri burada yapılabilir
    Get.toNamed('/signup'); // Kayıt sayfasına yönlendirme
  }
}
