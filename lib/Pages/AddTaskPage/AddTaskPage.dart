import 'package:flutter/material.dart';
import 'package:time_river/Database/Tables/OnceTaskTable.dart';
import 'package:time_river/Framework/InputFields/DateInputField.dart';
import 'package:time_river/Framework/InputFields/TextInputField.dart';
import 'package:time_river/Framework/InputFields/TimeInputField.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Models/ViewableTask.dart';

class AddOnceTaskPage extends StatefulWidget {
  final ViewableTask task;

  AddOnceTaskPage({ViewableTask task, ViewableTaskType taskType})
      : this.task =
            task ?? ViewableTask(type: taskType, infos: <String, dynamic>{});

  @override
  State<StatefulWidget> createState() {
    return AddOnceTaskPageState();
  }
}

class AddOnceTaskPageState extends State<AddOnceTaskPage> {
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  TextEditingController _startDateController;
  TextEditingController _startTimeController;
  TextEditingController _endDateController;
  TextEditingController _endTimeController;
  TextEditingController _estimateController;

  TextEditingController _weekOrMonth_hourController;
  TextEditingController _month_dayController;

  @override
  void initState() {
    super.initState();

    final t = widget.task;
    _nameController = TextEditingController(text: t == null ? null : t.name);
    _descriptionController = TextEditingController(text: t?.description ?? '');
    _startDateController =
        TextEditingController(text: t?.start?.split(' ')?.first ?? '');
    _startTimeController =
        TextEditingController(text: t?.start?.split(' ')?.last ?? '00:00');
    _endDateController =
        TextEditingController(text: t?.end?.split(' ')?.first ?? '');
    _endTimeController =
        TextEditingController(text: t?.end?.split(' ')?.last ?? '24:00');
    _estimateController =
        TextEditingController(text: t.estimate?.toString() ?? '');

    _weekOrMonth_hourController =
        TextEditingController(text: t.infos['hour'] ?? '');

    _month_dayController =
        TextEditingController(text: t.infos['dayOfMonth'].toString() ?? '1');

    _startDateController.addListener(() => setState(() {}));
    _endDateController.addListener(() => setState(() {}));
  }

  _validateJsonTask() {
    if (widget.task.name == null || widget.task.name.length < 4)
      return 'نام تسک حداقل باید 4 کاراکتر باشد.';

    if (widget.task.start != null &&
        widget.task.end != null &&
        compareDateTime(widget.task.start, widget.task.end) > 0)
      return 'تاریخ شروع باید کوچکتر از تاریخ پایان باشد.';

    if (widget.task.start != null &&
        compareDateTime(widget.task.start, getNow()) > 1)
      return 'تاریخ شروع باید بیشتر از زمان حال باشد.';

    if (widget.task.end != null &&
        compareDateTime(widget.task.end, getNow()) > 1)
      return 'تاریخ پایان باید بیشتر از زمان حال باشد.';

    if (widget.task.type == ViewableTaskType.month) {
      if (widget.task.infos != null || widget.task.infos['dayOfMonth'] == null)
        return 'روز ماه تعیین نشده است.';
      final value = int.tryParse(widget.task.infos['dayOfMonth']);
      if (value == null || value < 1 || value > 31)
        return 'روز ماه باید از 1 تا 31 باشد.';
    }

    return null;
  }

  _computeEnd() {
    final date = _endDateController.text;
    var time = _endTimeController.text;
    if (date == '') return null;
    if (time == '') time = '24:00';
    return '$date $time';
  }

  _computeStart() {
    final date = _startDateController.text;
    var time = _startTimeController.text;
    if (date == '') return null;
    if (time == '') time = '00:00';
    return '$date $time';
  }

  _submit(context) async {
    widget.task.name = _nameController.text;
    widget.task.start = this._computeStart();
    widget.task.end = this._computeEnd();
    widget.task.estimate = double.tryParse(_estimateController.text);
    widget.task.description = _descriptionController.text;

    final error = this._validateJsonTask();
    if (error != null) {
      Scaffold.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(error)));
      return;
    }

    await onceTaskTable.insertOrUpdate(widget.task.toJson());
    Navigator.pop(context, true);
    Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green, content: Text('با موفیت ثبت شد.')));
  }

  List<Widget> _buildTaskBaseFields() {
    return [
      TextInputField('عنوان', controller: this._nameController),
      DateInputField('تاریخ شروع', controller: this._startDateController),
      this._startDateController.text != ''
          ? TimeInputField('ساعت شروع', controller: this._startTimeController)
          : Container(),
      DateInputField('تاریخ پایان', controller: this._endDateController),
      this._endDateController.text != ''
          ? TimeInputField('ساعت پایان', controller: this._endTimeController)
          : Container(),
      TextInputField('تعداد ساعات',
          keyboardType: TextInputType.number,
          controller: this._estimateController),
      TextInputField('توضیح', controller: this._descriptionController),
      Container(
          margin: const EdgeInsets.all(30),
          child: RaisedButton(
              child: Text('ثبت'),
              onPressed: () {
                this._submit(context);
              }))
    ];
  }

  List<Widget> _buildSpecialFields() {
    switch (widget.task.type) {
      case ViewableTaskType.once:
        return [];
      case ViewableTaskType.week:
        return [
          TimeInputField('ساعت اجرا',
              controller: this._weekOrMonth_hourController),
        ];
      case ViewableTaskType.month:
        return [
          TimeInputField('ساعت اجرا',
              controller: this._weekOrMonth_hourController),
          TextInputField('روز ماه', controller: this._month_dayController),
        ];
    }
    return [];
  }

  _buildBodyContent() {
    return Builder(
        builder: ((context) => Column(children: [
              ..._buildTaskBaseFields(),
              ..._buildSpecialFields(),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(
          '${widget.task == null ? 'ایجاد' : 'ویرایش'} تسک جدید',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _buildBodyContent(),
    );
  }
}
