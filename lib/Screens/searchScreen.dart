import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student_details_week_5/db/functions/db_functions.dart';
import 'package:student_details_week_5/db/models/data_model.dart';

final TextEditingController _SearchController = TextEditingController();

class SearchScreen extends StatefulWidget {
  final String? imagePath;

  const SearchScreen({Key? key, this.imagePath}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

final TextEditingController _updatedNameController = TextEditingController();
final TextEditingController _updatedAgeController = TextEditingController();
final TextEditingController _updatedClassController = TextEditingController();
final TextEditingController _updatedAddressController = TextEditingController();

class _SearchScreenState extends State<SearchScreen> {
  List<StudentModel> studentlist = [];

  void _searchstudent(String query) async {
    final results = await searchStudents(query);
    setState(() {
      studentlist = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Student"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _SearchController,
                  onChanged: (query) {
                    _searchstudent(query);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                    labelText: "Enter Student Name",
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: studentlist.length,
                  itemBuilder: (context, index) {
                    final student = studentlist[index];
                    return Card(
                      elevation: 4,
                      shadowColor: Colors.black38,
                      color: Colors.grey[300],
                      child: ListTile(
                        title: Text(student.name),
                        leading: CircleAvatar(
                          backgroundImage: widget.imagePath != null
                              ? FileImage(File(widget.imagePath!))
                                  as ImageProvider<Object>
                              : const NetworkImage(
                                  'https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Image.png'),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      title: Text("Delete Student record"),
                                      content: Text("Do you want to Delete?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            if (student.id != null) {
                                              deleteStudent(student.id!);
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
                                        )
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
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      title: Text("Edit Student Details"),
                                      content: Text(
                                          "Do you want to edit the details?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();

                                            showModalBottomSheet(
                                              context: context,
                                              builder: (ctx) {
                                                return Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
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
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              _updatedNameController,
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
                                                              _updatedAgeController,
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
                                                              _updatedClassController,
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
                                                              _updatedAddressController,
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
                                                                student.id,
                                                                _updatedNameController
                                                                    .text,
                                                                _updatedAgeController
                                                                    .text,
                                                                _updatedClassController
                                                                    .text,
                                                                _updatedAddressController
                                                                    .text);

                                                            _updatedNameController
                                                                .clear();
                                                            _updatedAgeController
                                                                .clear();
                                                            _updatedClassController
                                                                .clear();
                                                            _updatedAddressController
                                                                .clear();
                                                          },
                                                          icon: Icon(
                                                              Icons.update),
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
                                          child: Text("Yes"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text("No"),
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.edit),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
