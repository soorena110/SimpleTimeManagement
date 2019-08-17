import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '_commons.dart';

class TimeInputField extends StatefulWidget {
  final String title;
  final Function(String) onChanged;

  TimeInputField(this.title, {this.onChanged});

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
        inputType: InputType.time,
        editable: false,
        decoration:inputFieldDecorator('', Icons.access_time),
        onChanged: (dt) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(dt.toString())));
        },
        format: DateFormat('HH:mm'),
      ),
    );
  }
}
