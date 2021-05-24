import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateCode extends StatefulWidget {
  const CreateCode({Key key}) : super(key: key);

  static Future<void> show(BuildContext context){
    Navigator.of(context,rootNavigator: true).push(
        CupertinoPageRoute(
          builder: (context)=>CreateCode(),
          fullscreenDialog: false,
        )
    );
  }

  @override
  _CreateCodeState createState() => _CreateCodeState();
}

class _CreateCodeState extends State<CreateCode> {
  String _code;

  void _gCode(){
    setState(() {
      _code=Uuid().v1().substring(0,6);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Create Meeting'),
        elevation: 50.0,
      ),
      backgroundColor: Colors.white70,
      body: _buildContent(),
    );
  }

  Widget _buildContent(){
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Code :',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  _code!=null?_code:'',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              onPressed:_gCode,
              child: Text('Create Code'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )
              ),
              color: Colors.indigo,
              elevation: 50.0,
            )
          ],
        )
      ),
    );
  }
}
