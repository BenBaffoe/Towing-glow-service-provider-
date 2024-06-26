import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:service_providers_glow/Info/app_info.dart';
import 'package:service_providers_glow/UserScreens/signup.dart';
import 'package:service_providers_glow/UserScreens/splashscreen.dart';
import 'package:service_providers_glow/UserScreens/userhome.dart';
import 'package:service_providers_glow/UserScreens/userlogin.dart';
import 'package:service_providers_glow/tapPages/home_tab.dart';

Future<void> main() async {
  // await FirebaseMessaging.instance.setAutoInitEnabled(true);
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBt9LHHiLzPA-F1iUjaUlGWPEWpCe9mSq0",
          appId: "1:846686411265:android:ff18939adfc822b0aa7e00",
          messagingSenderId: "846686411265",
          projectId: "roadtoll-1"),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> main() async {
    await Permission.locationWhenInUse.isDenied.then((value) {
      if (value) {
        Permission.locationWhenInUse.request();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.light(
          useMaterial3: true,
        ),
        routes: {
          '/home': (context) => const HomeTab(),
          '/login': (context) => const UserLogin(),
        },
        home: const SplashScreen(
          child: SignUp(),
        ),
      ),
    );
  }
}
