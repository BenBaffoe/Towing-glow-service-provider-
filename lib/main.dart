import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:service_providers_glow/Info/app_info.dart';
import 'package:service_providers_glow/ServiceProviderScreen/signup.dart';
import 'package:service_providers_glow/ServiceProviderScreen/splashscreen.dart';
import 'package:service_providers_glow/ServiceProviderScreen/userhome.dart';
import 'package:service_providers_glow/ServiceProviderScreen/userlogin.dart';
import 'package:service_providers_glow/local_notifications.dart';
import 'package:service_providers_glow/tapPages/home_tab.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalNotifications.init();

  // Initialize Firebase and await its completion
  await Firebase.initializeApp();

  // Enable auto-initialization for Firebase Messaging
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  // WidgetsFlutterBinding.ensureInitialized();

  // if (Platform.isAndroid) {
  //   Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         apiKey: "AIzaSyBt9LHHiLzPA-F1iUjaUlGWPEWpCe9mSq0",
  //         appId: "1:846686411265:android:8e9c362d72e42bc3aa7e00",
  //         messagingSenderId: "846686411265",
  //         projectId: "roadtoll-1"),
  //   );
  // }

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
