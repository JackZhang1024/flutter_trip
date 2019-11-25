package com.example.flutter_trip

import android.os.Bundle
import com.example.asr_plugin.AsrPlugin

import io.flutter.app.FlutterActivity
import io.flutter.plugins.AsrPluginRegistrant
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this);
    // 注册Asr插件
    AsrPluginRegistrant.registerWith(this);
  }
  
}
