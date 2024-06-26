import 'dart:async';

import 'package:flutter/material.dart';
import 'package:service_providers_glow/Assistants/assitant_method.dart';
import 'package:service_providers_glow/UserScreens/signup.dart';
import 'package:service_providers_glow/global/global.dart';
// import 'package:service_providers_glow/tapPages/home_tab.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      if (await firebaseAuth.currentUser != null) {
        firebaseAuth.currentUser != null
            ? AssistantMethods.readCurrentOnlineUserInfo()
            : null;
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const SignUp()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const SignUp()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(seconds: 4), () {
    //   Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(builder: (context) => widget.child!),
    //       (route) => true);
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage("assets/logo.jfif"),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Towing Glow",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
