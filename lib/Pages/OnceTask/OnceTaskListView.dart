import 'package:flutter/material.dart';
import 'package:time_river/Pages/TaskDetails.dart';
import 'package:time_river/Models/OnceTask.dart';
import 'OnceTaskListItem.dart';

class OnceTaskListView extends StatelessWidget {
  final List<OnceTask> _tasks;

  const OnceTaskListView(this._tasks);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (BuildContext context, int index) {
          var task = _tasks[index];
          return GestureDetector(
              child: OnceTaskListItem(task),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TaskDetails(task)));
              });
        });
  }
}
