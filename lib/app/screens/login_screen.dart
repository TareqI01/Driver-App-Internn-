import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intern/app/api/controller/network_caller.dart';
import 'package:flutter_intern/app/api/controller/network_response.dart';
import 'package:flutter_intern/app/api/controller/auth_utility.dart';
import 'package:flutter_intern/app/controller/text_design.dart';
import 'package:flutter_intern/app/screens/shift_planner_screen.dart';
import 'package:flutter_intern/app/widgets/snack_message.dart';
import 'package:get/get.dart';
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
                    onPressed: login,

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

  Future<void> login() async {
    if (!_key.currentState!.validate()) {
      return; // Return if validation fails
    }

    if (mounted) {
      setState(() {
        loginProgress = true;
      });
    }

    try {
      final NetworkResponse? response = await NetworkCaller().postRequest(
        Urls.loginUrl,
        body: {
          "username": emailTEcontroller.text.trim(),
          "password": passTEcontroller.text.trim(),
          "RequestFrom": "DriverApp",
        },
      );

      if (mounted) {
        setState(() {
          loginProgress = false;
        });
      }

      if (response!.isSuccess) {
        // Save login status
        await AuthUtility.saveLoginStatus(true);

        // Save authentication token if available in response
        if (response.jsonResponse != null &&
            response.jsonResponse['data'] != null &&
            response.jsonResponse['data']['token'] != null) {
          await AuthUtility.saveToken(response.jsonResponse['data']['token']);
          print("Saved authentication token");
        } else if (response.jsonResponse != null &&
            response.jsonResponse['token'] != null) {
          await AuthUtility.saveToken(response.jsonResponse['token']);
          print("Saved authentication token");
        }

        Get.offAll(() => ShiftPlannerScreen());
        SnackMessage(context, "Login Successful");
      } else {
        // Show error from API if available, otherwise generic message
        final errorMessage =
            response.errorMessage ?? "Login failed. Please try again.";
        SnackMessage(context, errorMessage, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loginProgress = false;
        });
      }
      SnackMessage(context, "An error occurred: ${e.toString()}", true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailTEcontroller.clear();
    passTEcontroller.clear();
  }
}
