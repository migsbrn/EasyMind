import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'student_landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  final TextEditingController nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFE9D5),
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset('assets/logo.png', height: 400),
            ),
          ),
          Positioned(
            top: 450,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'EasyMind',
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF648BA2),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          Positioned(
            top: 580,
            left: 0,
            right: 0,
            child: Center(
              child: CustomTextField(
                controller: nicknameController,
                labelText: 'Enter your nickname',
                width: 800,
                height: 120,
              ),
            ),
          ),
          Positioned(
            top: 750,
            left: 0,
            right: 0,
            child: Center(
              child: CustomButton(
                text: 'LOGIN',
                width: 800,
                height: 80,
                onPressed: () {
                  String nickname = nicknameController.text.trim();
                  if (nickname.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentLandingPage(nickname: nickname),
                      ),
                    );
                  } else {
                    // Show an error message if nickname is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please enter a nickname")),
                    );
                  }
                },
              ),
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
  final TextEditingController controller;

  const CustomTextField({
    required this.labelText,
    required this.controller,
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
          controller: controller,
          style: TextStyle(fontSize: 40, color: Colors.black),
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
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
