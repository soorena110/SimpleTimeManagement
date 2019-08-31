import 'package:flutter/material.dart';

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
  TickType tick;
  String description;

  Tick(this.tick, {this.id, this.description});

  IconData getIcon() {
    return TickIcons[tick];
  }

  Color getColor() {
    return TickColors[tick];
  }

  String getTickName() {
    return tick.toString().split('.')[1];
  }
}
