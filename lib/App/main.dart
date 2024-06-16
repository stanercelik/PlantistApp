import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plantist_app_/Resources/app_colors.dart';
import 'package:plantist_app_/Routes/routes.dart';
import 'package:plantist_app_/Screen/AuthFlow/SignInFlow/SignInScreen/sign_in_screen.dart';
import 'package:plantist_app_/Screen/AuthFlow/SignUpScreen/sign_up_screen.dart';
import 'package:plantist_app_/Screen/AuthFlow/BaseAuth/user_auth_controller.dart';
import 'package:plantist_app_/Screen/ToDoFlow/ToDoListScreen/todo_screen.dart';
import 'package:plantist_app_/Screen/WelcomeScreen/welcome_screen.dart';
import '../Database/firebase_options.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(UserAuthController());
  runApp(const PlantistApp());
}

class PlantistApp extends StatelessWidget {
  const PlantistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: WelcomeScreen(),
      ),
      getPages: [
        GetPage(name: Routes.welcomeScreen, page: () => WelcomeScreen()),
        GetPage(name: Routes.signInScreen, page: () => SignInScreen()),
        GetPage(name: Routes.signUpScreen, page: () => SignUpScreen()),
        GetPage(name: Routes.toDoScreen, page: () => ToDoScreen()),
      ],
    );
  }
}
