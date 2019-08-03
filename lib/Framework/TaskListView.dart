import 'package:flutter/material.dart';
import 'package:time_river/Pages/TaskDetails.dart';
import 'Task.dart';
import 'TaskView.dart';

class TaskListView extends StatelessWidget {
  final List<Task> _tasks;

  const TaskListView(this._tasks, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (BuildContext context, int index) {
          var task = _tasks[index];
          return GestureDetector(
              child: TaskView(task),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskDetails(task)));
              });
        });
  }
}
