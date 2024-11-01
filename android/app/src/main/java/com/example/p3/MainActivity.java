package com.example.p3;
//MainActivity.java
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.app.ActivityManager;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.admin.DevicePolicyManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String BRIGHTNESS_CHANNEL = "com.example.p3/brightness";
    private static final String STEP_CHANNEL = "com.example.p3/step";
    private static final String CHANNEL_ID = "ForegroundServiceChannel";
    private static final int DRAW_OVER_OTHER_APP_PERMISSION_REQUEST_CODE = 1234;
    private static final int REQUEST_CODE = 1010; // Request code for Device Admin permission

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel serviceChannel = new NotificationChannel(
                    CHANNEL_ID,
                    "Foreground Service Channel",
                    NotificationManager.IMPORTANCE_DEFAULT
            );

            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(serviceChannel);
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
            Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                    Uri.parse("package:" + getPackageName()));
            startActivityForResult(intent, DRAW_OVER_OTHER_APP_PERMISSION_REQUEST_CODE);
        }

        // Check if we have device admin permission
        DevicePolicyManager devicePolicyManager = (DevicePolicyManager) getSystemService(Context.DEVICE_POLICY_SERVICE);
        ComponentName componentName = new ComponentName(this, AdminReceiver.class);
        if (!devicePolicyManager.isAdminActive(componentName)) {
            // Request device admin permission
            Intent intent = new Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN);
            intent.putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, componentName);
            startActivityForResult(intent, REQUEST_CODE);
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), BRIGHTNESS_CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("startService")) {
                                Intent intent = new Intent(MainActivity.this, BackgroundService.class);
                                startService(intent);
                                result.success(null);
                            } else if (call.method.equals("stopService")) {
                                Intent intent = new Intent(MainActivity.this, BackgroundService.class);
                                stopService(intent);
                                result.success(null);
                            } else if (call.method.equals("isServiceRunning")) {
                                boolean isRunning = isMyServiceRunning(BackgroundService.class);
                                result.success(isRunning);
                            } else {
                                result.notImplemented();
                            }
                        }
                );

        // 걸음 감지 채널
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), STEP_CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("startBackgroundFetch")) {
                                Intent intent = new Intent(MainActivity.this, BackgroundFetch.class);
                                intent.setAction("startBackgroundFetch");
                                startService(intent);
                                result.success(null);
                            } else if (call.method.equals("stopBackgroundFetch")) {
                                Intent intent = new Intent(MainActivity.this, BackgroundFetch.class);
                                intent.setAction("stopBackgroundFetch");
                                stopService(intent);
                                result.success(null);
                            } else if (call.method.equals("updateServiceStatus")) {
                                boolean isRunning = updateServiceStatus(BackgroundFetch.class);
                                result.success(isRunning);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    public void showOverlay() {
        Intent intent = new Intent(MainActivity.this, ScreenProtectorActivity.class);
        startActivity(intent);
    }
    private boolean isMyServiceRunning(Class<?> serviceClass) {
        ActivityManager manager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
            if (serviceClass.getName().equals(service.service.getClassName())) {
                return true;
            }
        }
        return false;
    }

    private boolean updateServiceStatus(Class<?> serviceClass) {
        ActivityManager manager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
            if (serviceClass.getName().equals(service.service.getClassName())) {
                return true; // 서비스가 실행 중
            }
        }
        return false; // 서비스가 실행 중이지 않음
    }
}

