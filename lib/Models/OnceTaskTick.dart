import 'package:flutter/material.dart';

enum OnceTaskTickStatus { done, canceled, postponed }

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
  final OnceTaskTickStatus onceTaskTickStatus;
  final String description;

  OnceTaskTick(this.onceTaskId, this.onceTaskTickStatus,
      {this.id, this.description});

  OnceTaskTick.from(Map<String, dynamic> map)
      : id = map['id'],
        onceTaskId = map['onceTaskId'],
        onceTaskTickStatus = map['onceTaskTickStatus'],
        description = map['description'];

  getIcon() => OnceTaskTickStatusIcons[this.onceTaskTickStatus];
  getColor() => OnceTaskTickStatusColors[this.onceTaskTickStatus];
  @override
  String toString() => onceTaskId.toString();
}
