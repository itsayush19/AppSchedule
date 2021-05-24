import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_schedule_app/app/home/entries/entries_page.dart';
import 'package:my_schedule_app/app/home/models/tasks.dart';
import 'package:my_schedule_app/app/home/tasks/add_tasks.dart';
import 'package:my_schedule_app/app/home/tasks/list_builder.dart';
import 'package:my_schedule_app/app/home/tasks/task_tile_page.dart';
import 'package:my_schedule_app/app/services/auth.dart';
import 'package:my_schedule_app/app/services/database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({@required this.auth});
  final AuthBase auth;
  @override
  Widget build(BuildContext context) {
    print('build');
    /*
    Future<void> _creatTask(BuildContext context) async {
      //final Database database=FirestoreDatabase(uid:auth.getUid());
      try {
        final database=Provider.of<Database>(context,listen: false);
        await database.createTask(Tasks(name: 'Code', desc: 'from leetcode').toMap());
      } catch (e) {
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
                      child: Text('OK')
                  )
                ],
              );
            }
        );
      }
    }
    
     */
    return Scaffold(
      appBar: AppBar(
        elevation: 50.0,
        centerTitle: true,
        title: Text('Home', textAlign: TextAlign.center),
        actions: <Widget>[
          IconButton(
              onPressed:() => AddTask.show(context,Provider.of<Database>(context,listen: false)),
              icon: Icon(Icons.add)
          ),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Future<void> _delete(BuildContext context,Tasks task){
    try {
      final database=Provider.of<Database>(context,listen: false);
      database.deleteTask(task);
    } on PlatformException catch (e) {
      Fluttertoast.showToast(
        msg: e.message,
        backgroundColor: Colors.indigo,
        textColor: Colors.white,
      );
    }
  }

  Widget _buildContent(BuildContext context){
    final database=Provider.of<Database>(context);

    return Stack(
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
        StreamBuilder<List<Tasks>>(
          stream: database.readTask(),
          builder:(context,snapshot){
            return ListBuilder<Tasks>(
              snapshot: snapshot,
              itemListBuilder: (context,task)=>Dismissible(
                  key: Key('delete-${task.docId}'),
                  background: Container(color: Colors.red),
                  direction: DismissDirection.endToStart,
                  onDismissed:(direction)=> _delete(context,task),
                  child:TaskTile(
                    task: task,
                    onTap: ()=>EntriesPage.show(context,task: task),
                    onLongPress: ()=>_longPress(context,task),
                  )
              ),
            );
          },
        )
      ],
    );



    /*
    return StreamBuilder<List<Tasks>>(
        stream: database.readTask(),
        builder:(context,snapshot){
          return ListBuilder<Tasks>(
            snapshot: snapshot,
            itemListBuilder: (context,task)=>Dismissible(
                key: Key('delete-${task.docId}'),
                background: Container(color: Colors.red),
                direction: DismissDirection.endToStart,
                onDismissed:(direction)=> _delete(context,task),
                child:TaskTile(
                  task: task,
                  onTap: ()=>EntriesPage.show(context,task: task),
                  onLongPress: ()=>_longPress(context,task),
                )
            ),
          );
        },
    );
    */
  }
  Future<dynamic> _longPress(BuildContext context,Tasks task){
    return showDialog(
        context: context,
        builder: (context){
          return CupertinoAlertDialog(
            title: Text('Description',style: TextStyle(color: Colors.indigo),textAlign: TextAlign.center),
            content: Text(task.desc),
            actions: [
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('OK',style: TextStyle(color: Colors.indigo),)
              )
            ],
          );
        });
  }

}
