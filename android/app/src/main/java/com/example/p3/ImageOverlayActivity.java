// ImageOverlayActivity.java
package com.example.p3;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.WindowManager;
import android.widget.ImageView;

public class ImageOverlayActivity extends Activity {

    private BackgroundFetch backgroundFetchService;

    @TargetApi(Build.VERSION_CODES.ECLAIR)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d("ImageOverlayActivity", "Overlay activity started");
        // Set activity to draw over other apps
        getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON |
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD |
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED |
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON |
                WindowManager.LayoutParams.FLAG_FULLSCREEN |
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN);

        // Disable Home button
        getWindow().addFlags(WindowManager.LayoutParams.TYPE_SYSTEM_ERROR);

        setContentView(R.layout.activity_image_overlay);
        // 여기에 이미지를 설정하는 코드를 추가
        ImageView imageView = findViewById(R.id.overlayImageView);
        imageView.setImageResource(R.drawable.dragon); // your_image를 원하는 이미지로 변경

        // UI 갱신이 완료된 후에 finish()를 호출하도록 Handler 사용

        checkIntentActionAndFinish();
    }
    @Override
    protected void onDestroy() {
        super.onDestroy();
        Log.d("ImageOverlayActivity", "onDestroy called");
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        // onNewIntent가 호출될 때, 새로운 인텐트를 Activity에 설정
        setIntent(intent);
        checkIntentActionAndFinish();
    }

    private void checkIntentActionAndFinish() {
        if (getIntent().getAction() != null) {
            Log.d("ImageOverlayActivity", "Intent action: " + getIntent().getAction());
            if (getIntent().getAction().equals("STOP")) {
                Log.d("ImageOverlayActivity", "Finishing activity");
                finish();
            }
        } else {
            Log.d("ImageOverlayActivity", "Intent action is null");
        }
    }
    // ... (기존 코드)
}
