import 'package:flutter/material.dart';
import 'package:time_river/Framework/CircleIcon.dart';
import 'package:time_river/Framework/StaggerCircle.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Models/Tick.dart';

final defaultTick = Tick(type: TickType.todo);

class ViewableTaskListItem extends StatelessWidget {
  final Task task;
  final bool showLastEdit;

  ViewableTaskListItem(this.task, {this.showLastEdit = false});

  @override
  Widget build(BuildContext context) {
    final tick = this.task.tick ?? defaultTick;
    final _circleIcon = this.task.getIsCritical()
        ? StaggerCircle(tick.getIcon(), tick.getColor())
        : CircleIcon(tick.getIcon(), tick.getColor());

    _trailing() {
      final trailing = this.task.getRemainingTime();
      return Text(trailing,
          style: TextStyle(
              color: this.task.getIsCritical()
                  ? Colors.deepOrange
                  : trailing.contains('شروع') ? Colors.grey[300] : null));
    }

    _subtitle() {
      if (this.showLastEdit && this.task.lastUpdate != null)
        return Text(
            'آخرین تغییر: ' + this.task.lastUpdate.replaceFirst(' ', ' ساعت '),
            style: TextStyle(fontSize: 8, color: Colors.grey[300]));

      var ret = this.task.getMoreInfo() ?? '';
      if (this.task.estimate != null)
        ret = this.task.getEstimateString() + ' ' + ret;
      if (ret != '') return Text(ret);
      return null;
    }

    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 1, color: Colors.grey[200])]),
        child: ListTile(
            title: Text(task.name),
            leading: _circleIcon,
            trailing: _trailing(),
            subtitle: _subtitle()));
  }
}
