import 'package:flutter/material.dart';
import 'package:time_river/Database/TaskTable.dart';

import '../TextInputField.dart';

class TaskEditOrCreate extends StatelessWidget {
  final Map<String, dynamic> task;

  TaskEditOrCreate(this.task);

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
          children: <Widget>[
            TextInputField('title', (value) => this.task['title'] = value),
            TextInputField(
                'description', (value) => this.task['description'] = value),
            RaisedButton(
              child: Text('Submit'),
              onPressed: () {
                TaskTable.addOrEdit(task);
              },
            )
          ],
        ));
  }
}
