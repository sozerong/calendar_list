import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DDayScreen extends StatefulWidget {
  @override
  _DDayScreenState createState() => _DDayScreenState();
}

class _DDayScreenState extends State<DDayScreen> {
  DateTime selectedDate = DateTime.now();

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: selectedDate,
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                selectedDate = newDate;
              });
            },
          ),
        );
      },
    );
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
              ),
              TextField(
                decoration: InputDecoration(labelText: '시험 내용'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                // 시험 정보 저장 또는 다른 작업 수행
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('저장'),
            ),
          ],
        );
      },
    );
  }

  String formattedDate(DateTime dateTime) {
    return '${dateTime.year}년${dateTime.month}월${dateTime.day}일';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showDatePicker(context);
          },
          child: Center(
            child: Text(
              '${formattedDate(selectedDate)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/img/tmp1.png'),
                fit: BoxFit.cover,
              ),
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
                  'asset/img/tmp1.png',
                  width: 70,
                  height: 150,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // '버튼 2' 클릭 시 수행할 작업 추가
                },
                child: Image.asset(
                  'asset/img/tmp1.png',
                  width: 70,
                  height: 150,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // '버튼 3' 클릭 시 수행할 작업 추가
                },
                child: Image.asset(
                  'asset/img/tmp1.png',
                  width: 160,
                  height: 150,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  // '버튼 4' 클릭 시 수행할 작업 추가
                },
                child: Image.asset(
                  'asset/img/tmp1.png', //
                  width: 200,
                  height: 200,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // '버튼 5' 클릭 시 수행할 작업 추가
                },
                child: Image.asset(
                  'asset/img/tmp1.png', //
                  width: 200,
                  height: 200,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}