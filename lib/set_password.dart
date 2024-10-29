import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'middleScreen.dart';

class PasswordSettingPage extends StatefulWidget {
  const PasswordSettingPage({required Key key}) : super(key: key);

  @override
  _PasswordSettingPageState createState() => _PasswordSettingPageState();
}

class _PasswordSettingPageState extends State<PasswordSettingPage> {
  final _formKey = GlobalKey<FormState>();
  final _storage = const FlutterSecureStorage();
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '비밀번호 설정',
          style: TextStyle(
            color: Color(0xFF9A2A2AFF),
            fontSize: 30,
            fontFamily: 'My', fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFD1D1FF),
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
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: '비밀번호',
                        labelStyle: TextStyle(
                          fontSize: 25,
                          fontFamily: 'My', fontWeight: FontWeight.bold,
                        ),
                        errorStyle: TextStyle(
                          fontSize: 25,
                          fontFamily: 'My', fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'My', fontWeight: FontWeight.bold,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 입력해주세요.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (value != null) {
                          _password = value;
                        }
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // 비밀번호 저장
                          await _storage.write(key: 'password', value: _password);
                          print('비밀번호: $_password');
                          // isFirstRun을 false로 설정
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('isFirstRun', false);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('비밀번호가 저장되었습니다.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text(
                                      '확인', style: TextStyle(
                                      fontSize: 23,
                                      fontFamily: 'My', fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.pushReplacementNamed(context, '/login', arguments: _password);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },

                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xFF9A2A2AFF),
                        ),
                      ),
                      child: const Text(
                        '비밀번호 저장',
                        style: TextStyle(
                          fontSize: 23,
                          fontFamily: 'My', fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
