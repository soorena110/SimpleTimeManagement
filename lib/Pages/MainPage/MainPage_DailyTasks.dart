import 'package:flutter/material.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Framework/Task/TaskListView.dart';

var tasks = <Task>[
  Task('خرید تخم مرغ', TaskType.buy),
  Task('گرفتن سود جم پلین', TaskType.today),
  Task('خرید تخم مرغ', TaskType.buy),
  Task('خرید تخم مرغ', TaskType.buy),
];

class MainPage_DailyTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TaskListView(tasks);
  }
}
