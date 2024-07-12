import 'package:deadlinemanager/models/utils/colors.dart';
import 'package:deadlinemanager/models/utils/images.dart';
import 'package:deadlinemanager/views/loginScreen.dart';
import 'package:deadlinemanager/views/profile.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(logoImage),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: Container(
                    height: 65,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: UiColors.themeColor,
                        border: Border.all(color: UiColors.themeColor),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 24,
                          color: UiColors.iconColor,
                          fontWeight: FontWeight.w700),
                    ))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfile()));
                },
                child: Container(
                    height: 65,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: UiColors.iconColor,
                        border: Border.all(color: UiColors.themeColor),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      "Get Started",
                      style: TextStyle(
                          fontSize: 24,
                          color: UiColors.themeColor,
                          fontWeight: FontWeight.w700),
                    ))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
