import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'firebase_options.dart'; // Import the generated Firebase options
import 'student_landing_page.dart';
import 'teacher_login_screen.dart';

void main() async {
  // Ensure Flutter is initialized and Firebase is configured
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with the options from firebase_options.dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(EasyMindApp());
}

class EasyMindApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primaryColor: Color(0xFF648BA2),
      ),
      home: StudentLoginScreen(),
    );
  }
}

class StudentLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFE9D5),
      body: Stack(
        children: [
          Positioned(
            top: 35,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset('assets/logo.png', height: 200),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'EasyMind',
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4E69),
                  ),
                ),
                SizedBox(height: 20),
                CustomTextField(
                  labelText: 'Enter your nickname',
                  width: 800,
                  height: 120,
                ),
                SizedBox(height: 20),
                CustomButton(
                  text: 'LOGIN',
                  width: 500,
                  height: 80,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StudentLandingPage()),
                    );
                  },
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TeacherLoginScreen()),
                  ),
                  child: Text(
                    'Login as Teacher',
                    style: TextStyle(
                      fontSize: 30,
                      color: Color(0xFF4A4E69),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final double width;
  final double height;

  const CustomTextField({
    required this.labelText,
    this.width = 380,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Color(0xFF6EABCF), width: 8),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: TextField(
          style: TextStyle(fontSize: 40, color: Colors.black), // Large font size while typing
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: labelText,
            hintStyle: TextStyle(fontSize: 35, color: Colors.black54),
            contentPadding: EdgeInsets.only(left: 5, top: 30),
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final VoidCallback onPressed;

  const CustomButton({
    required this.text,
    this.width = 380,
    this.height = 60,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF648BA2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white), // Larger font size
        ),
      ),
    );
  }
}