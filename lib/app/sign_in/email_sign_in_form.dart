import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_schedule_app/app/services/auth.dart';
import 'package:my_schedule_app/app/sign_in/email_sign_in_button.dart';

enum EmailSignInFormType{
  signIn,register
}

class EmailSignInForm extends StatefulWidget {
  EmailSignInForm({@required this.auth});
  AuthBase auth;
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController emailController= TextEditingController();
  final TextEditingController passwordController= TextEditingController();

  String get _email=>emailController.text;
  String get _password=>passwordController.text;
  EmailSignInFormType _formType=EmailSignInFormType.signIn;

  void _toggleFormType(){
    setState(() {
      _formType=_formType==EmailSignInFormType.signIn?
          EmailSignInFormType.register:EmailSignInFormType.signIn;
    });
    emailController.clear();
    passwordController.clear();
  }

  void _submit() async{
    try{
      if(_formType==EmailSignInFormType.signIn){
        await widget.auth.signInWithEmail(_email, _password);
        Fluttertoast.showToast(msg: 'Sign In Successful',backgroundColor: Colors.indigo,textColor: Colors.white);
      }
      else{
        await widget.auth.createUserInWithEmail(_email, _password);
        Fluttertoast.showToast(msg: 'Sign Up Successful',backgroundColor: Colors.indigo,textColor: Colors.white);
      }

      Navigator.pop(context);
    }catch(e){
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
  }

  List<Widget> _buildChildren(){
    bool enableButton= _email.isNotEmpty && _password.isNotEmpty;

    String primaryText= _formType==EmailSignInFormType.signIn ?
        'Sign In' : 'Create an Account';
    String secondaryText=_formType==EmailSignInFormType.signIn ?
        'Need an account? Register!' : 'Have an Account? SignIn';
    return [
      TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: 'Email',
        ),
        textInputAction: TextInputAction.next,
        onChanged: (email)=>_updateState(),
      ),
      SizedBox(
        height: 8.0,
      ),
      TextField(
        controller: passwordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        textInputAction: TextInputAction.done,
        onChanged: (password){
          if(password.length>=6){
            _updateState();
          }
        },
      ),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        text:primaryText,
        onPressed: enableButton ? _submit:null,
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
          onPressed: _toggleFormType,
          child: Text(
              secondaryText,
            style: TextStyle(
              color:Colors.black,
              fontSize: 15.0,
            ),
          ),
      )
    ];
  }
  void _updateState(){
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
