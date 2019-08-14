import 'package:flutter/material.dart';
import 'package:time_river/Pages/MainPage/MainPage.dart';

class Layout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Directionality(
          textDirection: TextDirection.rtl,
          child: MainPage()),
    );
  }
}
