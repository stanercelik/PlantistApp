import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plantist_app_/Resources/AppColors';
import 'package:plantist_app_/Screen/SignInScreen/SignInScreen.dart';
import 'package:plantist_app_/Screen/SignUpScreen/SignUpScreen.dart';
import 'package:plantist_app_/Screen/WelcomeScreen/WelcomeScreen.dart';
import '../firebase_options.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        GetPage(name: '/', page: () => WelcomeScreen()),
        GetPage(name: '/signin', page: () => const SignInScreen()),
        GetPage(name: '/signup', page: () => const SignUpScreen()),
      ],
    );
  }
}
