import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student_details_week_5/Screens/Widgets/list_student_widget.dart';
import 'package:student_details_week_5/db/functions/db_functions.dart';
import 'package:student_details_week_5/db/models/data_model.dart';
import 'package:image_picker/image_picker.dart';

class AddStudentWidget extends StatefulWidget {
  AddStudentWidget({super.key});

  @override
  State<AddStudentWidget> createState() => _AddStudentWidgetState();
}

class _AddStudentWidgetState extends State<AddStudentWidget> {
  String? imagePath;
  final picker = ImagePicker();
  bool isStudentListEmpty = true;

  final _nameController = TextEditingController();
  final _AgeController = TextEditingController();
  final _ClassController = TextEditingController();
  final _AddressController = TextEditingController();

  Future<void> takePhoto() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  bool _validateName(String name) {
    RegExp nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    return nameRegex.hasMatch(name);
  }

  bool _validateAge(String age) {
    try {
      int ageValue = int.parse(age);
      return ageValue > 0;
    } catch (e) {
      return false;
    }
  }

  bool _validateClass(String className) {
    try {
      int ageValue = int.parse(className);
      return ageValue > 0;
    } catch (e) {
      return false;
    }
  }

  bool _validateAddress(String address) {
    return address.isNotEmpty;
  }

  bool _validateForm(BuildContext context) {
    if (_nameController.text.isEmpty &&
        _AgeController.text.isEmpty &&
        _ClassController.text.isEmpty &&
        _AddressController.text.isEmpty &&
        imagePath == null) {
      _showErrorSnackBar(context, "All fields are empty");
      return false;
    }

    if (!_validateName(_nameController.text)) {
      _showErrorSnackBar(context, "Name field is empty or Invalid name format");
      return false;
    }

    if (!_validateAge(_AgeController.text)) {
      _showErrorSnackBar(context, "Age field is empty or Invalid age format");
      return false;
    }

    if (!_validateClass(_ClassController.text)) {
      _showErrorSnackBar(
          context, "Class field is empty or Invalid Class format");
      return false;
    }

    if (!_validateAddress(_AddressController.text)) {
      _showErrorSnackBar(
          context, "Adress field is empty or Invalid Adress format");
      return false;
    }

    if (imagePath == null) {
      _showErrorSnackBar(context, "Please select an image");
      return false;
    }

    return true;
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [Icon(Icons.error), Text(message)],
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD STUDENT'),
        centerTitle: true,
      ),
      body: Material(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  'Profile Picture',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      maxRadius: 55,
                      backgroundImage: imagePath == null
                          ? const NetworkImage(
                                  'https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Image.png')
                              as ImageProvider
                          : FileImage(File(imagePath.toString())),
                    ),
                    Positioned(
                      child: IconButton(
                        onPressed: takePhoto,
                        icon: Icon(Icons.add_a_photo),
                      ),
                      bottom: -10,
                      left: 60,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter your Name",
                        hintStyle: TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.italic),
                        labelStyle: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Age',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: _AgeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter your Age",
                        hintStyle: TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.italic),
                        labelStyle: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Class',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: _ClassController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter your Class",
                        hintStyle: TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.italic),
                        labelStyle: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: _AddressController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter your Address",
                        hintStyle: TextStyle(
                            color: Colors.grey, fontStyle: FontStyle.italic),
                        labelStyle: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    print("Add button pressed");
                    if (_validateForm(context)) {
                      StudentAddButton();
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Student"),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => ListStudentWidget(imagePath: imagePath),
                    ));
                  },
                  icon: const Icon(Icons.list),
                  label: const Text("Show List"),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void StudentAddButton() {
    List<String> data = [
      _nameController.text.trim(),
      _AgeController.text.trim(),
      _ClassController.text.trim(),
      _AddressController.text.trim(),
      imagePath ?? '',
    ];

    studentAdder(data);
  }

  void studentAdder(List<String> data) {
    final student = StudentModel(
      name: data[0],
      age: data[1],
      cls: data[2],
      address: data[3],
      img: data[4],
    );
    addStudent(student);
    findClear();
    SnackBar mySnackbar = SnackBar(
      content: Row(
        children: [Icon(Icons.done), Text("Successfully added")],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(mySnackbar);
  }

  void findClear() {
    _nameController.clear();
    _AgeController.clear();
    _ClassController.clear();
    _AddressController.clear();
    setState(() {
      imagePath = null;
    });
  }
}
