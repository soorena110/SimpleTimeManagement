import 'package:flutter/material.dart';

class OnceTask {
  final int id;
  final String name;
  final String start;
  final String end;
  final double estimate;
  final String description;

  OnceTask(this.name,
      {this.id, this.description, this.start, this.end, this.estimate});

  OnceTask.from(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        description = map['description'],
        start = map['start'],
        end = map['end'],
        estimate = map['estimate'];

  getIcon() {
    return Icons.tag_faces;
  }

  getColor() {
    return Colors.lightBlue;
  }

  @override
  String toString() {
    return id ?? name;
  }
}
