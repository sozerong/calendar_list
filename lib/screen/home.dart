import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniproject/component/list_sheet.dart';

import '../component/bottom_sheet.dart';
import '../component/video_sheet.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime appBarSelectedDate = DateTime.now(); //

  String examName = '';          //추가 된 부분
  String examContent = '';       //
  DateTime? examDate;           //
  String dDayText = 'D+0'; //
  String examNameText = ''; // 시험 이름 추가
  String examContentText = ''; // 시험 내용 추가//


  void _showDatePicker(BuildContext context, bool isAppBar) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: isAppBar ? appBarSelectedDate : selectedDate, //수정 코드
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                if (isAppBar) {
                  appBarSelectedDate = newDate;  //수정
                } else {
                  selectedDate = newDate;   //수정
                }
                calculateDDay(); // D-Day 다시 계산   //수정
              });
            },
          ),
        );
      },
    );
  }
  void _showAppBarDatePicker(BuildContext context) {
    _showDatePicker(context, true);
  }

  void _showExamDatePicker(BuildContext context) {
    _showDatePicker(context, false);
    examDate = selectedDate; // 선택한 날짜를 examDate에 할당
    calculateDDay(); // D-Day 다시 계산
  }
  void _showExamDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('시험 정보 입력'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: '시험 이름'),
                onChanged: (text) {
                  setState(() {
                    examName = text;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: '시험 내용'),
                onChanged: (text) {
                  setState(() {
                    examContent = text;
                  });
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    _showExamDatePicker(context);
                  },
                  child: Row(
                    children: [
                      Text(
                        '선택한 날짜: ${formattedDate(selectedDate)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.calendar_today), // 달력 아이콘 추가
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      examDate = selectedDate;
                      calculateDDay(); //  수정 D-Day 다시 계산
                      Navigator.of(context).pop();
                    },
                    child: Text('저장'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      examName = '';
                      examContent = '';
                      examDate = null;
                      calculateDDay(); // 수정 D-Day 다시 계산
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    child: Text('삭제'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  void _editExamDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: examName);
    TextEditingController contentController = TextEditingController(text: examContent);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('시험 정보 확인'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: '시험 이름'),
                    onChanged: (text) {
                      setState(() {
                        examName = text;
                      });
                    },
                  ),
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(labelText: '시험 내용'),
                    onChanged: (text) {
                      setState(() {
                        examContent = text;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            examName = '';
                            examContent = '';
                            examDate = null;
                            dDayText = '';
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text('삭제'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // 시험 정보 수정 및 D-Day 계산
                          setState(() {
                            examName = nameController.text;
                            examContent = contentController.text;
                            examDate = selectedDate;
                            calculateDDay();
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text('수정'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          examDate = selectedDate;
                          calculateDDay();
                          Navigator.of(context).pop();
                          setState(() {
                            examName = nameController.text;
                            dDayText = dDayText;
                          });
                        },
                        child: Text('확인'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  void calculateDDay() {
    final now = DateTime.now();
    if (examDate != null) {
      final difference = examDate!.difference(appBarSelectedDate).inDays;
      if (difference > 0) {
        dDayText = 'D-$difference';
      } else {
        dDayText = 'D+${difference.abs()}';
      }
    } else {
      dDayText = 'D+0';
    }

    // 시험 이름 및 시험 내용 업데이트
    examNameText = examName;
    examContentText = examContent;
  }


  String formattedDate(DateTime dateTime) {
    return '${dateTime.year}년${dateTime.month}월${dateTime.day}일';
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            _showAppBarDatePicker(context);
          },
          child: Text(
            '${formattedDate(appBarSelectedDate)}', // AppBar에 표시되는 날짜
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      body: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
            },
            child: Image.asset(
              'asset/img/tmp6.jpeg',
              width: 350,
              height: 120,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  dDayText,
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _showExamDialog(context); // '버튼 1' 클릭 시 시험 정보 입력 다이얼로그 표시
                },
                child: Image.asset(
                  'asset/img/tmp2.jpg',
                  width: 120,
                  height: 120,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isDismissible: true,
                    builder: (_) => SBottomSheet(
                      selectedDate: selectedDate,
                    ),
                  );
                  // 버튼 클릭 시 수행할 작업
                },
                child: Image.asset(
                  'asset/img/tmp3.jpg',
                  width: 120,
                  height: 120,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isDismissible: true,
                    builder: (_) => ListSheet(
                      selectedDate: selectedDate,
                    ),
                  );
                },
                child: Image.asset(
                  'asset/img/tmp4.jpg',
                  width: 120,
                  height: 120,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _editExamDialog(context);
                  },
                child: Image.asset(
                  'asset/img/tmp7.jpg',
                  width: 140,
                  height: 140,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isDismissible: true,
                    builder: (_) => VideoSheet(),
                  );
                },
                child: Image.asset(
                  'asset/img/tmp5.jpg',
                  width: 160,
                  height: 160,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

