import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_schedule_app/app/home/models/tasks.dart';
import 'package:my_schedule_app/app/services/database.dart';
import 'package:provider/provider.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key key,@required this.database,this.task }) : super(key: key);
  final Tasks task;
  final Database database;
  static Future<void> show(BuildContext context,Database dat,{Tasks task}){
    Database database=dat;
    Navigator.of(context,rootNavigator: true).push(
        CupertinoPageRoute(
        builder: (context)=>AddTask(database: database,task: task),
        fullscreenDialog: false,
      )
    );
  }

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey=GlobalKey<FormState>();

  bool _isLoading=false;
  String _name;
  String _des;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.task!=null){
      _name=widget.task.name;
      _des=widget.task.desc;
    }
  }

  bool _valAndSave(){
    final form=_formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async{
    if(_valAndSave()){
      try {
        final tasks=await widget.database.readTask().first;
        final allNames=tasks.map((event) => event.name).toList();
        if(widget.task!=null){
          print(widget.task.docId);
          allNames.remove(widget.task.name);
        }
        if(allNames.contains(_name)){
          Fluttertoast.showToast(msg: 'Already exist');
        } else{
          String _id=widget.task!=null?widget.task.docId:DateTime.now().toIso8601String();
          final _task=Tasks(name: _name, desc: _des,docId: _id).toMap();
          await widget.database.createTask(_task,_id);
          setState(()=>_isLoading=true);
          Navigator.pop(context);
        }
      } on PlatformException catch (e) {
        showDialog(
            context: context,
            builder: (context){
              return CupertinoAlertDialog(
                title: Text('Error'),
                content: Text(e.message),
                actions: [
                  RaisedButton(
                      onPressed:(){
                        Navigator.pop(context);
                      },
                      child: Text('Ok'),
                  )
                ],
              );
            }
        );
      }
      finally{
        setState(()=>_isLoading=false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.task!=null? 'Edit Task':'Add Task'),
        elevation: 50.0,
        actions: [
          FlatButton(
              onPressed: _submit,
              child: Text(
                     'Save',
                style: TextStyle(color: Colors.white,fontSize: 18),
              ),
          )
        ],
      ),
      backgroundColor: Colors.white70,
      body: _buildContent(),
    );
  }
  Widget _buildContent(){
    if(_isLoading==false){
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: _buildForm(),
            ),
          ),
        ),
      );
    }
    else{
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
  Widget _buildForm(){
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: _buildChildren(),
        )
    );
  }
  List<Widget> _buildChildren(){
    return [
      TextFormField(
        keyboardType: TextInputType.text,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: 'Task Name',
        ),
        textInputAction: TextInputAction.done,
        onSaved: (value)=>_name=value,
        validator: (value)=>value.isNotEmpty?null:'Enter Name',
        initialValue: _name,
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: 'Description',
        ),
        textInputAction: TextInputAction.done,
        onSaved: (value)=>_des=value,
        validator: (value)=>value.isNotEmpty?null:'Enter Description',
        initialValue: _des,
      ),
    ];
  }
}
