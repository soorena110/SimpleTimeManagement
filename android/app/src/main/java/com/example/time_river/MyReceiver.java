package com.example.time_river;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class MyReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(final Context context, Intent intent) {
        MainActivity.callFlutter();
    }
}

