import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_schedule_app/app/home/tab_item.dart';

class HomeScaffold extends StatelessWidget {
  const HomeScaffold({Key key,@required this.currentItem,@required this.onPressed,@required this.widgetBuilder,@required this.navigatorKeys}) : super(key: key);

  final TabItem currentItem;
  final ValueChanged<TabItem> onPressed;
  final Map<TabItem,WidgetBuilder> widgetBuilder;
  final  Map<TabItem,GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            _barItem(TabItem.task),
            _barItem(TabItem.entries),
            _barItem(TabItem.account),
          ],
          onTap: (index)=>onPressed(TabItem.values[index]),
        ),
      tabBuilder: (context,index){
          final item=TabItem.values[index];
          return CupertinoTabView(
            navigatorKey: navigatorKeys[index],
            builder: (context)=>widgetBuilder[item](context)
          );
      },
    );
  }
  BottomNavigationBarItem _barItem(TabItem tabItem){
    final itemData=TabItemData.allTabs[tabItem];
    final color= currentItem==tabItem? Colors.indigo:Colors.grey;
    return BottomNavigationBarItem(
      icon: Icon(itemData.iconData,color: color,),
      title: Text(itemData.title,style: TextStyle(color: color),),
    );
  }

}
