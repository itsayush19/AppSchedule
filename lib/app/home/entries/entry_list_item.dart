import 'package:flutter/material.dart';
import 'package:my_schedule_app/app/home/models/entry.dart';
import 'package:my_schedule_app/app/home/models/tasks.dart';

import 'format.dart';


class EntryListItem extends StatelessWidget {
  const EntryListItem({
    @required this.entry,
    @required this.task,
    @required this.onTap,
  });

  final Entry entry;
  final Tasks task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    print(entry.id);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _buildContents(context),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final dayOfWeek = Format.dayOfWeek(entry.start);
    final startDate = Format.date(entry.start);
    final startTime = TimeOfDay.fromDateTime(entry.start).format(context);
    final endTime = TimeOfDay.fromDateTime(entry.end).format(context);
    final durationFormatted = Format.hours(entry.durInHour);
    print(dayOfWeek);
    print(startTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text(dayOfWeek, style: TextStyle(fontSize: 18.0, color: Colors.grey)),
          SizedBox(width: 15.0),
          Text(startDate, style: TextStyle(fontSize: 18.0)),
        ]),
        Row(children: <Widget>[
          Text('$startTime - $endTime', style: TextStyle(fontSize: 16.0)),
          Expanded(child: Container()),
          Text(durationFormatted, style: TextStyle(fontSize: 16.0)),
        ]),
        if (entry.comment!=null)
          Text(
            entry.comment,
            style: TextStyle(fontSize: 12.0),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
      ],
    );
  }
}

class DismissibleEntryListItem extends StatelessWidget {
  const DismissibleEntryListItem({
    this.key,
    this.entry,
    this.task,
    this.onDismissed,
    this.onTap,
  });

  final Key key;
  final Entry entry;
  final Tasks task;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed(),
      child: EntryListItem(
        entry: entry,
        task: task,
        onTap: onTap,
      ),
    );
  }
}
