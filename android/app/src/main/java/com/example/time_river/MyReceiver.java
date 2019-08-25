package com.example.time_river;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import io.flutter.plugin.common.MethodChannel;

public class MyReceiver extends BroadcastReceiver {
    MethodChannel methodChannel;

    MyReceiver(MethodChannel methodChannel) {
        this.methodChannel = methodChannel;
    }

    @Override
    public void onReceive(final Context context, Intent intent) {
        methodChannel.invokeMethod("I say hello every minute!!", "");
    }
}

