import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'signup.dart';
import 'teacher-dashboard.dart';

class TeacherLoginScreen extends StatefulWidget {
  @override
  _TeacherLoginScreenState createState() => _TeacherLoginScreenState();
}

class _TeacherLoginScreenState extends State<TeacherLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> handleLogin(BuildContext context) async {
    try {
      // Sign in with Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        // Check if the user exists in the 'teachers' collection
        DocumentSnapshot teacherDoc = await _firestore
            .collection('teachers')
            .doc(user.uid)
            .get();

        if (teacherDoc.exists) {
          // User is a registered teacher, navigate to dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TeacherDashboard()),
          );
        } else {
          // User is not a registered teacher
          await _auth.signOut(); // Log out the user
          _showErrorDialog(context, 'Invalid email/password');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showErrorDialog(context, 'Invalid email/password');
      } else if (e.code == 'wrong-password') {
        _showErrorDialog(context, 'Wrong email/password, please try again');
      } else {
        _showErrorDialog(context, 'Wrong email/password, please try again'); // Default to this for other auth errors
      }
    } catch (e) {
      _showErrorDialog(context, 'Wrong email/password, please try again'); // Default for non-Firebase errors
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEDC), // Light beige background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and Teacher Login Text
                Transform.translate(
                  offset: const Offset(0, -50), // Adjust logo position
                  child: Image.asset(
                    'assets/logo.png',
                    height: 200, // Adjust height
                    width: 200, // Adjust width
                  ),
                ),
                const SizedBox(height: 10),
                Transform.translate(
                  offset: const Offset(0, -80), // Adjust title position
                  child: Text(
                    'Teacher Login',
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5A7D7C),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Email TextField with adjustable position
                CustomTextField(
                  labelText: 'Enter your email',
                  controller: emailController,
                  width: 600, // Adjust width here
                  height: 80, // Adjust height here
                  offsetY: -50, // Adjust vertical position here
                ),
                const SizedBox(height: 20),
                
                // Password TextField with adjustable position
                CustomTextField(
                  labelText: 'Enter your password',
                  controller: passwordController,
                  width: 600, // Adjust width here
                  height: 80, // Adjust height here
                  obscureText: true,
                  offsetY: -50, // Adjust vertical position here
                ),
                const SizedBox(height: 30),

                // Login Button
                Transform.translate(
                  offset: const Offset(0, -50), // Adjust this value to move the button up
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF648BA2),
                      padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 25), // Adjust width and height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () => handleLogin(context),
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Sign-Up Text (Moved Up)
                Transform.translate(
                  offset: const Offset(0, -50), // Adjust this value to move the text up
                  child: Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Signup(userType: 'teacher')),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Back to Student Login (Moved Up)
                Transform.translate(
                  offset: const Offset(0, -50), // Adjust this value to move the text up
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Back to student Login',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 25,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final double width;
  final double height;
  final bool obscureText;
  final double offsetY; // New parameter to adjust the vertical position

  const CustomTextField({
    required this.labelText,
    required this.controller,
    this.width = 380,
    this.height = 60,
    this.obscureText = false,
    this.offsetY = 0.0, // Default is 0 for no adjustment
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, offsetY), // Adjust the vertical position here
      child: Container(
        width: width, // Width adjustable
        height: height, // Height adjustable
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF6EABCF), width: 4),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(fontSize: 20, color: Colors.black),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: labelText,
              hintStyle: const TextStyle(fontSize: 20, color: Colors.black54),
              contentPadding: const EdgeInsets.only(left: 5, top: 15),
            ),
          ),
        ),
      ),
    );
  }
}