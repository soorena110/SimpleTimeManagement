import 'package:flutter/material.dart';

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
  _getCurrentSelectedTime() {
    final selectedTimeString = widget.controller.text;
    if (selectedTimeString == null || selectedTimeString.trim() == '')
      return TimeOfDay(hour: 12, minute: 0);

    final selectedTimeParts =
        selectedTimeString.split(':').map((s) => int.parse(s)).toList();
    return TimeOfDay(hour: selectedTimeParts[0], minute: selectedTimeParts[1]);
  }

  @override
  Widget build(BuildContext context) {
    return inputFieldContainer(TextField(
      readOnly: true,
      controller: widget.controller,
      decoration: inputFieldDecorator(widget.title, Icons.access_time),
      onTap: () async {
        final newVal = await showTimePicker(
            context: context, initialTime: this._getCurrentSelectedTime());
        widget.controller.value = TextEditingValue(
            text: newVal.hour.toString().padLeft(2, '0') +
                ':' +
                newVal.minute.toString().padLeft(2, '0'));
      },
    ));
  }
}
