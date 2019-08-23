import 'package:flutter/material.dart';
import 'package:time_river/Framework/CircleIcon.dart';
import 'package:time_river/Pages/AllOnceTasksPage/AllOnceTasksPage.dart';

getMainPageDrawer(context) {
  return Drawer(
    child: ListView(children: [
      ListTile(
        title: Text('همه تسک‌های تکی'),
        leading: CircleIcon(Icons.done_all, Colors.pinkAccent),
        onTap: () async {
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AllOnceTasksPage()));
        },
      )
    ]),
  );
}
