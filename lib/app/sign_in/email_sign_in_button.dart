import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_schedule_app/app/sign_in/custom_button.dart';

class FormSubmitButton extends CostumedButton{
  FormSubmitButton({
    @required String text,
    @required VoidCallback onPressed,
  }) : super(
    child: Text(
      text,
      style: TextStyle(color:Colors.white , fontSize: 15.0),
    ),
    color: Colors.indigo,
    onPressed: onPressed,
    h: 50.0,
  );
}