import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern/app/api/controller/network_caller.dart';
import 'package:flutter_intern/app/api/controller/network_response.dart';
import 'package:flutter_intern/app/controller/text_design.dart';
import 'package:flutter_intern/app/screens/shift_planner_screen.dart';
import 'package:flutter_intern/app/widgets/snack_message.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/controller/urls/urls.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailTEcontroller = TextEditingController();
  final TextEditingController passTEcontroller = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool rememberMe = false;
  bool loginProgress = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.black12,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _key,
          child: Column(
            ///crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height / 4),

              Text("Sign In", style: TextDesign.bodyMediumTextStyle(25)),
              Text(
                "please sign in to continue",
                style: TextDesign.bodySmallTextStyle(15),
              ),
              SizedBox(height: 50),
              TextFormField(
                controller: emailTEcontroller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Email",
                  hintStyle: TextDesign.hintTextStyle(14),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return "Enter Your Email";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                obscureText: true,
                controller: passTEcontroller,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextDesign.hintTextStyle(14),
                  suffixIcon: Icon(Icons.visibility_off, color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return "Enter Your Password";
                  }
                  return null;
                },
              ),

              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value ?? false;
                        });
                      },
                    ),
                    const Text("Remember Me", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              SizedBox(
                width: width / 2,
                height: 50,
                child: Visibility(
                  visible: loginProgress == false,
                  replacement: Center(child: CircularProgressIndicator()),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      LoginScreen();
                      Get.to(ShiftPlannerScreen());
                    },
                    child: Text(
                      "Sign In",
                      style: TextDesign.whiteTextStyle(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> LoginScreen() async {
    loginProgress = true;
    if (mounted) {
      setState(() {});
    }
    if (_key.currentState!.validate()) {
      final NetworkResponse? response = await NetworkCaller().postRequest(
        Urls.loginUrl,
        body: {"username": emailTEcontroller, "password": passTEcontroller},
      );
      loginProgress = false;
      if (mounted) {
        setState(() {});
      }

      if (response!.isSuccess) {
        final token=response.responseData["data"]
        await _saveLoginState(emailTEcontroller.text, passTEcontroller.text);
        emailTEcontroller.clear();
        passTEcontroller.clear();
      }
      if (mounted) {
        SnackMessage(context, "Login Successfully");
      } else {
        SnackMessage(context, "Login Failed", true);
      }
    }
  }

  Future<void> _saveLoginState(String email, String password,String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setString("token",token);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailTEcontroller.clear();
    passTEcontroller.clear();
  }
}
