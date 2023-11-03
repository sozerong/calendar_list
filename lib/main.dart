import 'package:flutter/material.dart';
import 'package:miniproject/database/drift_database.dart';
import 'package:miniproject/screen/home.dart';
import 'package:miniproject/screen/root.dart';
import 'package:get_it/get_it.dart';

void main() {

  final database = LocalDatabase();
  GetIt.I.registerSingleton<LocalDatabase>(database);

  runApp(
    MaterialApp(
      home: RootScreen(),
    ),
  );
}
