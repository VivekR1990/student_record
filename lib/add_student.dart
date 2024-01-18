import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record_student/functions.dart';
import 'package:record_student/students.dart';


class AddStudentScreen extends StatefulWidget {
  final Students? student;

  const AddStudentScreen({
    super.key,
    this.student,
  });

  @override
  State<AddStudentScreen> createState() => _AddEditStudentScreenState();
}

class _AddEditStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _domainController = TextEditingController();
  final _imageController = TextEditingController();

  XFile? _imageFile;

  Future<void> _getImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = XFile(pickedFile.path);
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = XFile(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _domainController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  bool isEmailValid(String email) {
    final emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    return emailRegExp.hasMatch(email);
  }

  void _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      final newStudent = Students(
        id: int.tryParse(StudentsFields.id) ?? 0,
        name: _nameController.text,
        age: int.tryParse(_ageController.text) ?? 0,
        email: _emailController.text,
        domain: _domainController.text,
        image: _imageFile?.path ?? '',
      );

      try {
        addStudents(newStudent, context);

        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            margin: EdgeInsets.all(5),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
            content: Text("Error Occured")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: const EdgeInsets.all(5),
                    child: TextFormField(
                      controller: _nameController,
                      style:const TextStyle(color: Colors.black) ,cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: 'Name',labelStyle: TextStyle(color: Colors.black)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(5),
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      controller: _ageController,
                      style:const TextStyle(color: Colors.black) ,cursorColor: Colors.white,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: 'Age',
                        labelStyle: TextStyle(color: Colors.black)
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an age';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(5),
                    child: TextFormField(
                      controller: _emailController,
                      style:const TextStyle(color: Colors.black) ,cursorColor: Colors.black,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: 'Email',labelStyle: TextStyle(color: Colors.black)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!isEmailValid(value)) {
                          return 'Invalid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(5),
                    child: TextFormField(
                      controller: _domainController,
                      style:const TextStyle(color: Colors.black) ,cursorColor: Colors.black,
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                          labelText: 'Domain',
                          labelStyle: TextStyle(color: Colors.black)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your domain';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white),
                          onPressed: _getImageFromCamera,
                          icon: const Icon(
                            Icons.camera_enhance_outlined,
                            color: Colors.black,
                          ),
                          label: const Text(
                            'Camera',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white),
                          onPressed: _getImageFromGallery,
                          icon: const Icon(
                            Icons.upload_file,
                            color: Colors.black,
                          ),
                          label: const Text(
                            'Upload',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(left: 94,top: 10),
                    child: SizedBox(height: 40,
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:  Colors.white),
                        onPressed: () async {
                          _saveStudent();
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
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
}
