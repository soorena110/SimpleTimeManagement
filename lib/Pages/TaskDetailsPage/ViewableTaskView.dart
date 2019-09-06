import 'package:flutter/material.dart';
import 'package:time_river/Database/Tables/Tasks/WeekTaskTable.dart';
import 'package:time_river/Framework/InputFields/CheckBoxList.dart';
import 'package:time_river/Models/Task.dart';

class ViewableTaskView extends StatelessWidget {
  final Task task;

  const ViewableTaskView(this.task);

  List<Widget> _buildCommonInfos() {
    return [
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
      task.description != null && task.description.trim() != ''
          ? Item('توضیح : ', Text(task.description.toString()))
          : Container(),
    ];
  }

  List<Widget> _buildSpecialInfos() {
    if (task.infos == null) return [];

    switch (task.type) {
      case TaskType.once:
        return [];
      case TaskType.week:
        return [
          task.infos['startHour'] != null &&
              task.infos['startHour'].trim() != ''
              ? Item('ساعت شروع اجرا : ', Text(task.infos['startHour']))
              : Container(),
          task.infos['endHour'] != null && task.infos['endHour'].trim() != ''
              ? Item('ساعت پایان اجرا : ', Text(task.infos['endHour']))
              : Container(),
          task.infos['weekdays'] != null
              ? Container(
              margin: const EdgeInsets.only(top: 15),
              child: CheckBoxList(
                  titles: weekDayNames, value: task.infos['weekdays'] ?? 0))
              : Container(),
        ];
      case TaskType.month:
        return [
          task.infos['startHour'] != null &&
              task.infos['startHour'].trim() != ''
              ? Item('ساعت شروع اجرا : ', Text(task.infos['startHour']))
              : Container(),
          task.infos['endHour'] != null && task.infos['endHour'].trim() != ''
              ? Item('ساعت پایان اجرا : ', Text(task.infos['endHour']))
              : Container(),
          task.infos['dayOfMonth'] != null
              ? Item('روز ماه : ', Text(task.infos['dayOfMonth'].toString()))
              : Container(),
        ];
      default:
        throw 'Task type is not defined !';
    }
  }

  List<Widget> _buildTickInfos() {
    if (task.tick == null) return [];

    return [
      Row(children: [
        Expanded(
            child: Container(
              color: Colors.grey[400],
              height: 1,
              margin: const EdgeInsets.all(25),
            ))
      ]),
      task.tick.description != null
          ? Item('توضیح تیک : ', Text(task.tick.description.toString()))
          : Container()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ..._buildCommonInfos(),
      ..._buildSpecialInfos(),
      ..._buildTickInfos(),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text(_title), _value]));
  }
}
