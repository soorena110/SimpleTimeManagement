import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:time_river/Database/Tables/OnceTaskTable.dart';
import 'package:time_river/Framework/CircleIcon.dart';
import 'package:time_river/Framework/InputFields/DateInputField.dart';
import 'package:time_river/Framework/InputFields/TextInputField.dart';
import 'package:time_river/Framework/InputFields/TimeInputField.dart';
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
  TextEditingController tickDescriptionController;
  TextEditingController tickDateController;
  TextEditingController tickTimeController;

  _changeTick(OnceTaskTick tickType) async {
    final tickDescription = tickDescriptionController.value.text;

    this.setState(() {
      widget._task.tick = tickType;
      widget._task.tickDescription =
      tickDescription != '' ? tickDescription : null;
      if (widget._task.tick == OnceTaskTick.postponed) {
        widget._task.end =
            tickDateController.value.text + ' ' + tickTimeController.value.text;
      }
    });
    OnceTaskTable.insertOrUpdate(widget._task.toMap());
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

  _resetInputControllers() {
    if (tickDescriptionController != null) tickDescriptionController.dispose();
    tickDescriptionController =
        TextEditingController(text: widget._task.tickDescription);
    if (tickDateController != null) tickDateController.dispose();
    tickDateController =
        TextEditingController(text: widget._task.end.split(' ')[0]);
    if (tickTimeController != null) tickTimeController.dispose();
    tickTimeController =
        TextEditingController(text: widget._task.end.split(' ')[1]);
  }

  _showChangingTickDialogBox(OnceTaskTick tick) {
    this._resetInputControllers();

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
                  tick == OnceTaskTick.postponed
                      ? DateInputField(
                    'تاریخ تعویق',
                    controller: tickDateController,
                  )
                      : Container(),
                  tick == OnceTaskTick.postponed
                      ? TimeInputField(
                    'زمان تعویق',
                    controller: tickTimeController,
                  )
                      : Container(),
                  TextInputField('توضیح تیک',
                      controller: tickDescriptionController,
                      minLines: 2,
                      maxLines: 3),
                  this._renderTickChangeButton(tick)
                ],
              ));
        });
  }

  Widget _tickStateFloatingButton() {
    final availableTicks = OnceTaskTick.values
        .where((v) => v != widget._task.tick || v == OnceTaskTick.postponed);

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
