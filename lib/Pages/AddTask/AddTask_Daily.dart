import 'package:flutter/material.dart';
import 'package:time_river/Framework/TextInputField.dart';

class AddTask_Daily extends StatelessWidget {
  final String title;

  AddTask_Daily({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextInputField('TaskName'),
        TextInputField('TaskName'),
        TextInputField('TaskName'),
        TextInputField('TaskName'),
        TextInputField('TaskName'),
        TextInputField('TaskName'),
        TextInputField('TaskName'),
        TextInputField('TaskName')
      ],
    );
  }
}
