import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_schedule_app/app/sign_in/email_sign_in.dart';
import 'package:my_schedule_app/app/sign_in/sign_in_button.dart';

import '../services/auth.dart';



class SignInPage extends StatefulWidget {

  SignInPage({@required this.auth});
  final AuthBase auth;

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading=false;
  Future<void> _signInAnonymously(BuildContext context) async{
    try{
      setState(()=>_isLoading=true);
      await widget.auth.signInAn();
      Fluttertoast.showToast(msg: 'Sign In Successful',backgroundColor: Colors.indigo,textColor: Colors.white);
    }
    catch(e){
      print(e.toString());
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text('ERROR'),
              content: Text(e.toString()),
              actions: [
                FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                      'OK'
                  ),
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

  Future<void> _signInWithGoogle(BuildContext context) async{
    try{
      setState(()=>_isLoading=true);
      await widget.auth.signInWithGoogle();
      Fluttertoast.showToast(msg: 'Sign In Successful',backgroundColor: Colors.indigo,textColor: Colors.white);
    }
    catch(e){
      print(e.toString());
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text('ERROR'),
              content: Text(e.toString()),
              actions: [
                FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                      'OK'
                  ),
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

  void _signInWithEmail(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (context)=>EmailSignInPage(auth: widget.auth),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        title: Text('Schedule App',textAlign: TextAlign.center),
        elevation: 100.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.white70,
    );
  }

  Widget _buildContent(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 50.0,
            child: _builHeader(),
          ),
          SizedBox(
            height: 32.0,
          ),
          SignInButton(
            text: 'Sign In With Google',
            textColor: Colors.white,
            color: Colors.red[700],
            onPressed:()=> _signInWithGoogle(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Sign In with Email',
            textColor: Colors.white,
            color: Colors.green[800],
            onPressed:()=> _signInWithEmail(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'Or',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Go Anonymous',
            textColor: Colors.black,
            color: Colors.yellow[400],
            onPressed:()=> _signInAnonymously(context),
          ),
        ],
      ),
    );
  }
  Widget _builHeader(){
    if(_isLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    else{
      return Text(
        'SignIn',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 50.0,
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }
}
