import 'package:flutter/material.dart';
import 'package:record_student/functions.dart';
import 'package:record_student/home_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: const ColorScheme.highContrastLight(
          background: Colors.white60,
          primary: Colors.white54,
          secondary: Colors.white70,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
