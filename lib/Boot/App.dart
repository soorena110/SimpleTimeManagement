import 'package:flutter/material.dart';
import 'package:time_river/Pages/MainPage/MainPage.dart';

import 'ExitCheck.dart';

final theme = ThemeData(
    primaryColor: Colors.lightGreen,
    primaryIconTheme: IconThemeData(color: Colors.white),
    tabBarTheme: TabBarTheme(labelColor: Colors.white),
    appBarTheme: AppBarTheme(
        textTheme: TextTheme(
            title: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold))),
    floatingActionButtonTheme:
    FloatingActionButtonThemeData(backgroundColor: Colors.lightGreen));

class App extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Management App',
      theme: theme,
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child),
      home: ExitCheck(MainPage()),
      debugShowCheckedModeBanner: false,
    );
  }
}


