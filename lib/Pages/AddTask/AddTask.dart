import 'package:flutter/material.dart';

import 'AddTask_Daily.dart';

class AddTask extends StatefulWidget {
  final String title;

  AddTask({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new AddTaskState();
  }
}

class AddTaskState extends State<AddTask> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  backgroundColor: Colors.green[700],
                  title: Text('Add Task'),
                  pinned: true,
                  floating: true,
                  bottom: TabBar(
                      indicatorColor: Colors.white,
                      controller: this._tabController,
                      tabs: [
                        Column(
                          children: <Widget>[
                            Icon(Icons.calendar_today),
                            Text('Daily')
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Icon(Icons.date_range),
                            Text('Weekly')
                          ],
                        ),
                        Column(
                          children: <Widget>[Icon(Icons.alarm), Text('Once')],
                        ),
                      ]),
                ),
              ];
            },
            body: TabBarView(controller: this._tabController, children: [
              AddTask_Daily(),
              AddTask_Daily(),
              AddTask_Daily()
            ])));
  }
}
