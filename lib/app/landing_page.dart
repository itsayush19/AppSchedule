import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_schedule_app/app/home/entries/home_scaffold.dart';
import 'package:my_schedule_app/app/home/home_activity.dart';
import 'package:my_schedule_app/app/services/auth.dart';
import 'package:my_schedule_app/app/home/tasks/home_page.dart';
import 'package:my_schedule_app/app/services/database.dart';
import 'package:my_schedule_app/app/sign_in/sign_in_page.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  LandingPage({@required this.auth});
  final AuthBase auth;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.active){
          MyUser user=snapshot.data;
          if(user==null){
            return SignInPage(
              auth: auth,
            );
          }
          if(user!=null){
            return Provider<Database>(
              create: (_)=>FirestoreDatabase(uid: user.uid),
              child: HomeActivity(auth: auth),
            );

            return HomePage(
              auth: auth,
            );
          }
        }
        else{
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            )
          );
        }
      },
    );
  }
}
