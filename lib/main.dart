import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'set_password.dart';
import 'firstscreen.dart';
import 'eye_protection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'state_update.dart';
import 'package:pedometer/pedometer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login_page.dart';
import 'middleScreen.dart';


void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => MyApp(),
        '/first': (context) => FirstScreen(),
        '/setPassword': (context) => PasswordSettingPage(key: UniqueKey()),
        '/login': (context) => LoginPage(password: ModalRoute.of(context)!.settings.arguments as String?),
        '/middle': (context) => MiddleScreen(),
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final storage = FlutterSecureStorage();

  Future<String?> getPassword() async {
    return await storage.read(key: 'password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFB9B9FF),
                  Color(0xB73232FF),
                ]
            )
        ),
        child: AnimatedSplashScreen(
            splash: const Image(image: AssetImage('assets/images/don.png')), // 스플래쉬 스크린에 표시할 이미지
            splashIconSize: 200.0,
            splashTransition: SplashTransition.slideTransition,
            animationDuration: Duration(seconds: 6),
            duration: 2000,
            nextScreen: FirstScreen(), // 스플래쉬 스크린 이후에 표시할 화면
            backgroundColor: Colors.white
        ),
      ),
    );
  }
}
