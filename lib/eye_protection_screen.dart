import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'main.dart';
import 'firstscreen.dart';
import 'state_update.dart';  // StateUpdate 클래스가 정의된 파일을 import합니다.
import 'middleScreen.dart';
//eye_protection_screen.dart
class EyeProtectionScreen extends StatefulWidget {
  @override
  _EyeProtectionScreenState createState() => _EyeProtectionScreenState();
}

class _EyeProtectionScreenState extends State<EyeProtectionScreen> with WidgetsBindingObserver {
  ServiceControl serviceControl = ServiceControl();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initServiceStatus();
  }

  Future<void> initServiceStatus() async {
    await serviceControl.checkServiceStatus();
    setState(() {});  // 상태 변경 후 화면을 갱신합니다.
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // 앱이 활성 상태로 돌아올 때마다 서비스의 상태를 체크합니다.
      await serviceControl.checkServiceStatus();
      setState(() {});  // 상태 변경 후 화면을 갱신합니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '눈 보호 설정',
          style: TextStyle(
            fontSize: 30,
            color: Color(0xFF9A2A2AFF),
            fontFamily: 'My',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFD1D1FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MiddleScreen(),
              ),
            );
          },
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/dark.png',
              width: 300,
              height: 300,
            ),
            SizedBox(height: 16.0),
            Text(
              '어두운 곳에서는 핸드폰을 사용하지 못하게 하는 기능입니다.',
              style: const TextStyle(
                fontFamily: 'My',
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 32.0),  // '시작' 버튼 위로 더 큰 간격을 주기 위해 SizedBox의 height를 조정합니다.
            ElevatedButton(
              onPressed: () async {
                await serviceControl.toggleService();
                setState(() {});
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF9A2A2AFF)),
              ),
              child: Text(
                serviceControl.isRunning ? '중지' : '시작',
                style: const TextStyle(
                  fontSize: 25,
                  fontFamily: 'My',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              serviceControl.isRunning ? '서비스 실행 중' : '서비스 중지',
              style: const TextStyle(
                fontFamily: 'My',
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
