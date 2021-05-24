import 'package:flutter/material.dart';

import 'package:my_schedule_app/app/sign_in/custom_button.dart';

class SignInButton extends CostumedButton{
  SignInButton({
    String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  }) : super(
    child: Text(
      text,
      style: TextStyle(color: textColor, fontSize: 15.0),
    ),
    color: color,
    onPressed: onPressed,
    h: 70.0,
  );
}