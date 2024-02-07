import 'package:flutter/material.dart';
import 'package:student_details_week_5/Screens/Widgets/add_student_widget.dart';
import 'package:student_details_week_5/Screens/Widgets/list_student_widget.dart';
import 'package:student_details_week_5/Screens/searchScreen.dart';
import 'package:student_details_week_5/db/functions/db_functions.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    getAllStudents();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("STUDENT LIST"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: SafeArea(
        child: Material(
          child: Column(
            children: [
              Expanded(
                child: ListStudentWidget(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddStudentWidget()),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
