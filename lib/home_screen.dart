import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:record_student/add_student.dart';
import 'package:record_student/edit_screen.dart';
import 'package:record_student/functions.dart';
import 'package:record_student/profile_screen.dart';
import 'package:record_student/search_screen.dart';
import 'package:record_student/students.dart';
import 'package:google_fonts/google_fonts.dart';

const String defaultImageUrl = 'assets/dummy.webp';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List<Students>? studentList;
  Students? student;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  
    getAllStudent();
    return Scaffold(
      appBar: AppBar(elevation: 10,
        automaticallyImplyLeading: false,
        title: Text('LogBook',style:GoogleFonts.raleway(color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 26)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ));
              },
              icon: const Icon(Icons.search,color: Colors.black,))
        ],
      ),
      body: ValueListenableBuilder(
        builder: (BuildContext context, studentList, Widget? child) {
          return RefreshIndicator(
            onRefresh: getAllStudent,
            child: ListView.builder(
              itemCount: studentList.length,
              itemBuilder: (context, index) {
                final student = studentList[index];
                return SizedBox(
                  height: 80,
                  child: ListWidget(
                    student: student,
                  ),
                );
              },
            ),
          );
        },
        valueListenable: studentListNotifier,
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.white70,
        onPressed: () async {
          showModalBottomSheet(
            enableDrag: true,
            context: context,
            builder: (context) => SizedBox(
                child: AddStudentScreen(
              student: student,
            )),
          );
        },
        child: const Icon(
          Icons.add_circle,
          color: Colors.black,
        ),
      ),
    );
  }
}

class ListWidget extends StatelessWidget {
  const ListWidget({
    super.key,
    required this.student,
  });

  final Students student;
  final String defaultImageUrl = 'assets/dummy.webp';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(elevation:10,
      shape:  Border.all(style: BorderStyle.solid,),
        color: Colors.white70,
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfileStudentScreen(
                student: student,
              ),
            ));
          },
          leading: SizedBox.square(
            dimension: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: student.image.isEmpty
                  ? Image.asset(defaultImageUrl)
                  : Image.file(
                      File(student.image),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          title: Text(
            student.name,
            style:  GoogleFonts.raleway(
                color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20),
          ),
          subtitle: Text(
            student.domain,
            style: const TextStyle(color: Colors.black),
          ),
          trailing: Wrap(
            spacing: 20,
            direction: Axis.horizontal,
            children: [
              IconButton(
                color: Colors.black,
                onPressed: () {
                  showModalBottomSheet(
                    enableDrag: true,
                    context: context,
                    builder: (context) => EditStudentScreen(
                      student: student,
                    ),
                  );
                },
                icon: const Icon(Icons.edit_square),
              ),
              IconButton(
                color: Colors.black,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Confirm ??",
                      style: TextStyle(color: Colors.black,
                      fontWeight: FontWeight.w900)),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel",style: TextStyle(color: Colors.black)),
                        ),
                        ElevatedButton.icon(
                            onPressed: () {
                              _deleteStudent(student, context)
                                  .then((value) => Navigator.of(context).pop());
                            },
                            icon: const Icon(
                              Icons.delete,color: Colors.black,
                            ),
                            label: const Text("Delete",style: TextStyle(color: Colors.black)))
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteStudent(Students student, BuildContext ctx) async {
    try {
       deleteStudent(student.id!);
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          margin: EdgeInsets.all(5),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
          content: Text("Removed Sucesfully")));
    } catch (e) {
      log("Exception filed :${e.toString()}");
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          margin: EdgeInsets.all(5),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Text("Error Occured")));
    }
  }
}
