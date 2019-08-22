import 'package:flutter/material.dart';
import 'package:persian_datepicker/persian_datepicker.dart';

import '_commons.dart';

class DateInputField extends StatefulWidget {
  final String title;
  final TextEditingController controller;

  DateInputField(this.title, {@required this.controller});

  @override
  State<StatefulWidget> createState() {
    return DateInputFieldState();
  }
}

class DateInputFieldState extends State<DateInputField> {
  PersianDatePickerWidget persianDatePicker;

  @override
  void initState() {
    persianDatePicker = PersianDatePicker(
      controller: widget.controller,
    ).init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return inputFieldContainer(TextField(
      enableInteractiveSelection: false,
      decoration: inputFieldDecorator(widget.title, Icons.today),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return persianDatePicker;
            });
      },
      controller: widget.controller,
    ));
  }
}
