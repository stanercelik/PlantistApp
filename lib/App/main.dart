import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plantist_app_/Resources/app_colors.dart';
import 'package:plantist_app_/Routes/routes.dart';
import 'package:plantist_app_/Screen/AuthFlow/SignInFlow/SignInScreen/sign_in_screen.dart';
import 'package:plantist_app_/Screen/AuthFlow/SignUpScreen/sign_up_screen.dart';
import 'package:plantist_app_/Screen/AuthFlow/BaseAuth/user_auth_controller.dart';
import 'package:plantist_app_/Screen/ToDoFlow/ToDoListScreen/todo_screen.dart';
import 'package:plantist_app_/Screen/WelcomeScreen/welcome_screen.dart';
import 'package:get/get.dart';
import 'package:plantist_app_/Utils/notification_helper.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
  await NotificationHelper.initialize();
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
