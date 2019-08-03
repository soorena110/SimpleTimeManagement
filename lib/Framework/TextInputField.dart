import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final String title;

  TextInputField(this.title, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: Colors.grey[200], width: 1)),
      child: TextField(
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(2),
              border: InputBorder.none,
              icon: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(Icons.alarm_on),
              ),
              labelText: title)),
    );
  }
}
