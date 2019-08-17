import 'package:flutter/material.dart';
import 'package:time_river/Models/Task.dart';

class TaskView extends StatelessWidget {
  final Task _task;

  const TaskView(this._task);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Item('نام : ', Text(_task.name)),
      Item('شروع : ', Text(_task.start.toString())),
      Item('پایان : ', Text(_task.end.toString())),
      Item('توضیح : ', Text(_task.description.toString()))
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
        margin: const EdgeInsets.fromLTRB(30, 20, 30, 0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(_title), _value]));
  }
}
