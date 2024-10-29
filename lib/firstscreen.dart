import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'eye_protection_screen.dart';
import 'middleScreen.dart';
import 'set_password.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> with WidgetsBindingObserver {
  final _storage = const FlutterSecureStorage();
  String? password;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPassword();
    }
  }

  void _checkPassword() async {
    password = await _storage.read(key: 'password');
    if (password == null || password?.isEmpty == true) {
      Navigator.pushNamedAndRemoveUntil(context, '/setPassword', (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  void _onPressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _checkPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB9B9FF),
              Color(0xB73232FF),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '안녕하세요 저는 육아도우미 스키치에요!!',
              style: TextStyle(
                  color: Color(0xB73232FF),
                  fontSize: 25,
                  fontFamily: 'My',fontWeight: FontWeight.bold
              ),
            ),
            ElevatedButton(
              onPressed: _onPressed,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0x9A2A2AFF)),
              ),
              child: Text('시작',
                style: TextStyle(
                    color: Color(0xFFB9B9FF),
                    fontSize: 30,
                    fontFamily: 'My',fontWeight: FontWeight.bold
                ),),
            ),
            SizedBox(height: 20),
            Image.asset('assets/images/Man.png'),
          ],
        ),
      ),
    );
  }
}