import 'package:flutter/material.dart';
import 'package:lamp/lamp.dart';
import 'package:time_river/Database/init.dart';

import 'App.dart';
import 'LifecycleEventHandler.dart';

void main() async {
  Lamp.flash(Duration(seconds: 10));
  await databaseInit();
  runApp(App());
  WidgetsBinding.instance.addObserver(LifecycleEventHandler());
}