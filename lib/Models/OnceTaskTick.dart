import 'package:flutter/material.dart';

enum OnceTaskTickStatus { done, canceled, postponed }

const StringToOnceTaskTickStatus = {
  'done': OnceTaskTickStatus.done,
  'canceled': OnceTaskTickStatus.canceled,
  'postponed': OnceTaskTickStatus.postponed
};

const OnceTaskTickStatusIcons = {
  OnceTaskTickStatus.done: Icons.check_circle,
  OnceTaskTickStatus.canceled: Icons.remove_circle,
  OnceTaskTickStatus.postponed: Icons.pause_circle_filled
};

const OnceTaskTickStatusColors = {
  OnceTaskTickStatus.done: Colors.lightGreen,
  OnceTaskTickStatus.canceled: Colors.pinkAccent,
  OnceTaskTickStatus.postponed: Colors.orange
};

class OnceTaskTick {
  final int id;
  final int onceTaskId;
  final OnceTaskTickStatus status;
  final String description;
  final String lastUpdate;

  OnceTaskTick(this.onceTaskId, this.status,
      {this.id, this.description, this.lastUpdate});

  OnceTaskTick.fromJson(Map<String, dynamic> map)
      : id = map['id'],
        onceTaskId = map['onceTaskId'],
        status = StringToOnceTaskTickStatus[map['status']],
        description = map['description'],
        lastUpdate = map['lastUpdate'];

  getIcon() => OnceTaskTickStatusIcons[this.status];

  getColor() => OnceTaskTickStatusColors[this.status];

  @override
  String toString() => onceTaskId.toString();
}
