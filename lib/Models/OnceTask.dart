import 'package:flutter/material.dart';

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

  final OnceTaskTick tick;
  final String tickDescription;

  final String lastUpdate;

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

  getIcon() {
    return OnceTaskTickIcons[tick];
  }

  getColor() {
    return OnceTaskTickColors[tick];
  }

  @override
  String toString() {
    return '${id ?? name}';
  }
}
