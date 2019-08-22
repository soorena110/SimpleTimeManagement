//import 'package:flutter/material.dart';
//
//
//class OnceTaskTick {
//  final int id;
//  final int onceTaskId;
//  final OnceTaskTickStatus status;
//  final String description;
//  final String lastUpdate;
//
//  OnceTaskTick(this.onceTaskId, this.status,
//      {this.id, this.description, this.lastUpdate});
//
//  OnceTaskTick.fromJson(Map<String, dynamic> map)
//      : id = map['id'],
//        onceTaskId = map['onceTaskId'],
//        status = StringToOnceTaskTickStatus[map['status']],
//        description = map['description'],
//        lastUpdate = map['lastUpdate'];
//
//  getIcon() => OnceTaskTickStatusIcons[this.status];
//
//  getColor() => OnceTaskTickStatusColors[this.status];
//
//  @override
//  String toString() => onceTaskId.toString();
//}
