import 'dart:async';

import 'package:lamp/lamp.dart';

Timer flashingTimer;

class NotificationCenter {
  turnFlashOn() {
    if (flashingTimer == null)
      flashingTimer = Timer.periodic(Duration(seconds: 2), (timer) {
        Lamp.flash(Duration(seconds: 1));
      });
  }

  turnFlashOff() {
    if (flashingTimer != null) flashingTimer.cancel();
  }
}