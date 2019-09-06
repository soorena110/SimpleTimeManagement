import 'dart:io';

import 'package:flutter/material.dart';

class ExitCheck extends StatefulWidget {
  final Widget child;

  const ExitCheck(this.child) : super();

  @override
  State<StatefulWidget> createState() {
    return ExitCheckState();
  }
}

class ExitCheckState extends State<ExitCheck> {
  Future<bool> _handlePopScopePop() async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('خروج ??!'),
                content: Text('آیا میخواهید خارج شوید ??'),
                actions: <Widget>[
                  FlatButton(
                      child: Text('بله',
                          style: TextStyle(color: Colors.orangeAccent)),
                      onPressed: () {
                        exit(0);
                      }),
                  FlatButton(
                      child: Text('خیر'),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ]));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _handlePopScopePop, child: widget.child);
  }
}
