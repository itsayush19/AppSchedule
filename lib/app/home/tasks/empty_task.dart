import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyTask extends StatelessWidget {
  const EmptyTask({
    Key key,
    this.title='Nothing in your Tasks',
    this.message='Add a new task',
  }) : super(key: key);

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: Colors.black54,fontSize: 32.0),
          ),
          Text(
            message,
            style: TextStyle(color: Colors.black54,fontSize: 16.0),
          )
        ],
      ),
    );
  }
}
