import 'package:flutter/material.dart';
import 'package:time_river/Models/ViewableTask.dart';

class ViewableTaskView extends StatelessWidget {
  final ViewableTask task;

  const ViewableTaskView(this.task);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Item('نام : ', Text(task.name)),
      task.start != null
          ? Item('شروع : ', Text(task.getStartDateDiff()))
          : Container(),
      task.end != null
          ? Item('پایان : ', Text(task.getEndDateDiff()))
          : Container(),
      task.estimate != null
          ? Item('تعداد ساعت : ', Text(task.getEstimateString()))
          : Container(),
      task.description != null
          ? Item('توضیح : ', Text(task.description.toString()))
          : Container(),
      Row(children: [
        Expanded(
            child: Container(
              color: Colors.grey[400],
              height: 1,
              margin: const EdgeInsets.all(25),
            ))
      ]),

      task.tick?.description != null
          ? Item('توضیح تیک : ', Text(task.tick?.description.toString()))
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
