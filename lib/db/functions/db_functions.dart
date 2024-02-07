import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student_details_week_5/db/models/data_model.dart';

ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);
late Database _db;
bool isStudentListEmpty = true;

Future<void> openDB() async {
  try {
    _db = await openDatabase(
      'Student.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE student(id INTEGER PRIMARY KEY, name TEXT, age TEXT, class TEXT, address TEXT, image TEXT)');
      },
    );
  } catch (e) {
    print("Error opening database: $e");
  }
}

Future<void> addStudent(StudentModel value) async {
  try {
    await _db.rawInsert(
        'INSERT INTO student(name,age,class,address,image) VALUES(?,?,?,?,?)',
        [value.name, value.age, value.cls, value.address, value.img]);
    await getAllStudents();
  } catch (e) {
    print("Error adding student: $e");
  }
}

Future<void> getAllStudents() async {
  try {
    final _values = await _db.rawQuery('SELECT * FROM student');
    print(_values);
    studentListNotifier.value.clear();

    _values.forEach((map) {
      final student = StudentModel.fromMap(map);
      studentListNotifier.value.add(student);
    });

    isStudentListEmpty = studentListNotifier.value.isEmpty;
    studentListNotifier.notifyListeners(); // Notify listeners about the change
  } catch (e) {
    print("Error getting students: $e");
  }
}

Future<void> deleteStudent(int id) async {
  try {
    await _db.rawDelete('DELETE FROM student WHERE  id = ?', [id]);
    await getAllStudents();
  } catch (e) {
    print("Error deleting student: $e");
  }
}

Future<List<StudentModel>> searchStudents(String query) async {
  try {
    final db = await _db.database;
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT* FROM student WHERE name LIKE '%$query%'");
    return List.generate(maps.length, (i) {
      return StudentModel.fromMap(maps[i]);
    });
  } catch (e) {
    print("Error searching students: $e");
    return [];
  }
}

Future<void> updateStudent(
    int? id, String name, String age, String cls, String address) async {
  try {
    await _db.rawUpdate(
        'UPDATE student SET name = ?, age = ?, class = ?, address = ? WHERE id = ?',
        [name, age, cls, address, id]);
    await getAllStudents();
  } catch (e) {
    print("Error updating student: $e");
  }
}
