import 'package:flutter/cupertino.dart';

class Tasks{
  Tasks({@required this.name,@required this.desc,@required this.docId});
  String name;
  String desc;
  String docId;

  factory Tasks.fromMap(Map<String,dynamic> data,String documentId){
    if(data==null){
      return null;
    }
    final String name=data['Task Name'];
    final String desc=data['desc'];
    return Tasks(name: name, desc: desc, docId: documentId);
  }


  Map<String,dynamic> toMap(){
    return {
      'Task Name':name,
      'desc':desc
    };
  }


}