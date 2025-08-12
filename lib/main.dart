import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern/app/screens/login_screen.dart';
import 'package:flutter_intern/app/api/controller/auth_utility.dart';
import 'package:get/get.dart';

import 'app/screens/shift_planner_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool isLoggedIn = await AuthUtility.isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? ShiftPlannerScreen() : LoginScreen(), // Redirect logic
    );
  }
}
