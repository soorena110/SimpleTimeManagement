package com.example.time_river;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class MyServiceReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(final Context context, Intent intent) {
        Intent serviceIntent = new Intent(context, MyService.class);
        context.startService(serviceIntent);
    }
}

