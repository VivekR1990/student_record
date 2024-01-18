import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:record_student/edit_screen.dart';
import 'package:record_student/functions.dart';
import 'package:record_student/home_screen.dart';
import 'package:record_student/students.dart';

class ProfileStudentScreen extends StatefulWidget {
  final Students student;

  const ProfileStudentScreen({super.key, required this.student});

  @override
  State<ProfileStudentScreen> createState() => _ProfileStudentScreenState();
}

class _ProfileStudentScreenState extends State<ProfileStudentScreen> {
  bool isLoading = false;
  List<Students>? list;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
        title: Text(
          "Profile",
          style: GoogleFonts.raleway(
              fontSize: 26, color: Colors.black, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            color: Colors.black,
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.white70,
                  title: const Text("Confirm ??",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w900)),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.black)),
                    ),
                    ElevatedButton.icon(
                        onPressed: () {
                          _deleteStudent(widget.student, context)
                              .then((value) => Navigator.of(context).pop());
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                        label: const Text("Delete",
                            style: TextStyle(color: Colors.black)))
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            color: Colors.black,
            onPressed: () async {
              if (isLoading) return;
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditStudentScreen(
                  student: widget.student,
                ),
              ));
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              SizedBox.square(
                dimension: 200,
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.elliptical(15, 15),
                      right: Radius.elliptical(15, 15)),
                  child: widget.student.image.isEmpty
                      ? Image.asset(
                          defaultImageUrl,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(widget.student.image),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10,left: 10),
                child: Text(
                  widget.student.name,
                  style: GoogleFonts.raleway(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  "Age: ${widget.student.age} Years",
                  style: GoogleFonts.raleway(fontSize: 24, color: Colors.black87),
                ),
                Text(
                  "Email: ${widget.student.email} ",
                  style: GoogleFonts.raleway(fontSize: 24, color: Colors.black87),
                ),
                Text(
                  "Domain :  ${widget.student.domain}",
                  style: GoogleFonts.raleway(fontSize: 24, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
      //
    );
  }

  Future<void> _deleteStudent(Students student, BuildContext ctx) async {
    try {
      deleteStudent(student.id!);
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          margin: EdgeInsets.all(5),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
          content: Text("Removed Sucesfully")));
    } catch (e) {
      log("Exception filed :${e.toString()}");
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          margin: EdgeInsets.all(5),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Text("Error Occured")));
    }
  }
}
