import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_schedule_app/app/home/entries/add_entry.dart';
import 'package:my_schedule_app/app/home/entries/entry_list_item.dart';
import 'package:my_schedule_app/app/home/models/entry.dart';
import 'package:my_schedule_app/app/home/models/tasks.dart';
import 'package:my_schedule_app/app/home/tasks/add_tasks.dart';
import 'package:my_schedule_app/app/home/tasks/empty_task.dart';
import 'package:my_schedule_app/app/home/tasks/list_builder.dart';
import 'package:my_schedule_app/app/services/database.dart';
import 'package:provider/provider.dart';

class EntriesPage extends StatelessWidget {
  const EntriesPage({Key key,@required this.database,@required this.task}) : super(key: key);

  final Database database;
  final Tasks task;

  static Future<void> show(BuildContext context,{Tasks task}){
    Database database=Provider.of<Database>(context,listen: false);
    Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context)=>EntriesPage(database: database,task: task),
          fullscreenDialog: false,
        )
    );
  }

  Future<void> _delete(Entry entry) async{
    try {
      await database.deleteEntry(entry);
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg:e.message,backgroundColor: Colors.indigo,textColor: Colors.white );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(task.name),
        elevation: 50.0,
        actions: [
          IconButton(
              onPressed:  ()=>AddEntry.show(context, database, task),
              icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed:  ()=>AddTask.show(context,database,task: task),
            icon: Icon(Icons.create),
          ),
        ],
      ),
      body: _buildContent(context,task),
      /*
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>AddEntry.show(context, database, task)
          //database.createEntry(Entry(id: 'entry_abc', taskId: task.docId, start: DateTime.now(), end: DateTime.now().add(const Duration(minutes: 2))).toMap(),DateTime.now().toIso8601String());
      ),

       */
    );
  }
  Widget _buildContent(BuildContext context,Tasks task){
    return StreamBuilder<List<Entry>>(
      stream: database.readEntry(task: task),
      builder: (context,snapshot){

        return ListBuilder<Entry>(
          snapshot: snapshot,
          itemListBuilder: (context,entry){

             return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              task: task,
              onDismissed:()=> _delete(entry),
              onTap: ()=>AddEntry.show(context, database, task,entry: entry),
            );
          },
        );
      },
    );
  }
}
