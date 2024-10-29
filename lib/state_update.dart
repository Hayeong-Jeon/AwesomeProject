import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// state_update.dart

// 버튼 상태 업데이트 전용 클래스
// ButtonStateUpdate 클래스
class ButtonStateUpdate {
  static final ButtonStateUpdate _singleton = ButtonStateUpdate._internal();

  String get buttonText => _isRunning ? '중지' : '시작';

  factory ButtonStateUpdate() {
    return _singleton;
  }

  ButtonStateUpdate._internal();
  bool _isRunning = false;

  bool get isRunning => _isRunning;

  Future<void> toggleState() async {

    print('상태 전환: $_isRunning');
    _isRunning = !_isRunning;

// BackgroundFetch 클래스의 인스턴스 생성
    BackgroundFetch backgroundFetch = BackgroundFetch();

// 걷기 감지 상태를 백그라운드 서비스에 전달
    print('Calling updateServiceStatus with isRunning: $_isRunning');
    backgroundFetch.updateServiceStatus(_isRunning);



    }
  // 추가: 상태를 백그라운드 서비스에 전달하는 메서드
  Future<void> updateServiceStatus(bool isRunning) async {
    print('Calling updateServiceStatus with isRunning: $isRunning');
    BackgroundFetch backgroundFetch = BackgroundFetch();
    await backgroundFetch.updateServiceStatus(isRunning);
  }


}

class BackgroundFetch {
  MethodChannel _channel =
  MethodChannel('com.example.p3/step');

  Future<void> updateServiceStatus(bool isRunning) async {
    print('서비스 상태 업데이트: $isRunning');
    try {
      // 여기서 _isRunning 값이 반영되도록 수정
      await _channel
          .invokeMethod('updateServiceStatus', {'isRunning': isRunning});
    } on PlatformException catch (e) {
      print('서비스 상태 업데이트 오류: ${e.message}');
    }
  }

  Future<void> startBackgroundFetch() async {
    print('백그라운드 페치 시작');
    try {
      await _channel.invokeMethod('startBackgroundFetch');
    } on PlatformException catch (e) {
      print('Error starting background fetch: ${e.message}');
    }
  }

  Future<void> stopBackgroundFetch() async {
    print('백그라운드 페치 중지');
    try {
      await _channel.invokeMethod('stopBackgroundFetch');
    } on PlatformException catch (e) {
      print('Error stopping background fetch: ${e.message}');
    }
  }
}
// 서비스 시작 및 중지 전용 클래스
class ServiceControl {
  static final ServiceControl _singleton = ServiceControl._internal();

  factory ServiceControl() {
    return _singleton;
  }

  ServiceControl._internal();
  static const platform = MethodChannel("com.example.p3/brightness");

  bool _isRunning = false;
  bool get isRunning => _isRunning;


  Future<void> checkServiceStatus() async {
    _isRunning = await platform.invokeMethod('isServiceRunning'); // _isRunning 상태를 업데이트합니다.
  }

  Future<void> toggleService() async {
    bool isRunning = await platform.invokeMethod('isServiceRunning');
    if (isRunning) {
      await platform.invokeMethod('stopService');
    } else {
      await platform.invokeMethod('startService');
    }
    _isRunning = await platform.invokeMethod('isServiceRunning'); // 이 부분 추가
  }
}