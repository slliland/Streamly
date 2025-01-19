package com.example.streamly

import android.graphics.Color
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
         override fun onCreate(savedInstanceState: Bundle?) {
                 super.onCreate(savedInstanceState)
                 if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                         val window = activity.window
                     // Set the status bar to transparent color,
                     // The status bar will flash gray when fix starts
                         window.statusBarColor = Color.TRANSPARENT
                     }
             }
}