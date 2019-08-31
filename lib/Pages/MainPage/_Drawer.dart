import 'package:flutter/material.dart';
import 'package:time_river/Framework/CircleIcon.dart';
import 'package:time_river/Models/ViewableTask.dart';
import 'package:time_river/Pages/AllTasksPages/AllOnceTasksPage.dart';

getMainPageDrawer(context) {
  return Drawer(
    child: ListView(children: [
      ListTile(
        title: Text('لیست تسک‌های تکی'),
        leading: CircleIcon(Icons.done_all, Colors.pinkAccent),
        onTap: () async {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AllViewableTasksPage(ViewableTaskType.once)));
        },
      ),
      ListTile(
        title: Text('لیست تسک‌های هفتگی'),
        leading: CircleIcon(Icons.done_all, Colors.deepOrange),
        onTap: () async {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AllViewableTasksPage(ViewableTaskType.week)));
        },
      ),
      ListTile(
        title: Text('همه تسک‌های ماهانه'),
        leading: CircleIcon(Icons.done_all, Colors.amber),
        onTap: () async {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AllViewableTasksPage(ViewableTaskType.month)));
        },
      )
    ]),
  );
}
