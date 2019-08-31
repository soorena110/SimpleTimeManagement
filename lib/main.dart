import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Boot/App.dart';
import 'Boot/LifecycleEventHandler.dart';
import 'Database/init.dart';

void main() async {
  SystemChrome.setEnabledSystemUIOverlays([]);

  await databaseOpen();
  runApp(App());
  WidgetsBinding.instance.addObserver(LifecycleEventHandler());
}