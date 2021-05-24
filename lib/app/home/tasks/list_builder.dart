 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_schedule_app/app/home/tasks/empty_task.dart';

typedef ItemListBuilder<T> = Widget Function(BuildContext context,T item);

class ListBuilder<T> extends StatelessWidget {
  const ListBuilder({Key key, this.snapshot, this.itemListBuilder}) : super(key: key);

  final AsyncSnapshot<List<T>> snapshot;
  final ItemListBuilder<T> itemListBuilder;

  @override
  Widget build(BuildContext context) {
    if(snapshot.hasData){
      final List<T> items=snapshot.data;
      if(items.isEmpty){
        return EmptyTask();
      }
      else{
        return _buildList(items);
      }
    }
    else if(snapshot.hasError){
      return EmptyTask(
        title: 'Something went wrong',
        message: 'can\'t show tasks'
      );
    }
    return Center(child: CircularProgressIndicator(),);
  }
  Widget _buildList(List<T> items){
    return ListView.separated(
      itemCount: items.length+2,
      separatorBuilder: (context,index)=>Divider(height: 0.5),
      itemBuilder: (context,index){
        if(index==0||index==items.length+1){
          return Container();
        }
          return itemListBuilder(context,items[index-1]);
        },

    );
  }
}
