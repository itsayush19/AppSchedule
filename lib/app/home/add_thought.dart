import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_schedule_app/app/services/database.dart';

class AddThought extends StatefulWidget {
  const AddThought({Key key, this.database}) : super(key: key);
  final Database database;

  static Future<void> show(BuildContext context,Database dat){
    Navigator.of(context,rootNavigator: true).push(
      CupertinoPageRoute(
        builder: (context)=>AddThought(database: dat,),
        fullscreenDialog: false
      )
    );
  }


  @override
  _AddThoughtState createState() => _AddThoughtState();
}

class _AddThoughtState extends State<AddThought> {
  final _formKey=GlobalKey<FormState>();
  String _tht;


  Future<void> _add() async{
    Map<String,dynamic> data={
      'thought':_tht,
    };
    await widget.database.createThought(data);
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
        Map<String,dynamic> data={
          'thought':_tht,
        };
        await widget.database.createThought(data);
        Navigator.pop(context);
      } on PlatformException catch (e) {
        showDialog(
            context: context,
            builder: (context){
              return CupertinoAlertDialog(
                title: Text('Error',style: TextStyle(color: Colors.indigo)),
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
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add thought'),
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
    );;
  }
  Widget _buildContent(){
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
    return[
      TextFormField(
        keyboardType: TextInputType.text,
        maxLength: 50,
        decoration: InputDecoration(
          labelText: 'Add your thought',
          labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
        style: TextStyle(fontSize: 20.0, color: Colors.black),
        maxLines: null,
        onSaved: (value)=>_tht=value,
        validator: (value)=>value.isNotEmpty?null:'Enter Thought',
      )
    ];
  }
}
