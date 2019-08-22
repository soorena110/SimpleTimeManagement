import 'package:flutter/material.dart';
import 'package:time_river/Models/OnceTask.dart';

class OnceTaskView extends StatelessWidget {
  final OnceTask _task;

  const OnceTaskView(this._task);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Item('نام : ', Text(_task.name)),
      _task.start != null
          ? Item('شروع : ', Text(_task.start.toString()))
          : null,
      _task.end != null ? Item('پایان : ', Text(_task.end.toString())) : null,
      _task.description != null
          ? Item('توضیح : ', Text(_task.description.toString()))
          : null,
      _task.estimate != null
          ? Item('تعداد ساعت : ', Text(_task.end.toString()))
          : null
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
