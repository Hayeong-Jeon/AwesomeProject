// BackgroundService.java
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

import androidx.core.app.NotificationCompat;

import java.util.Arrays;

public class BackgroundService extends Service {
    private static final String CHANNEL_ID = "ForegroundServiceChannel";
    private SensorManager sensorManager;
    private Sensor lightSensor;
    private Sensor stepSensor;
    private SensorEventListener lightEventListener;
    private SensorEventListener stepEventListener;
    private DevicePolicyManager devicePolicyManager;
    private ComponentName componentName;
    private static final int THRESHOLD = 40; // Set your threshold value

    private boolean isDark = false; // Add this line
    private boolean isStepSensorRunning = false;

    private Handler handler = new Handler(Looper.getMainLooper());
    private Runnable runnable = new Runnable() {
        @Override
        public void run() {
            if (isDark) { // Check if it's still dark
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.FROYO) {
                    if (devicePolicyManager.isAdminActive(componentName)) {
                        devicePolicyManager.lockNow();
                    }
                }
            }
        }
    };
    @TargetApi(Build.VERSION_CODES.KITKAT)
    @Override
    public void onCreate() {
        super.onCreate();

        PackageManager packageManager = getPackageManager();
        boolean hasStepDetector = packageManager.hasSystemFeature(PackageManager.FEATURE_SENSOR_STEP_DETECTOR);
        boolean hasStepCounter = packageManager.hasSystemFeature(PackageManager.FEATURE_SENSOR_STEP_COUNTER);

        Log.d("StepSensor", "Step Detector supported: " + hasStepDetector);
        Log.d("StepSensor", "Step Counter supported: " + hasStepCounter);

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
            lightSensor = sensorManager.getDefaultSensor(Sensor.TYPE_LIGHT);
            stepSensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_DETECTOR); // Change to TYPE_STEP_DETECTOR

            Log.d("BackgroundService", "Light sensor registered: " + (lightSensor != null));
            Log.d("BackgroundService", "Step sensor registered: " + (stepSensor != null));
        }
        if (lightSensor != null) {
            sensorManager.registerListener(lightEventListener, lightSensor, SensorManager.SENSOR_DELAY_NORMAL);
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.FROYO) {
            devicePolicyManager = (DevicePolicyManager)getSystemService(Context.DEVICE_POLICY_SERVICE);
        }
        componentName = new ComponentName(this, AdminReceiver.class);

        if (lightSensor == null) {
            // Device doesn't support light sensor
            stopSelf();
            return;
        }
            lightEventListener = new SensorEventListener() {
                @Override
                public void onSensorChanged(SensorEvent event) {
                    Log.d("LightSensor", "Sensor value: " + event.values[0]);  // Log the sensor value

                    if (event.values[0] < THRESHOLD) { // Check light sensor value
                        // If light sensor value is less than THRESHOLD, start the timer
                        isDark = true; // Add this line
                        handler.postDelayed(runnable, 3000);  // 3 seconds delay
                    } else {
                        // If light sensor value is not less than THRESHOLD, cancel the timer
                        isDark = false; // Add this line
                        handler.removeCallbacks(runnable);
                    }
                }

                @Override
                public void onAccuracyChanged(Sensor sensor, int accuracy) {
                    // Do nothing
                }
            };

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.CUPCAKE) {
            sensorManager.registerListener(lightEventListener, lightSensor, SensorManager.SENSOR_DELAY_NORMAL);
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.CUPCAKE) {
            sensorManager.unregisterListener(lightEventListener);
        }


    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

}
