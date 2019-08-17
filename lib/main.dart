import 'package:flutter/material.dart';
import 'Database/init.dart';
import 'Layout.dart';

void main() {
  databaseInit();
  runApp(Layout());
  WidgetsBinding.instance.addObserver(LifecycleEventHandler());
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.suspending:
        databaseClose();
        break;
      case AppLifecycleState.resumed:
        databaseOpen();
    }
    print('=== $state');
  }
}
