import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;

  CircleIcon(this.icon, this.backgroundColor);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: this.backgroundColor,
      foregroundColor: Colors.white,
      child: Icon(this.icon),
    );
  }
}
