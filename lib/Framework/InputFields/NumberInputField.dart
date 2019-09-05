import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import '_commons.dart';

class NumberInputField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final int minValue;
  final int maxValue;

  NumberInputField(this.title,
      {@required this.controller, this.minValue = 0, this.maxValue = 100});

  @override
  State<StatefulWidget> createState() {
    return NumberInputFieldState();
  }
}

class NumberInputFieldState extends State<NumberInputField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() => setState(() {}));
  }

  void _showDialog() async {
    int value = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new NumberPickerDialog.integer(
            minValue: widget.minValue,
            maxValue: widget.maxValue,
            title: new Text("انتخاب عدد"),
            initialIntegerValue: int.tryParse(widget.controller.text) ?? 0,
            highlightSelectedValue: true,
          );
        });
    if (value != null)
      widget.controller.value = TextEditingValue(text: value.toString());
  }

  @override
  Widget build(BuildContext context) {
    return inputFieldContainer(TextField(
        controller: widget.controller,
        readOnly: true,
        onTap: () => _showDialog(),
        decoration: inputFieldDecorator(widget.title, Icons.games)));
  }
}
