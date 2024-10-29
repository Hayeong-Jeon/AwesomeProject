//pedometer_screen.dart
import 'package:flutter/material.dart';
import 'pedometer_run.dart';
import 'middleScreen.dart';
import 'state_update.dart';  // ButtonStateUpdate 클래스가 정의된 파일을 import합니다.

class PedometerScreen extends StatefulWidget {
  @override
  _PedometerScreenState createState() => _PedometerScreenState();
}

class _PedometerScreenState extends State<PedometerScreen> {
  bool _isRunning = false;
  final _stepCounterKey = GlobalKey<StepCounterState>();
  ButtonStateUpdate buttonStateUpdate = ButtonStateUpdate();

  Future<void> walkstartService() async {
    print('걷기 감지 버튼 눌림: ${buttonStateUpdate.isRunning}');
    setState(() {
      // _isRunning = !_isRunning;
      buttonStateUpdate.toggleState();
      if (buttonStateUpdate.isRunning) {
        _stepCounterKey.currentState?.startPedometer();
        BackgroundFetch().startBackgroundFetch();
      } else {
        _stepCounterKey.currentState?.stopPedometer();
        BackgroundFetch().stopBackgroundFetch();
      }
      BackgroundFetch()
          .updateServiceStatus(buttonStateUpdate.isRunning); // 상태를 백그라운드 서비스에 전달
    });
    print('걷기 감지 상태 업데이트됨: ${buttonStateUpdate.isRunning}');
  }


  // Handle back button press
  Future<bool> _onBackPressed() async {
    if (_isRunning) {
      // If the functionality is running, stop it and return false to prevent back navigation
      walkstartService();
      return false;
    }
    // Otherwise, allow back navigation
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed, // Register the callback for back button press
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '걷기감지',
            style: TextStyle(
                fontSize: 25,
                color: Color(0xFF9A2A2AFF),
                fontFamily: 'My',
                fontWeight: FontWeight.bold),
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
                Color(0xB73232FF),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/walk.png',
                width: 300,
                height: 300,
              ),
              SizedBox(height: 16.0),
              Text(
                '걷는 중 휴대폰 사용을 자제시키기 위한 화면보호기 기능',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: walkstartService,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0x9A2A2AFF)),
                  ),
                  child: Text(
                    buttonStateUpdate.buttonText, // 동적으로 버튼 텍스트 설정
                    style: const TextStyle(
                        fontSize: 25,
                        fontFamily: 'My',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (_isRunning)
                Expanded(child: StepCounter(key: _stepCounterKey)),
            ],
          ),
        ),
      ),
    );
  }
}