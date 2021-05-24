import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:uuid/uuid.dart';


class MeetTab extends StatefulWidget {
  const MeetTab({Key key}) : super(key: key);

  @override
  _MeetTabState createState() => _MeetTabState();
}

class _MeetTabState extends State<MeetTab> {
  String code;
  String c;
  String name;
  void _gCode(){
    setState(() {
      c=Uuid().v1().substring(0,6);
    });
    showDialog(
        context: context,
        builder: (context){
          return CupertinoAlertDialog(
            title: Text('Room Code',style: TextStyle(color: Colors.indigo)),
            content: Text(c +' : share this code with others to join',style: TextStyle(fontSize: 20.0)),
            actions: [
              FlatButton(
                  onPressed:()=>Navigator.pop(context),
                  child: Text('Ok')
              )
            ],
          );
        }
    );
  }




  @override
  Widget build(BuildContext context) {
    print(code);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Meeting'),
        elevation: 50.0,
        actions: [
          FlatButton(
            child: Text('Create Code',
                style: TextStyle(fontSize: 18.0, color: Colors.white)),
            onPressed:_gCode,
          )
        ],
      ),
      body: _buildContent(),
    );
  }
  Widget _buildContent(){
    return Stack(
      children: [
        ClipPath(
          clipper: OvalBottomBorderClipper(),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height/2.5,
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(.9),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              margin: EdgeInsets.only(
                top: 13,
                bottom: 130,
              ),
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.indigo.withOpacity(.01),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: 'Enter Code',
                      ),
                      onChanged:(value){
                        setState(() {
                          code=value;
                        });
                      } ,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                      ),
                      onChanged:(value){setState(() {
                        name=value;
                      });} ,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 50.0,
                      child: RaisedButton(
                        onPressed: code!=null?_join:_showAlert,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            )
                        ),
                        child: Text('Join Meeting',style: TextStyle(color: Colors.white)),
                        color: Colors.indigo,
                      ),
                    )
                  ],
                ),
              ),
            )
          ),
        )
      ],
    );
  }

  void _showAlert(){
    showDialog(
        context: context,
        builder: (context){
          return CupertinoAlertDialog(
            title: Text('Empty Code',style: TextStyle(color: Colors.indigo)),
            content: Text('Generate Code First'),
            actions: [
              FlatButton(
                  onPressed:(){
                    Navigator.pop(context);
                  },
                  child: Text('OK')
              )
            ],
          );
        }
    );
  }


  Future<void> _join() async{
    try{
      Map<FeatureFlagEnum,bool> featureFlags={
        FeatureFlagEnum.WELCOME_PAGE_ENABLED:false,
      };
      featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED]=false;

      var options=JitsiMeetingOptions()
        ..room=code
        ..userDisplayName=name!=null?name:''
        ..audioMuted=false
        ..videoMuted=false
        ..featureFlags.addAll(featureFlags);

      await JitsiMeet.joinMeeting(options);
    }
    on PlatformException catch(e){
      showDialog(
          context: context,
          builder: (context){
            return CupertinoAlertDialog(
              title: Text('ERROR',style: TextStyle(color: Colors.indigo)),
              content: Text(e.message),
              actions: [
                FlatButton(
                    onPressed:(){
                      Navigator.pop(context);
                    },
                    child: Text('OK')
                )
              ],
            );
          }
      );
    }
  }
}
