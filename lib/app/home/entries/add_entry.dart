import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_schedule_app/app/home/entries/date_time_picker.dart';
import 'package:my_schedule_app/app/home/models/entry.dart';
import 'package:my_schedule_app/app/home/models/tasks.dart';
import 'package:my_schedule_app/app/services/database.dart';

import 'format.dart';
class AddEntry extends StatefulWidget {
  const AddEntry({Key key,@required this.task, this.entry,@required this.database}) : super(key: key);

  final Tasks task;
  final Entry entry;
  final Database database;

  static Future<void> show(BuildContext context,Database database,Tasks task,{Entry entry}) async{
    await Navigator.of(context,rootNavigator: true).push(
      CupertinoPageRoute(
          builder: (context)=>AddEntry(task: task,entry: entry ,database: database),
        fullscreenDialog: false,
      )
    );
  }


  @override
  _AddEntryState createState() => _AddEntryState();
}

class _AddEntryState extends State<AddEntry> {

  DateTime _startDate;
  TimeOfDay _startTime;
  DateTime _endDate;
  TimeOfDay _endTime;
  String _comment;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final start = widget.entry?.start ?? DateTime.now();
    _startDate = DateTime(start.year, start.month, start.day);
    _startTime = TimeOfDay.fromDateTime(start);

    final end = widget.entry?.end ?? DateTime.now();
    _endDate = DateTime(end.year, end.month, end.day);
    _endTime = TimeOfDay.fromDateTime(end);

    _comment = widget.entry?.comment ?? '';
  }

  Entry _entryFromState() {
    final start = DateTime(_startDate.year, _startDate.month, _startDate.day,
        _startTime.hour, _startTime.minute);
    final end = DateTime(_endDate.year, _endDate.month, _endDate.day,
        _endTime.hour, _endTime.minute);
    final id = widget.entry?.id ?? DateTime.now().toIso8601String();
    return Entry(
      id: id,
      taskId: widget.task.docId,
      start: start,
      end: end,
      comment: _comment,
    );
  }

  Future<void> _setEntryAndDismiss(BuildContext context) async {
    try {
      final entry = _entryFromState();
      await widget.database.createEntry(entry.toMap(), entry.id);
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: e.message,backgroundColor: Colors.indigo,textColor: Colors.white);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.task.name),
        actions: [
          FlatButton(
              onPressed:()=> _setEntryAndDismiss(context),
              child: Text(
                widget.entry!=null? 'Update':'Create',
                style: TextStyle(color: Colors.white,fontSize: 18.0),
              )
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStartDate(),
              _buildEndDate(),
              SizedBox(height: 8.0),
              _buildDuration(),
              SizedBox(height: 8.0),
              _buildComment(),
            ],
          ),

        ),
      ),
    );
  }

  Widget _buildStartDate(){
    return DateTimePicker(
      labelText: 'Start',
      selectedDate: _startDate,
      selectedTime: _startTime,
      onSelectedDate: (date)=>setState(()=>_startDate=date),
      onSelectedTime: (time)=>setState(()=>_startTime=time),
    );
  }

  Widget _buildEndDate() {
    return DateTimePicker(
      labelText: 'End',
      selectedDate: _endDate,
      selectedTime: _endTime,
      onSelectedDate: (date) => setState(() => _endDate = date),
      onSelectedTime: (time) => setState(() => _endTime = time),
    );
  }

  Widget _buildDuration() {
    final currentEntry = _entryFromState();
    final durationFormatted = Format.hours(currentEntry.durInHour);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          'Duration: $durationFormatted',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildComment() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _comment),
      decoration: InputDecoration(
        labelText: 'Comment',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.black),
      maxLines: null,
      onChanged: (comment) => _comment = comment,
    );
  }
}
