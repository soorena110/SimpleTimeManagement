import 'package:flutter/material.dart';

import '_commons.dart';

class TextInputField extends StatelessWidget {
  final String title;
  final Function(String) onChanged;
  final bool isTextArea;

  TextInputField(this.title, {@required this.onChanged, this.isTextArea = false});

  @override
  Widget build(BuildContext context) {
    return inputFieldContainer(TextField(
        onChanged: this.onChanged,
        decoration: inputFieldDecorator(
            this.title, this.isTextArea ? Icons.speaker_notes : Icons.title)));
  }
}
