import 'package:flutter/material.dart';

import 'Database/init.dart';
import 'Pages/MainPage/MainPage.dart';

void main() async {
  await databaseInit();
  runApp(Layout());
  WidgetsBinding.instance.addObserver(LifecycleEventHandler());
}

class Layout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.suspending:
        await databaseClose();
        break;
      case AppLifecycleState.resumed:
        await databaseOpen();
    }
    print('=== $state');
  }
}
