import 'package:flutter/material.dart';

enum TabItem{task,entries,account}


class TabItemData{
  const TabItemData(@required this.title,@required this.iconData);

  final String title;
  final IconData iconData;

  static const Map<TabItem,TabItemData> allTabs={
    TabItem.task:TabItemData('Tasks', Icons.account_tree),
    TabItem.entries:TabItemData('Meet', Icons.switch_video),
    TabItem.account:TabItemData('Account', Icons.person),
  };
}
