import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_schedule_app/app/services/auth.dart';
import 'package:my_schedule_app/app/sign_in/email_sign_in_form.dart';

class EmailSignInPage extends StatelessWidget {
  EmailSignInPage({@required this.auth});
  AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        title: Text('Sign In',textAlign: TextAlign.center),
        elevation: 100.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          child: EmailSignInForm(auth: auth),
        ),
      ),
      backgroundColor: Colors.white70,
    );
  }
}