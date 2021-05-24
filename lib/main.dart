import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_schedule_app/app/services/auth.dart';
import 'package:my_schedule_app/app/landing_page.dart';
import 'package:my_schedule_app/app/sign_in/sign_in_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Schedule App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: LandingPage(
        auth: Auth(),
      ),
    );
  }
}