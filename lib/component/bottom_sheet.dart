import 'package:miniproject/component/text_field.dart';
import 'package:miniproject/database/drift_database.dart';
import 'package:miniproject/model/schedule.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';


class SBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  const SBottomSheet({
    Key? key,
    required this.selectedDate
  }) : super (key: key);

  @override
  State<SBottomSheet> createState() =>_SBottomSheet();
}

class _SBottomSheet extends State<SBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;


  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom /2;

    return Form(
      key: formKey,
      child: Expanded(
        child: Container(
          height: MediaQuery.of(context).size.height +bottomInset,
          color: Colors.white,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 8,
                right: 8,
                top: 3,
                bottom: bottomInset,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTF(
                          label: '시작시간',
                          isTime: true,
                          onSaved: (String? val) {
                            startTime = int.parse(val!);
                          },
                          validator: timeValidator,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: CustomTF(
                          label: '마감시간',
                          isTime: true,
                          onSaved: (String? val) {
                            endTime = int.parse(val!);
                          },
                          validator: timeValidator,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Expanded(
                    child: CustomTF(
                      label: '내용',
                      isTime: false,
                      onSaved: (String? val) {
                        content = val;
                      },
                      validator: contentValidator,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => onSavePressed(context),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      child: Text('저장'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? timeValidator(String? val) {
    if (val == null) {
      return '값을 입력해주세요';
    }

    int? number;

    try {
      number = int.parse(val);
    } catch (e) {
      return '숫자를 입력해주세요';
    }

    if (number < 0 || number > 24) {
      return '0시부터 24시 사이를 입력해주세요';
    }

    return null;
  }

  String? contentValidator(String? val) {
    if (val == null || val.length == 0) {
      return '값을 입력해주세요';
    }

    return null;
  }

  void onSavePressed(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      await GetIt.I<LocalDatabase>().createSchedule(
        SchedulesCompanion(
          startTime: Value(startTime!),
          endTime: Value(endTime!),
          content: Value(content!),
          date: Value(widget.selectedDate), // widget.selectedDate 사용
        ),
      );

      Navigator.of(context).pop();
    }
  }
}
