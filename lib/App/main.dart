import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plantist_app_/Routes/routes.dart';
import 'package:plantist_app_/Screen/AuthFlow/SignInFlow/SignInScreen/sign_in_view.dart';
import 'package:plantist_app_/Screen/AuthFlow/SignUpScreen/sign_up_view.dart';
import 'package:plantist_app_/Screen/AuthFlow/BaseAuth/user_auth_viewmodel.dart';
import 'package:plantist_app_/Screen/ToDoFlow/ToDoDetailScreen/todo_detail_view.dart';
import 'package:plantist_app_/Screen/ToDoFlow/ToDoListScreen/todo_list_view.dart';
import 'package:plantist_app_/Screen/WelcomeScreen/welcome_view.dart';
import 'package:get/get.dart';
import 'package:plantist_app_/Utils/notification_helper.dart';
import 'package:plantist_app_/Utils/permission_helper.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
  await NotificationHelper.initialize();
  await PermissionHelper.requestPermissions();
  Get.put(UserAuthViewModel());
  runApp(const PlantistApp());
}

class PlantistApp extends StatelessWidget {
  const PlantistApp({super.key});

  @override
  Widget build(BuildContext context) {
    final UserAuthViewModel userAuthController = Get.put(UserAuthViewModel());

    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'SFProRounded'),
          bodyMedium: TextStyle(fontFamily: 'SFProRounded'),
          displayLarge: TextStyle(fontFamily: 'SFProRounded'),
          displayMedium: TextStyle(fontFamily: 'SFProRounded'),
          displaySmall: TextStyle(fontFamily: 'SFProRounded'),
          headlineMedium: TextStyle(fontFamily: 'SFProRounded'),
          headlineSmall: TextStyle(fontFamily: 'SFProRounded'),
          titleLarge: TextStyle(fontFamily: 'SFProRounded'),
          titleMedium: TextStyle(fontFamily: 'SFProRounded'),
          titleSmall: TextStyle(fontFamily: 'SFProRounded'),
          bodySmall: TextStyle(fontFamily: 'SFProRounded'),
          labelLarge: TextStyle(fontFamily: 'SFProRounded'),
          labelSmall: TextStyle(fontFamily: 'SFProRounded'),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Obx(() {
        if (userAuthController.firebaseUser.value == null) {
          return WelcomeScreen();
        } else {
          return ToDoListScreen();
        }
      }),
      getPages: [
        GetPage(name: Routes.welcomeScreen, page: () => WelcomeScreen()),
        GetPage(name: Routes.signInScreen, page: () => SignInScreen()),
        GetPage(name: Routes.signUpScreen, page: () => SignUpScreen()),
        GetPage(name: Routes.toDoScreen, page: () => ToDoListScreen()),
        GetPage(name: Routes.toDoDetailScreen, page: () => ToDoDetailScreen()),
      ],
    );
  }
}
