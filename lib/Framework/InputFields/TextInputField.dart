import 'package:flutter/material.dart';

import '_commons.dart';

class TextInputField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool isTextArea;
  final int minLines;
  final int maxLines;

  TextInputField(this.title,
      {@required this.controller,
      this.isTextArea = false,
      this.minLines,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return inputFieldContainer(TextField(
        controller: this.controller,
        minLines: this.minLines,
        maxLines: this.maxLines,
        decoration: inputFieldDecorator(
            this.title, this.isTextArea ? Icons.speaker_notes : Icons.title)));
  }
}
