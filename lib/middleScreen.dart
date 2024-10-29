import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'eye_protection_screen.dart';
import 'pedometer_screen.dart';
import 'firstscreen.dart';
import 'set_password.dart';
import 'state_update.dart';

class MiddleScreen extends StatefulWidget {
  @override
  _MiddleScreenState createState() => _MiddleScreenState();
}

class _MiddleScreenState extends State<MiddleScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '스키치',
          style: TextStyle(
              color: Color(0xFF9A2A2AFF),
              fontFamily: 'My',
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFD1D1FF),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FirstScreen(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB9B9FF),
              Color(0xFFB73232FF),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EyeProtectionScreen(),
                        ),
                      );
                    },
                    style: _buttonStyle(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(IconData(0x1F31C, fontFamily: 'My'), size: 30,),
                        Text('눈 보호', style: TextStyle(fontFamily: 'My')),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PedometerScreen(),
                    ),
                  );
                },
                style: _buttonStyle(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(IconData(0x1F6B7, fontFamily: 'My'), size: 30,),
                    Text('걷기 감지', style: TextStyle(fontFamily: 'My')),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PasswordSettingPage(key: UniqueKey()),
                    ),
                  );
                },
                style: _buttonStyle(),
                child: const Text(
                  '비밀번호 설정',
                  style: TextStyle(
                    fontFamily: 'My', fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Color(0xB73232FF),
      elevation: 50.0,
      textStyle: const TextStyle(
        color: Color(0xFFB9B9FF),
        letterSpacing: 2.0,
        fontWeight: FontWeight.w900,
        fontSize: 25.0,
      ),
      padding: const EdgeInsets.all(20.30),
    );
  }
}