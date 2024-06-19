import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantist_app_/Screen/ToDoFlow/ToDoListScreen/todo_list_view.dart';
import 'package:plantist_app_/Screen/WelcomeScreen/welcome_view.dart';

class UserAuthViewModel extends GetxController {
  static UserAuthViewModel instance = Get.find();
  Rx<User?> firebaseUser = Rx<User?>(null);
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
      Get.offAll(() => ToDoListScreen());
    }
  }

  void signOut() async {
    await auth.signOut();
  }
}
