package com.app.driving_assistant

import android.annotation.TargetApi
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState);
        this.getWindow().setStatusBarColor(android.graphics.Color.TRANSPARENT)
    }
}
