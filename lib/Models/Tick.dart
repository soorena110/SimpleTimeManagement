import 'package:flutter/material.dart';

import 'Task.dart';

enum TickType { todo, done, canceled, postponed }

const StringToTick = {
  'todo': TickType.todo,
  'done': TickType.done,
  'canceled': TickType.canceled,
  'postponed': TickType.postponed
};

const TickIcons = {
  TickType.todo: Icons.tag_faces,
  TickType.done: Icons.check_circle,
  TickType.canceled: Icons.remove_circle,
  TickType.postponed: Icons.pause_circle_filled
};

const TickColors = {
  TickType.todo: Colors.lightGreen,
  TickType.done: Colors.cyan,
  TickType.canceled: Colors.pinkAccent,
  TickType.postponed: Colors.orange
};

class Tick {
  int id;
  int taskId;
  TaskType taskType;
  TickType type;
  String description;
  String lastUpdate;
  Map<String, dynamic> infos;

  Tick({this.type = TickType.todo,
    this.id,
    this.taskId,
    this.description,
    this.lastUpdate,
    this.taskType,
    this.infos = const {}});

  Tick.fromJson(Map<String, dynamic> json, this.taskType)
      : id = json['id'],
        taskId = json['taskId'],
        type = TickType.values[json['type']],
        description = json['description'],
        lastUpdate = json['lastUpdate'] {
    this.infos = <String, dynamic>{};
    json.forEach((key, value) {
      if (!tickBaseKeys.contains(key))
        infos[key] = value;
    });
  }

  IconData getIcon() {
    return TickIcons[type];
  }

  Color getColor() {
    return TickColors[type];
  }

  String getTickName() {
    return type.toString().split('.')[1];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'type': TickType.values.indexOf(type),
      'description': description,
      'lastUpdate': lastUpdate
    }
      ..addAll(infos);
  }

  @override
  String toString() {
    return '$taskId --- $type';
  }
}

const tickBaseKeys = const [
  'id',
  'taskId',
  'type',
  'description',
  'lastUpdate'
];
