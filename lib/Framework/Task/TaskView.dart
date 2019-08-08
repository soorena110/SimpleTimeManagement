import 'package:flutter/material.dart';
import 'package:time_river/Pages/TaskDetails.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Framework/Task/TaskListItem.dart';

class TaskView extends StatelessWidget {
  final Task _task;

  const TaskView(this._task);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Item('Title : ', Text(_task.title)),
      Item(
          'Type : ',
          Row(children: [
            Text(_task.taskType.toString()),
            Icon(_task.getIcon())
          ])),
      Item('Start : ', Text(_task.startTime.toString())),
      Item('End : ', Text(_task.endTime.toString())),
      Item('Description : ', Text(_task.description.toString()))
    ]);
  }
}

class Item extends StatelessWidget {
  final String _title;
  final Widget _value;

  const Item(this._title, this._value);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(_title), _value]));
  }
}
