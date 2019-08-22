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
          ? Item('شروع : ', Text(_task.getStartDateDiff()))
          : Container(),
      _task.end != null
          ? Item('پایان : ', Text(_task.getEndDateDiff()))
          : Container(),
      _task.estimate != null
          ? Item('تعداد ساعت : ', Text(_task.getEstimateString()))
          : Container(),
      _task.description != null
          ? Item('توضیح : ', Text(_task.description.toString()))
          : Container(),
      Row(children: [
        Expanded(
            child: Container(
              color: Colors.grey[400],
              height: 1,
              margin: const EdgeInsets.all(25),
            ))
      ]),

      _task.tickDescription != null
          ? Item('توضیح تیک : ', Text(_task.tickDescription.toString()))
          : Container(),
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
