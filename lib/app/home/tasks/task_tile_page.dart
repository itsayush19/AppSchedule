import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_schedule_app/app/home/models/tasks.dart';

class TaskTile extends StatelessWidget {
  TaskTile({@required this.task,@required this.onTap,@required this.onLongPress});
  final Tasks task;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.name),
      onTap: onTap,
      trailing: Icon(Icons.chevron_right),
      onLongPress: onLongPress,
    );
  }
}
