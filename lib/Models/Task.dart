import 'package:flutter/material.dart';

enum TaskType { today, buy }

class Task {
  final String name;
  final String start;
  final String end;
  final String description;

  Task(this.name,
      {this.description,
      this.start,
      this.end});

  Task.from(Map<String, dynamic> map)
      : name = map['name'],
        description = map['description'],
        start = map['start'],
        end = map['end'];

  getIcon() {
    return Icons.tag_faces;
  }

  getColor() {
    return Colors.lightBlue;
  }

  @override
  String toString() {
    return name;
  }
}
