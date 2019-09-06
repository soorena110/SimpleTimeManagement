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

    final _trailing = Text(this.task.getRemainingTime(),
        style: TextStyle(
            color: this.task.getIsCritical() ? Colors.deepOrange : null));

    _subtitle() {
      if (this.showLastEdit && this.task.lastUpdate != null)
        return Text(
            'آخرین تغییر: ' + this.task.lastUpdate.replaceFirst(' ', ' ساعت '),
            style: TextStyle(fontSize: 8, color: Colors.grey[300]));
      if (this.task.estimate != null)
        return Text(this.task.getEstimateString());
      return null;
    }

    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 1, color: Colors.grey[200])]),
        child: ListTile(
            title: Text(task.name),
            leading: _circleIcon,
            trailing: _trailing,
            subtitle: _subtitle()));
  }
}
