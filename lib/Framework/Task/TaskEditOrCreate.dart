import 'package:flutter/material.dart';
import 'package:time_river/Database/TaskTable.dart';

import 'package:time_river/Framework/InputFields/DateInputField.dart';
import 'package:time_river/Framework/InputFields/TextInputField.dart';
import 'package:time_river/Framework/InputFields/TimeInputField.dart';

class TaskEditOrCreate extends StatelessWidget {
  final Map<String, dynamic> task;

  TaskEditOrCreate(this.task);

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: <Widget>[
        TextInputField('عنوان',
            onChanged: (value) => this.task['title'] = value),
        DateInputField('تاریخ شروع',
            onChanged: (value) => this.task['startDate'] = value),
        TimeInputField('ساعت شروع',
            onChanged: (value) => this.task['startTime'] = value),
        DateInputField('تاریخ پایان',
            onChanged: (value) => this.task['endDate'] = value),
        TimeInputField('ساعت پایان',
            onChanged: (value) => this.task['endTime'] = value),
        TextInputField('توضیحات',
            isTextArea: true,
            onChanged: (value) => this.task['description'] = value),
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
