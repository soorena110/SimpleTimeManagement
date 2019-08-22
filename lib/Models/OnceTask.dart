import 'package:flutter/material.dart';
import 'package:time_river/Libraries/datetime.dart';

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

class OnceTask {
  final int id;
  final String name;
  final String start;
  final String end;
  final double estimate;
  final String description;

  OnceTaskTick tick;
  String tickDescription;

  final String lastUpdate;

  //#region Constructors

  OnceTask(this.name,
      {this.id,
      this.description,
      this.start,
      this.end,
      this.estimate,
      this.tick,
      this.tickDescription,
      this.lastUpdate});

  OnceTask.from(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        description = map['description'],
        start = map['start'],
        end = map['end'],
        estimate = map['estimate'],
        tick = StringToOnceTaskTick[map['tick']],
        tickDescription = map['tickDescription'],
        lastUpdate = map['lastUpdate'];

  Map<String, dynamic> toMap() =>
      {
        'id': id,
        'name': name,
        'description': description,
        'start': start,
        'end': end,
        'estimate': estimate,
        'tick': tick.toString().split('.')[1],
        'tickDescription': tickDescription,
        'lastUpdate': getNow()
      };

  //#endregion
  //#region Apis

  String getEstimateString() {
    final hm = this.estimate;
    final h = hm.floor();
    final m = ((hm - h) * 60).round();

    var ret = '';
    if (h != 0) ret = '${h}h';
    if (m != 0) ret += (ret != '' ? ' & ' : '') + '${m}m';
    return ret;
  }

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
    final remainingTime = getDateDiff(this.end, now).inMinutes;
    return remainingTime - (estimate ?? 0) < 30;
  }

  String getTickName() {
    return tick.toString().split('.')[1];
  }

  //#endregion

  @override
  String toString() {
    return '${id ?? name}';
  }
}
