import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '_commons.dart';

class TimeInputField extends StatefulWidget {
  final String title;
  final TextEditingController controller;

  TimeInputField(this.title, {@required this.controller});

  @override
  State<StatefulWidget> createState() {
    return TimeInputFieldState();
  }
}

class TimeInputFieldState extends State<TimeInputField> {
  @override
  Widget build(BuildContext context) {
    return inputFieldContainer(
      DateTimePickerFormField(
        keyboardType: null,
        inputType: InputType.time,
        editable: false,
        controller: widget.controller,
        decoration: inputFieldDecorator('', Icons.access_time),
        format: DateFormat('HH:mm'),
      ),
    );
  }
}
