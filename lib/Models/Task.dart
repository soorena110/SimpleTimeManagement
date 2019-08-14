import 'package:flutter/material.dart';

enum TaskType { today, buy }

class Task {
  final String title;
  final TaskType taskType;
  final String description;
  final DateTime startTime;
  final DateTime endTime;

  Task(this.title, this.taskType,
      {this.description, this.startTime, this.endTime});

  Task.from(Map<String, dynamic> map)
      : title = map['title'],
        taskType = map['taskType'],
        description = map['description'],
        startTime = map['startTime'],
        endTime = map['endTime'];

  getIcon() {
    switch (taskType) {
      case TaskType.today:
        return Icons.today;
      case TaskType.buy:
        return Icons.add_shopping_cart;
    }
  }

  getColor() {
    switch (taskType) {
      case TaskType.today:
        return Colors.lightBlue;
      case TaskType.buy:
        return Colors.green;
    }
  }

  @override
  String toString() {
    return title;
  }
}
