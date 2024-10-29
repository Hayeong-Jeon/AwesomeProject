// ScreenProtectorActivity.java
package com.example.p3;

import android.annotation.TargetApi;
import android.app.Activity;
import android.os.Build;
import android.os.Bundle;
import android.view.WindowManager;
import android.view.View;

import com.example.p3.R;

public class ScreenProtectorActivity extends Activity {
    @TargetApi(Build.VERSION_CODES.ECLAIR)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Set activity to draw over other apps
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON |
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD |
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED |
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON |
                WindowManager.LayoutParams.FLAG_FULLSCREEN |
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN);

        // Disable Home button
        getWindow().addFlags(WindowManager.LayoutParams.TYPE_SYSTEM_ERROR);

        setContentView(R.layout.activity_screen_protector);

    }

    // Disable Back button
    @Override
    public void onBackPressed() {
        // Do nothing
    }

    // Disable Recent button
    @Override
    protected void onPause() {
        super.onPause();
        // Prevent the activity from being paused
        moveTaskToBack(true);
    }
}
