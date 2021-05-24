import 'package:flutter/cupertino.dart';
import 'package:my_schedule_app/app/home/account.dart';
import 'package:my_schedule_app/app/home/entries/home_scaffold.dart';
import 'package:my_schedule_app/app/home/meet_tab.dart';
import 'package:my_schedule_app/app/home/tab_item.dart';
import 'package:my_schedule_app/app/home/tasks/home_page.dart';
import 'package:my_schedule_app/app/services/auth.dart';

class HomeActivity extends StatefulWidget {
  const HomeActivity({Key key,@required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {
  TabItem _currentTab=TabItem.task;

  Map<TabItem,WidgetBuilder> get widgetBuilder{
    return{
      TabItem.task:(_)=>HomePage(auth: widget.auth),
      TabItem.entries:(_)=>MeetTab(),
      TabItem.account:(_)=>Account(auth: widget.auth),
    };
  }

  final  Map<TabItem,GlobalKey<NavigatorState>> navigatorKeys={
    TabItem.task:GlobalKey<NavigatorState>(),
    TabItem.entries:GlobalKey<NavigatorState>(),
    TabItem.account:GlobalKey<NavigatorState>(),
  };

  void _onSelect(TabItem tabItem){
    setState(() {
      _currentTab=tabItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async=>await navigatorKeys[_currentTab].currentState.maybePop(),
      child:
        HomeScaffold(
            currentItem: _currentTab,
            onPressed: _onSelect,
            widgetBuilder: widgetBuilder,
            navigatorKeys: navigatorKeys,
        ),
    );
  }
}
