import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:time_river/Database/Tables/OnceTaskTable.dart';
import 'package:time_river/Framework/CircleIcon.dart';
import 'package:time_river/Models/OnceTask.dart';

import 'OnceTask/OnceTaskView.dart';

class TaskDetails extends StatefulWidget {
  final OnceTask _task;

  const TaskDetails(this._task, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TaskDetailsState();
  }
}

class TaskDetailsState extends State<TaskDetails> {
  TextEditingController textController;

  _changeTick(OnceTaskTick tickType) async {
    final tickDescription = textController.value.text;

    this.setState(() {
      widget._task.tick = tickType;
      widget._task.tickDescription =
      tickDescription != '' ? tickDescription : null;
    });
    OnceTaskTable.insertOrUpdate(widget._task.toMap());
  }

  TextField _renderTickDesctiptionField() {
    return TextField(
        autofocus: true,
        minLines: 2,
        maxLines: 3,
        controller: textController,
        decoration: InputDecoration(labelText: 'توضیح تیک'));
  }

  RaisedButton _renderTickChangeButton(OnceTaskTick tickType) {
    return RaisedButton(
        textColor: Colors.white,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(OnceTaskTickIcons[tickType]),
              Text(tickType.toString().split('.')[1])
            ]),
        color: OnceTaskTickColors[tickType],
        onPressed: () {
          this._changeTick(tickType);
          Navigator.pop(context);
        });
  }

  _showChangingTickDialogBox(OnceTaskTick tick) {
    if (textController != null) textController.dispose();
    textController = TextEditingController(text: widget._task.tickDescription);

    final title = Row(
      children: <Widget>[
        Text('تغییر تیک'),
        Expanded(child: Container()),
        Icon(Icons.arrow_forward),
        CircleIcon(OnceTaskTickIcons[tick], OnceTaskTickColors[tick])
      ],
    );

    showDialog(
        context: context,
        builder: (context) {
          return Directionality(
              textDirection: TextDirection.rtl,
              child: SimpleDialog(
                title: title,
                contentPadding: const EdgeInsets.all(20),
                children: <Widget>[
                  this._renderTickDesctiptionField(),
                  this._renderTickChangeButton(tick)
                ],
              ));
        });
  }

  Widget _tickStateFloatingButton() {
    final availableTicks =
    OnceTaskTick.values.where((v) => v != widget._task.tick);

    final subItems = availableTicks
        .map((v) =>
        SpeedDialChild(
            child: Icon(OnceTaskTickIcons[v]),
            backgroundColor: OnceTaskTickColors[v],
            label: v
                .toString()
                .split('.')
                .last,
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => this._showChangingTickDialogBox(v)))
        .toList();

    return Directionality(
        textDirection: TextDirection.ltr,
        child: SpeedDial(
          child: Icon(widget._task.getIcon()),
          backgroundColor: widget._task.getColor(),
          foregroundColor: Colors.white,
          marginRight: 40,
          marginBottom: 10,
          overlayOpacity: 0,
          children: subItems,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: widget._task.getColor(),
                title: Text(widget._task.name)),
            body: OnceTaskView(widget._task),
            floatingActionButton: this._tickStateFloatingButton()));
  }
}
