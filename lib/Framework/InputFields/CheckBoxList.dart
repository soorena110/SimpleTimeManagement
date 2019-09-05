import 'package:flutter/material.dart';

class CheckBoxList extends StatefulWidget {
  final String label;
  final List<String> titles;
  final TextEditingController controller;
  final int value;

  CheckBoxList(
      {@required this.titles, this.controller, this.label, this.value = 0});

  @override
  State<StatefulWidget> createState() {
    return CheckBoxListState();
  }
}

class CheckBoxListState extends State<CheckBoxList> {
  @override
  initState() {
    super.initState();

    if (widget.controller != null)
      widget.controller.addListener(() => setState(() {}));
  }

  _changeCheckBoxValue(bool value, int checkBoxIndex) {
    if (widget.controller == null) return;

    var stateValue = widget.controller.text != null
        ? int.tryParse(widget.controller.text)
        : 0;

    final theBit = 1 << checkBoxIndex;
    if (value)
      stateValue = stateValue | theBit;
    else
      stateValue &= ~theBit;
    widget.controller.value = TextEditingValue(text: stateValue.toString());
  }

  _buildCheckBoxes() {
    var tempValue = widget.controller != null
        ? int.tryParse(widget.controller.text)
        : widget.value;

    var currentIndex = 0;
    return widget.titles.map((t) {
      final isChecked = tempValue % 2 == 1;
      final thisCheckBoxIndex = currentIndex++;
      tempValue = tempValue >> 1;
      return Column(
        children: <Widget>[
          Checkbox(
              value: isChecked,
              onChanged: (value) {
                _changeCheckBoxValue(value, thisCheckBoxIndex);
              }),
          Text(t.substring(0, 1))
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _buildCheckBoxes());
  }
}
