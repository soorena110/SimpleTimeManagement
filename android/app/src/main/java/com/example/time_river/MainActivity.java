package com.example.time_river;

import android.content.Intent;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterView;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "com.example";
    private static FlutterView flutterView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        flutterView = getFlutterView();
        GeneratedPluginRegistrant.registerWith(this);

        Intent service = new Intent(getApplicationContext(), BackgroundService.class);
        this.startService(service);
    }

    static void callFlutter() {
        MethodChannel methodChannel = new MethodChannel(flutterView, CHANNEL);
        methodChannel.invokeMethod("I say hello every minute!!", "");
    }
}