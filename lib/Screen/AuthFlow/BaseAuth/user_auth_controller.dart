import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantist_app_/Screen/ToDoFlow/ToDoListScreen/todo_screen.dart';
import 'package:plantist_app_/Screen/WelcomeScreen/welcome_screen.dart';

class UserAuthController extends GetxController {
  static UserAuthController instance = Get.find();
  late Rx<User?> firebaseUser;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => WelcomeScreen());
    } else {
      Get.offAll(() => ToDoScreen());
    }
  }

  void signOut() async {
    await auth.signOut();
  }
}
