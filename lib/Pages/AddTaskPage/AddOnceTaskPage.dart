import 'package:flutter/material.dart';
import 'package:time_river/Database/Tables/OnceTaskTable.dart';
import 'package:time_river/Framework/InputFields/DateInputField.dart';
import 'package:time_river/Framework/InputFields/TextInputField.dart';
import 'package:time_river/Framework/InputFields/TimeInputField.dart';
import 'package:time_river/Libraries/datetime.dart';
import 'package:time_river/Models/OnceTask.dart';

class AddOnceTaskPage extends StatefulWidget {
  final OnceTask task;

  AddOnceTaskPage([OnceTask task]) : this.task = task ?? OnceTask('');

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
        TextEditingController(text: t?.estimate?.toString() ?? '');

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

    await OnceTaskTable.insertOrUpdate(widget.task.toJson());
    Navigator.pop(context, true);
    Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green, content: Text('با موفیت ثبت شد.')));
  }

  _buildBodyContent() {
    return Builder(
        builder: ((context) => Column(
              children: <Widget>[
                TextInputField('عنوان', controller: this._nameController),
                DateInputField('تاریخ شروع',
                    controller: this._startDateController),
                this._startDateController.text != ''
                    ? TimeInputField('ساعت شروع',
                        controller: this._startTimeController)
                    : Container(),
                DateInputField('تاریخ پایان',
                    controller: this._endDateController),
                this._endDateController.text != ''
                    ? TimeInputField('ساعت پایان',
                        controller: this._endTimeController)
                    : Container(),
                TextInputField('تعداد ساعات',
                    keyboardType: TextInputType.number,
                    controller: this._estimateController),
                TextInputField('توضیح',
                    controller: this._descriptionController),
                Container(
                    margin: const EdgeInsets.all(30),
                    child: RaisedButton(
                        child: Text('ثبت'),
                        onPressed: () {
                          this._submit(context);
                        }))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[200],
        title: Text('${widget.task == null ? 'ایجاد' : 'ویرایش'} تسک جدید'),
      ),
      body: _buildBodyContent(),
    );
  }
}
