import 'package:flutter/material.dart';
import 'package:time_river/Framework/TaskView.dart';

import 'package:time_river/Pages/AddTask/AddTask.dart';
import 'MainPage_DailyTasks.dart';

class MainPage extends StatefulWidget {
  final String title;

  MainPage({Key key, this.title}) : super(key: key);

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
    return Scaffold(
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
                            Text('Today')
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Icon(Icons.date_range),
                            Text('Week')
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Icon(Icons.calendar_today),
                            Text('NextDay')
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
            ])),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.orangeAccent[700],
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddTask()));
            }));
  }
}
