import 'package:flutter/material.dart';

import 'package:miniproject/component/bottom_sheet.dart';
import 'package:miniproject/component/main_cal.dart';
import 'package:miniproject/component/card.dart';
import 'package:miniproject/component/td_banner.dart';
import 'package:get_it/get_it.dart';
import 'package:miniproject/database/drift_database.dart';

class CalScreen extends StatefulWidget {
  const CalScreen ({Key? key}) : super(key: key);

  @override
  State<CalScreen> createState() => _CalScreen();
}

class _CalScreen extends State<CalScreen>{
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [
            MainCal(
              selectedDate: selectedDate,
              onDaySelected: onDaySelected,
            ),
            SizedBox(height: 8.0),
            StreamBuilder<List<Schedule>>(
                stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
                builder: (context, snapshot) {
                  return TodayBanner(
                    selectedDate: selectedDate,
                    count: snapshot.data?.length ?? 0,
                  );
                }),
            SizedBox(height: 8.0),
            Expanded(child: StreamBuilder<List<Schedule>>(
              stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate), // widget.selectedDate 사용
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
                            bottom: 8.0, left: 8.0, right: 8.0),
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
          ],
        ),
        ),
      );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate){
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}

