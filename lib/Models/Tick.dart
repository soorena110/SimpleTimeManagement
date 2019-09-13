import 'package:flutter/material.dart';

import 'Task.dart';

enum TickType { todo, doing, done, canceled, postponed }

const TickIcons = {
  TickType.todo: Icons.tag_faces,
  TickType.doing: Icons.directions_run,
  TickType.done: Icons.check_circle,
  TickType.canceled: Icons.remove_circle,
  TickType.postponed: Icons.pause_circle_filled
};

const TickColors = {
  TickType.todo: Colors.lightGreen,
  TickType.doing: Colors.green,
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

  Tick.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        taskId = json['taskId'],
        type = TickType.values[json['type']],
        description = json['description'],
        lastUpdate = json['lastUpdate'],
        taskType = TaskType.values[json['taskType']] {
    this.infos = <String, dynamic>{};
    json.forEach((key, value) {
      if (!tickBaseKeys.contains(key)) infos[key] = value;
    });
  }

  IconData getIcon() => TickIcons[type];

  Color getColor() => TickColors[type];

  String getTickName() => type.toString().split('.')[1];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'taskId': taskId,
        'type': TickType.values.indexOf(type),
        'description': description,
        'lastUpdate': lastUpdate,
        'taskType': TaskType.values.indexOf(taskType)
      }
        ..addAll(infos);

  @override
  String toString() => '$taskId --- $type';
}

const tickBaseKeys = const [
  'id',
  'taskId',
  'type',
  'description',
  'lastUpdate',
  'taskType'
];
