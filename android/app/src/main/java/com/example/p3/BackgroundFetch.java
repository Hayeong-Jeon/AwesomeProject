// BackgroundFetch.java
package com.example.p3;

import android.annotation.TargetApi;
import android.app.Notification;
import android.app.Service;
import android.app.admin.DevicePolicyManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.util.Log;
import android.view.WindowManager;

import java.util.Arrays;
import androidx.core.app.NotificationCompat;

public class BackgroundFetch extends Service {

    private static final String CHANNEL_ID = "ForegroundServiceChannel";
    private SensorManager sensorManager;
    private Sensor stepSensor;
    int totalSteps = 0;  // 걸음 수를 저장하는 변수
    private int lastStepCount = 0;  // 이전 걸음 수를 저장하는 변수
    private SensorEventListener stepEventListener;
    private static final long TIMEOUT = 2000; // 감지되지 않은 시간 (밀리초)
    private DevicePolicyManager devicePolicyManager;
    private ComponentName componentName;
    private boolean isStepSensorRunning = false;
    private Handler handler = new Handler(Looper.getMainLooper());
    private boolean overlayVisible = false;
    private Runnable timeoutRunnable = () -> {
        // 타임아웃이 발생했을 때의 로직 (예: 오버레이 숨기기)
        Log.d("BackgroundService", "overlayVisible:"+overlayVisible);
        Log.d("BackgroundService", "오버레이 숨김22");
        hideOverlayIfNotUpdated();

        // 필요한 추가적인 로직이 있다면 여기에 작성
    };

    @TargetApi(Build.VERSION_CODES.KITKAT)
    @Override
    public void onCreate() {
        super.onCreate();
        Log.d("YourApp", "onCreate method is called");
        PackageManager packageManager = getPackageManager();
        boolean hasStepDetector = packageManager.hasSystemFeature(PackageManager.FEATURE_SENSOR_STEP_DETECTOR);
        boolean hasStepCounter = packageManager.hasSystemFeature(PackageManager.FEATURE_SENSOR_STEP_COUNTER);

        Log.d("StepSensor", "Step Detector supported: " + hasStepDetector);
        Log.d("StepSensor", "Step Counter supported: " + hasStepCounter);

        // 추가적인 초기화 코드가 필요한 경우 여기에 추가
        Notification notification = new NotificationCompat.Builder(this, "ForegroundServiceChannel")
                .setContentTitle("Your App")
                .setContentText("Your app is running in the background.")
                .setSmallIcon(R.drawable.ic_notification)
                .build();

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ECLAIR) {
            startForeground(1, notification);
        }

        sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.CUPCAKE) {
            stepSensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_DETECTOR); // TYPE_STEP_DETECTOR로 변경

            Log.d("BackgroundFetch", "Step sensor registered: " + (stepSensor != null));
        }
        if (stepSensor == null) {
            stopSelf();
            return;
        } else {
            // 센서 등록 코드
            stepEventListener = new SensorEventListener() {
                @Override
                public void onSensorChanged(SensorEvent event) {
                    Log.d("TotalSteps", "last Steps: " + lastStepCount);
                    // 걸음이 감지될 때 수행할 로직
                    Log.d("StepSensor", "Step sensor event received!");
                    Log.d("StepSensor", "onSensorChanged - Event values: " + Arrays.toString(event.values));
                    Log.d("StepSensor", "Step detected! Value: " + event.values[0]);
                    totalSteps++;  // 감지된 걸음 수 증가
                    Log.d("TotalSteps", "Total Steps: " + totalSteps);
                    Log.d("TotalSteps", "last Steps: " + lastStepCount);
                    // 이전 걸음 수와 현재 걸음 수를 비교하여 변경이 있을 경우에만 showOverlay 호출
                    overlayVisible = true;
                    lastStepCount = totalSteps;
                    isStepSensorRunning =true;
                    Log.d("BackgroundService", "오버레이 표시 중111");
                    Intent intent = new Intent(BackgroundFetch.this, ImageOverlayActivity.class);
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
                    startActivity(intent);

                    // 일정 시간동안 걸음이 감지되지 않으면 타임아웃이 발생하도록 타이머 재설정
                    handler.removeCallbacks(timeoutRunnable); // 이전 타임아웃 취소
                    handler.postDelayed(timeoutRunnable, TIMEOUT); // 새 타임아웃 설정
                }

                @Override
                public void onAccuracyChanged(Sensor sensor, int accuracy) {
                    // 정확도 변경에 대한 처리가 필요하면 추가
                }
            };

            sensorManager.registerListener(stepEventListener, stepSensor, SensorManager.SENSOR_DELAY_NORMAL);

        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        // 서비스가 종료될 때 수행할 로직이 있다면 여기에 추가
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.CUPCAKE) {
            sensorManager.unregisterListener(stepEventListener);
        }
        // 오버레이 뷰 제거
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    private void hideOverlayIfNotUpdated() {
        // 2초 뒤에 호출되며, 그동안 걸음이 감지되지 않으면 overlay를 숨김
        if (overlayVisible) {
            Log.d("BackgroundService", "오버레이 숨김111");
            hideOverlay();
            overlayVisible = false;
        }
    }

    @TargetApi(Build.VERSION_CODES.CUPCAKE)
    private void hideOverlay() {
        if (overlayVisible) {
            Log.d("BackgroundService", "오버레이 숨김00");

            // ImageOverlayActivity를 종료
            Intent intent = new Intent(BackgroundFetch.this, ImageOverlayActivity.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
            intent.setAction("STOP");
            startActivity(intent);

            // 포그라운드 서비스를 종료하지 않고 알림만 제거
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ECLAIR) {
                stopForeground(true);
            }


            overlayVisible = false;
        }
    }

    public void updateServiceStatus(boolean isRunning) {
        Intent intent;
        if (isRunning) {
            intent = new Intent(this, BackgroundFetch.class);
            intent.setAction("startBackgroundFetch");
            startService(intent);
        } else {
            intent = new Intent(this, BackgroundFetch.class);
            intent.setAction("stopBackgroundFetch");
            stopService(intent);
        }
    }
    // 추가적인 메서드나 기능이 필요한 경우 여기에 추가
}
