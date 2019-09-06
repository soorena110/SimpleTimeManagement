import 'package:flutter/material.dart';
import 'package:time_river/Models/Task.dart';
import 'package:time_river/Pages/AllTasksPages/AllTasksPages.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Management App',
      theme: ThemeData(
          primaryColor: Colors.lightGreen[200],
          primaryIconTheme: IconThemeData(color: Colors.white),
          appBarTheme: AppBarTheme(
              textTheme: TextTheme(title: TextStyle(color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold))),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.lightGreen[200])),
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child),
      home: AllViewableTasksPage(TaskType.month),
      debugShowCheckedModeBanner: false,
    );
  }
}
