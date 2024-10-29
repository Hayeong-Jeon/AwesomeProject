import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'middleScreen.dart';
import 'set_password.dart';

class LoginPage extends StatefulWidget {
  final String? password;

  LoginPage({this.password});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "로그인",
          style: TextStyle(
              fontSize: 30,
              color: Color(0xFF9A2A2AFF),
              fontFamily: 'My',fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Color(0xFFD1D1FF),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  print('Stored password: ${widget.password}');
                  print('Entered password: $value');
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요';
                  }
                  // password가 Null일 수 있으므로 Null 체크를 추가
                  if (widget.password != null && value != widget.password) {
                    return '잘못된 비밀번호입니다';
                  }
                  return null;
                },
                style: TextStyle(
                  color: Color(0xFF9A2A2AFF),
                  fontSize: 25,
                  fontFamily: 'My', fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final _storage = FlutterSecureStorage();
                  String? storedPassword = await _storage.read(key: 'password');
                  print('Stored password: $storedPassword');

                  if (_passwordController.text == storedPassword || storedPassword == null) {
                    Navigator.pushNamedAndRemoveUntil(context, '/middle', (route) => false);
                  } else {
                    // 비밀번호가 일치하지 않으면 오류 메시지를 표시합니다.
                    print('잘못된 비밀번호입니다');
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0x9A2A2AFF)),
                ),
                child: Text(
                  '로그인',
                  style: TextStyle(
                    color: Color(0xFFB9B9FF),
                    fontSize: 25,
                    fontFamily: 'My', fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}