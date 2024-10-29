import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login_page.dart';


class SetPasswordPage extends StatefulWidget {
  @override
  _SetPasswordPageState createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("비밀번호 설정")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '비밀번호를 입력해주세요';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                final password = _passwordController.text;
                if (_formKey.currentState?.validate() ?? false) {
                  await _storage.write(key: 'password', value: _passwordController.text);
                  Navigator.pushReplacementNamed(context, '/login', arguments: password);
                }
              },
              child: Text('비밀번호 설정'),
            ),
          ],
        ),
      ),
    );
  }
}
