import 'package:flutter/material.dart';

Widget inputFieldContainer(Widget child) {
  return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: Colors.grey[200], width: 1)),
      child: child);
}

InputDecoration inputFieldDecorator(String title, IconData icon) =>
    InputDecoration(
        contentPadding: const EdgeInsets.all(2),
        border: InputBorder.none,
        icon: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Icon(icon),
        ),
        labelText: title);
