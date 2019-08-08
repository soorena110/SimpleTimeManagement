import 'package:flutter/material.dart';
import 'package:time_river/Pages/TaskDetails.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Framework/Task/TaskListItem.dart';

import '../TextInputField.dart';

class TaskEditOrCreate extends StatelessWidget {
  final Task _task;

  const TaskEditOrCreate(this._task);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TextInputField('Title : '),
      TextInputField('Description : ')
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
