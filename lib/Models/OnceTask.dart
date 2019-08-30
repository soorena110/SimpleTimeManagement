import 'package:flutter/material.dart';
import 'package:time_river/Libraries/datetime.dart';

import 'TaskBase.dart';

enum OnceTaskTick { todo, done, canceled, postponed }

const StringToOnceTaskTick = {
  'todo': OnceTaskTick.todo,
  'done': OnceTaskTick.done,
  'canceled': OnceTaskTick.canceled,
  'postponed': OnceTaskTick.postponed
};

const OnceTaskTickIcons = {
  OnceTaskTick.todo: Icons.tag_faces,
  OnceTaskTick.done: Icons.check_circle,
  OnceTaskTick.canceled: Icons.remove_circle,
  OnceTaskTick.postponed: Icons.pause_circle_filled
};

const OnceTaskTickColors = {
  OnceTaskTick.todo: Colors.lightGreen,
  OnceTaskTick.done: Colors.cyan,
  OnceTaskTick.canceled: Colors.pinkAccent,
  OnceTaskTick.postponed: Colors.orange
};

class OnceTask extends TaskBase {
  OnceTaskTick tick;
  String tickDescription;

  //#region Constructors

  OnceTask(String name,
      {int id,
        String description,
        String start,
        String end,
        double estimate,
      this.tick,
      this.tickDescription,
        String lastUpdate})
      : super(
      id,
      name,
      start,
      end,
      description,
      estimate,
      lastUpdate);

  OnceTask.fromJson(Map<String, dynamic> json)
      : tick = StringToOnceTaskTick[json['tick']],
        tickDescription = json['tickDescription'],
        super.fromJson(json);

  Map<String, dynamic> toJson() =>
      super.toJson()
        ..addAll({
          'tick': tick.toString().split('.')[1],
          'tickDescription': tickDescription,
        });

  //#endregion
  //#region Apis

  String getRemainingTime() {
    var ret = this.getEndDateDiff();

    if (this.start != null) {
      final now = getNow();
      if (getDateDiff(this.start, now).inMilliseconds > 0)
        ret = this.getStartDateDiff();
    }
    return ret;
  }

  String getStartDateDiff() {
    final now = getNow();
    if (this.start != null) {
      final diff = getDiffrenceText(this.start, now);
      return 'از ' + diff;
    }
    return '';
  }

  String getEndDateDiff() {
    final now = getNow();
    if (this.end != null) {
      final diff = getDiffrenceText(this.end, now);
      return 'تا ' + diff;
    }
    return '';
  }

  IconData getIcon() {
    return OnceTaskTickIcons[tick];
  }

  Color getColor() {
    return OnceTaskTickColors[tick];
  }

  bool getIsCritical() {
    if (this.end == null) return false;

    final now = getNow();
    final remainingTime = getDateTimeDiff(this.end, now).inMinutes;
    return remainingTime - (estimate ?? 0) * 60 < 30;
  }

  String getTickName() {
    return tick.toString().split('.')[1];
  }

  //#endregion

}
