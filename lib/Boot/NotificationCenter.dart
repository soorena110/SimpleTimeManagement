import 'dart:async';

import 'package:lamp/lamp.dart';

Timer flashingTimer;

class NotificationCenter {

  static blink() {
    Lamp.flash(Duration(seconds: 1));
    print('>===> blink');
  }

  static turnFlashOn() {
    if (flashingTimer == null) {
      flashingTimer = Timer.periodic(Duration(seconds: 2), (timer) {
        Lamp.flash(Duration(seconds: 1));
      });
      print('>===> flash on');
    }
  }

  static turnFlashOff() {
    if (flashingTimer != null) {
      flashingTimer.cancel();
      flashingTimer = null;
      print('>===> flash off');
    }
  }
}
