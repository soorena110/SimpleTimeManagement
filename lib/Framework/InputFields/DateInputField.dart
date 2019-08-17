import 'package:flutter/material.dart';
import 'package:persian_datepicker/persian_datepicker.dart';
import '_commons.dart';

class DateInputField extends StatefulWidget {
  final String title;
  final Function(String) onChanged;

  DateInputField(this.title, {this.onChanged});

  @override
  State<StatefulWidget> createState() {
    return DateInputFieldState();
  }
}

class DateInputFieldState extends State<DateInputField> {
  final TextEditingController textEditingController = TextEditingController();
  PersianDatePickerWidget persianDatePicker;

  @override
  void initState() {
    persianDatePicker = PersianDatePicker(
      controller: textEditingController,
    ).init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return inputFieldContainer(TextField(
      enableInteractiveSelection: false,
      decoration: inputFieldDecorator(widget.title, Icons.today),
      onTap: () {
        FocusScope.of(context).requestFocus(
            new FocusNode());
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return persianDatePicker;
            });
      },
      controller: textEditingController,
    ));
  }
}
