
import 'package:flutter/material.dart';

enum TaskType { today, buy }

class Task{
  final String _title;
  final TaskType _taskType;

  Task(this._title, this._taskType);


  getTitle(){
    return _title;
  }

  getIcon(){
    switch(_taskType){
      case TaskType.today:
        return Icons.today;
      case TaskType.buy:
        return Icons.add_shopping_cart;
    }
  }

  getColor(){
    switch(_taskType){
      case TaskType.today:
        return Colors.lightBlue;
      case TaskType.buy:
        return Colors.green;
    }
  }
}