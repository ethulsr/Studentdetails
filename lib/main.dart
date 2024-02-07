import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:sqflite/sqflite.dart';
import 'package:student_details_week_5/Screens/screen_home.dart';

import 'package:student_details_week_5/db/functions/db_functions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await openDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Student Details",
      theme: ThemeData(primaryColor: Colors.black),
      home: ScreenHome(),
    );
  }
}
