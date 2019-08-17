import 'dart:io';
import 'package:flutter/material.dart';
import 'MainPage_DailyTasks.dart';

class MainPage extends StatefulWidget {
  MainPage();

  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                      title: Text('Exit ??!'),
                      content: Text('Wanna Exit ??'),
                      actions: <Widget>[
                        FlatButton(
                            child: Text('Yes',
                                style: TextStyle(color: Colors.orangeAccent)),
                            onPressed: () {
                              exit(0);
                            }),
                        FlatButton(child: Text('No'), onPressed: () {})
                      ]));
        },
        child: Scaffold(
            body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      backgroundColor: Colors.orangeAccent[700],
                      title: Text('Time is a river with many eddies'),
                      pinned: true,
                      floating: true,
                      bottom: TabBar(
                          indicatorColor: Colors.white,
                          controller: this._tabController,
                          tabs: [
                            Column(
                              children: <Widget>[
                                Icon(Icons.calendar_today),
                                Text('امروز')
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Icon(Icons.calendar_today),
                                Text('فردا')
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Icon(Icons.date_range),
                                Text('هفته')
                              ],
                            ),
                            Column(
                              children: <Widget>[Icon(Icons.alarm), Text('')],
                            )
                          ]),
                    ),
                  ];
                },
                body: TabBarView(controller: this._tabController, children: [
                  MainPage_DailyTasks(),
                  Text('hellow !!'),
                  Text('hellow !!'),
                  MainPage_DailyTasks()
                ]))));
  }
}
