import 'package:flutter/cupertino.dart';

class Entry{
  Entry({
    @required this.id,
    @required this.taskId,
    @required this.start,
    @required this.end,
    this.comment
  });

  String id;
  String taskId;
  DateTime start;
  DateTime end;
  String comment;

  double get durInHour=>end.difference(start).inMinutes.toDouble()/60.0;

  factory Entry.fromMap(Map<dynamic,dynamic>value,String id){
    final int startMilli=value['start'];
    final int endMilli=value['end'];
    return Entry(id: id, taskId: value['taskId'], start: DateTime.fromMillisecondsSinceEpoch(startMilli), end: DateTime.fromMillisecondsSinceEpoch(endMilli));
  }

  Map<String,dynamic> toMap(){
    return <String,dynamic>{
      'taskId':taskId,
      'start':start.millisecondsSinceEpoch,
      'end':end.millisecondsSinceEpoch,
      'comment':comment,
    };
  }
}