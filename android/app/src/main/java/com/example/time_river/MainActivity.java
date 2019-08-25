package com.example.time_river;

import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "com.example";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        MethodChannel methodChannel = new MethodChannel(getFlutterView(), CHANNEL);
        MyReceiver receiver = new MyReceiver(methodChannel);
        IntentFilter mTime = new IntentFilter(Intent.ACTION_TIME_TICK);
        registerReceiver(receiver, mTime);
    }
}