import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../database/drift_database.dart';
import 'card.dart';

class ListSheet extends StatefulWidget {
  final DateTime selectedDate;

  const ListSheet({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  _ListSheetState createState() => _ListSheetState();
}

class _ListSheetState extends State<ListSheet> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: StreamBuilder<List<Schedule>>(
          stream: GetIt.I<LocalDatabase>().watchSchedules(widget.selectedDate),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final schedule = snapshot.data![index];
                return Dismissible(
                  key: ObjectKey(schedule.id),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    GetIt.I<LocalDatabase>().removeSchedule(schedule.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8.0,
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: SCard(
                      startTime: schedule.startTime,
                      endTime: schedule.endTime,
                      content: schedule.content,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
