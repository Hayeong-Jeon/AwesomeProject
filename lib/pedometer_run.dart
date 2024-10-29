//pedometer_run.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedometer/pedometer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';


bool _isWalking = false;  // 걷는 상태를 저장하는 변수를 추가



class StepCounter extends StatefulWidget {
  const StepCounter({Key? key}) : super(key: key);
  @override
  StepCounterState createState() => StepCounterState();
}

class StepCounterState extends State<StepCounter> {
  static const int THRESHOLD = 10;
  MethodChannel? _methodChannel;
  Stream<StepCount>? _stepCountStream;
  StreamSubscription<StepCount>? _stepCountSubscription;
  int _stepCount = 0;
  int _previousStepCount = -1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initPedometer();
    _requestPermissions();
    _startTimer();
    _methodChannel = MethodChannel('com.example.p3/step');
    startPedometer();  // startPedometer 함수를 호출합니다.
  }


  void _initPedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream!.listen((StepCount event) {
      if (mounted) {
        if (_previousStepCount == -1) {
          _previousStepCount = event.steps;
        }
        setState(() {
          _stepCount = event.steps;
          if (_stepCount != _previousStepCount) {
            _isWalking = true;
          } else {
            _isWalking = false;
          }
          _previousStepCount = _stepCount;
        });
        // 추가 디버깅 로그
        print('Step count: $_stepCount');
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        if ((_stepCount - _previousStepCount).abs() > 1) {
          _isWalking = true;
          _previousStepCount = _stepCount;
        } else {
          _isWalking = false;
        }
      });
    });
  }


  Future<void> _requestPermissions() async {
    await _requestLocationPermission();
    await _requestActivityRecognitionPermission();
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        print('위치정보 권한 거부');
      }
    }
    print('위치정보 권한 허용');
  }

  Future<void> _requestActivityRecognitionPermission() async {
    if (await Permission.activityRecognition.request().isGranted) {
      print('신체활동 권한 허용');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('권한 요청'),
          content: const Text('신체활동을 감지하기 위해서는 권한이 필요합니다.'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('다시 요청'),
              onPressed: () {
                openAppSettings();
              },
            ),
            ElevatedButton(
              child: const Text('취소'),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      );
    }
  }

  void startPedometer() {
    print('startPedometer called'); // 디버그 출력 추가

    // _stepCountStream를 구독
    _stepCountSubscription = _stepCountStream?.listen((StepCount event) {
      // 이하 코드는 그대로 유지됩니다.
      if ((_stepCount - _previousStepCount).abs() > 3) {
        _methodChannel?.invokeMethod('showOverlay');
      }
    });

    // 추가: 걷기 감지 시작 버튼을 누를 때 호출되도록
    _methodChannel?.invokeMethod('startBackgroundFetch');
  }
  void stopPedometer() {
    _stepCountSubscription?.cancel();
    _stepCountSubscription = null;

    _methodChannel?.invokeMethod('stopBackgroundFetch');
  }

  @override
  void dispose() {
    stopPedometer();
    _timer?.cancel();  // 타이머 취소
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent[100], // 백그라운드 색상을 greenAccent로 설정
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<StepCount>(
              stream: _stepCountStream,
              builder: (context, snapshot) {
                if (_isWalking) {
                  print('걸음');
                  print(_stepCount);
                  return Text('걸음이 인식되었습니다.');
                } else {
                  print('가만');
                  print(_previousStepCount);
                  return Text('걸음이 감지되지 않았습니다.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}