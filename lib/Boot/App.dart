import 'package:flutter/material.dart';
import 'package:time_river/Models/ViewableTask.dart';
import 'package:time_river/Pages/AllTasksPages/AllOnceTasksPage.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child),
      home: AllViewableTasksPage(ViewableTaskType.once),
      debugShowCheckedModeBanner: false,
    );
  }
}
