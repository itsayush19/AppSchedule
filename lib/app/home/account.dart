import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_schedule_app/app/home/add_thought.dart';
import 'package:my_schedule_app/app/services/auth.dart';
import 'package:my_schedule_app/app/services/database.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  const Account({Key key, this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String _tht;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _read(context);
  }

  Future<void> _read(BuildContext context)async{
    Database database=Provider.of<Database>(context,listen: false);
    String s=await database.readThought();
    if(s.isNotEmpty){
      setState(() {
        _tht=s;
      });
    }
  }

  Future<void> _signOut(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Sign Out'),
          content: Text('Are you sure?'),
          actions: [
            FlatButton(
              onPressed: () async {
                try {
                  await widget.auth.signOut();
                  Fluttertoast.showToast(
                      msg: 'Signed out',
                      backgroundColor: Colors.indigo,
                      textColor: Colors.white);
                  Navigator.pop(context);
                } catch (e) {
                  print(e.toString());
                  Fluttertoast.showToast(
                      msg: e.toString(),
                      backgroundColor: Colors.indigo,
                      textColor: Colors.white);
                  Navigator.pop(context);
                }
              },
              child: Text("YES"),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("No"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _read(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 50.0,
        centerTitle: true,
        title: Text('Account', textAlign: TextAlign.center),
        actions: <Widget>[
          FlatButton(
            child: Text('Logout',
                style: TextStyle(fontSize: 18.0, color: Colors.white)),
            onPressed:()=>_signOut(context),
          )
        ],
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: OvalBottomBorderClipper(),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height/2.5,
              decoration: BoxDecoration(
                color: Colors.indigo
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Card(
                    elevation: 5.0,
                      child: Padding(
                        padding: EdgeInsets.all(50),
                        child: Text(_tht!=null?_tht:'ADD YOUR THOUGHT',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 30.0,color: Colors.black),
                        ),
                        /*
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        )
                    ),
                    onPressed: ()=>_add(context),
                    child: Text('add'),
                  ),

                   */
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.indigo.withOpacity(.01)
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                RaisedButton(
                  color: Colors.indigo,
                  elevation: 50.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )
                  ),
                  onPressed: (){
                    AddThought.show(context, Provider.of<Database>(context,listen: false));
                    },
                  child: Text('Update',style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
