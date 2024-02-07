import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student_details_week_5/db/functions/db_functions.dart';
import 'package:student_details_week_5/db/models/data_model.dart';

class ListStudentWidget extends StatelessWidget {
  final String? imagePath;

  ListStudentWidget({this.imagePath, super.key});

  final _UpdatedNameController = TextEditingController();
  final _UpdatedAgeController = TextEditingController();
  final _UpdatedClassController = TextEditingController();
  final _UpdatedAddressController = TextEditingController();

  void populateFormFields(StudentModel student) {
    _UpdatedNameController.text = student.name;
    _UpdatedAgeController.text = student.age;
    _UpdatedClassController.text = student.cls;
    _UpdatedAddressController.text = student.address;
  }

  @override
  Widget build(BuildContext context) {
    getAllStudents();
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: studentListNotifier,
        builder:
            (BuildContext ctx, List<StudentModel> studentlist, Widget? child) {
          if (studentlist.isEmpty) {
            return Center(
              child: Text(
                'No Student is Available',
                style: TextStyle(fontSize: 20),
              ),
            );
          }
          return ListView.separated(
            itemBuilder: (ctx, index) {
              final data = studentlist[index];
              return Card(
                elevation: 4,
                shadowColor: Colors.black38,
                color: Colors.grey[300],
                child: ListTile(
                  onTap: () {
                    showModalBottomSheet(
                      context: ctx,
                      builder: (ctx1) {
                        return Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Container(
                            child: Column(
                              children: [
                                CloseButton(color: Colors.red),
                                Text(
                                  "Name: " + data.name,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "Age: " + data.age,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "Class: " + data.cls,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "Address: " + data.address,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(ctx)
                                            .pop(); // Close the bottom sheet
                                        populateFormFields(
                                            data); // Populate form fields with selected student data

                                        showModalBottomSheet(
                                          context: context,
                                          builder: (ctx) {
                                            return Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: ListView(
                                                  children: [
                                                    Center(
                                                      child: Title(
                                                        color: Colors.black,
                                                        child: Text(
                                                          "Edit Student details",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          _UpdatedNameController,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText: "Name",
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          _UpdatedAgeController,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText: "Age",
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          _UpdatedClassController,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText: "Class",
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          _UpdatedAddressController,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText: "Address",
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    ElevatedButton.icon(
                                                      onPressed: () async {
                                                        await updateStudent(
                                                          data.id,
                                                          _UpdatedNameController
                                                              .text,
                                                          _UpdatedAgeController
                                                              .text,
                                                          _UpdatedClassController
                                                              .text,
                                                          _UpdatedAddressController
                                                              .text,
                                                        );

                                                        _UpdatedNameController
                                                            .clear();
                                                        _UpdatedAgeController
                                                            .clear();
                                                        _UpdatedClassController
                                                            .clear();
                                                        _UpdatedAddressController
                                                            .clear();
                                                      },
                                                      icon: Icon(Icons.update),
                                                      label: Text(
                                                          "Update Details"),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Text('Edit'),
                                    ),
                                    SizedBox(width: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (data.id != null) {
                                          deleteStudent(data.id!);
                                          Navigator.of(ctx)
                                              .pop(); // Close the bottom sheet
                                        } else {
                                          print(
                                              "Student id is null. Unable to delete.");
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  title: Text(data.name),
                  leading: CircleAvatar(
                    backgroundImage: imagePath != null
                        ? FileImage(File(imagePath!)) as ImageProvider<Object>
                        : const NetworkImage(
                            'https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Image.png'),
                    radius: 20,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: ctx,
                            builder: (ctx) {
                              return AlertDialog(
                                title: Text("Delete Student record"),
                                content: Text("Do you want to Delete?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      if (data.id != null) {
                                        deleteStudent(data.id!);
                                      } else {
                                        print(
                                            "Student id is null. Unable to delete.");
                                      }
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Text("Yes"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Text("No"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red[700],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return const SizedBox(
                height: 5,
              );
            },
            itemCount: studentlist.length,
          );
        },
      ),
    );
  }
}
