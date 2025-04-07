import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Signup extends StatefulWidget {
  final String userType; // 'teacher' or 'student' passed as a parameter

  const Signup({required this.userType, super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser(BuildContext context) async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Validate inputs
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showMessage(context, "Please fill in all fields.");
      return;
    }

    if (password != confirmPassword) {
      showMessage(context, "Passwords do not match.");
      return;
    }

    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Store user data in Firestore with role-specific collection
        String collectionName = widget.userType == 'teacher' ? 'teachers' : 'students';
        await _firestore.collection(collectionName).doc(user.uid).set({
          "name": name,
          "email": email,
          "role": widget.userType,
          "createdAt": FieldValue.serverTimestamp(),
          "status": "active", // Add status for admin to manage
          "lastLogin": FieldValue.serverTimestamp(), // Optional: Track last login
          "phoneNumber": "", // Optional: Add if you want to collect phone numbers later
        });

        // Log user activity for dashboard tracking
        await logUserActivity(user.uid, widget.userType);

        // Clear form fields after successful registration
        nameController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();

        showMessage(context, "Registration successful!");
        Navigator.pop(context); // Navigate back to login or home
      }
    } catch (e) {
      String errorMessage = "Error: ${e.toString()}";
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = "This email is already in use.";
            break;
          case 'invalid-email':
            errorMessage = "Invalid email format.";
            break;
          case 'weak-password':
            errorMessage = "Password is too weak.";
            break;
          default:
            errorMessage = "Registration failed. Please try again.";
        }
      }
      showMessage(context, errorMessage);
    }
  }

  // Function to log user activity in Firestore 'logins' collection
  Future<void> logUserActivity(String uid, String role) async {
    await _firestore.collection('logins').add({
      'uid': uid,
      'role': role,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                // Adjusted 'Create Account' title position
                Transform.translate(
                  offset: const Offset(0, -70), // Adjust title position
                  child: Text(
                    'Create ${widget.userType.capitalize()} Account',
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5A7D7C),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Adjusted Name TextField position
                Transform.translate(
                  offset: const Offset(0, -40), // Shift up by 10 units
                  child: CustomTextField(
                    labelText: 'Enter your fullname',
                    controller: nameController,
                    width: 500, // Custom width
                    height: 70, // Custom height
                  ),
                ),
                const SizedBox(height: 20),

                // Adjusted Email TextField position
                Transform.translate(
                  offset: const Offset(0, -40), // Shift up by 10 units
                  child: CustomTextField(
                    labelText: 'Enter your email',
                    controller: emailController,
                    width: 500, // Custom width
                    height: 70, // Custom height
                  ),
                ),
                const SizedBox(height: 20),

                // Adjusted Password TextField position
                Transform.translate(
                  offset: const Offset(0, -40), // Shift up by 10 units
                  child: CustomTextField(
                    labelText: 'Enter your password',
                    controller: passwordController,
                    obscureText: true,
                    width: 500, // Custom width
                    height: 70, // Custom height
                  ),
                ),
                const SizedBox(height: 20),

                // Adjusted Confirm Password TextField position
                Transform.translate(
                  offset: const Offset(0, -40), // Shift up by 10 units
                  child: CustomTextField(
                    labelText: 'Confirm password',
                    controller: confirmPasswordController,
                    obscureText: true,
                    width: 500, // Custom width
                    height: 70, // Custom height
                  ),
                ),
                const SizedBox(height: 30),

                // Register Button
                Transform.translate(
                  offset: const Offset(0, -50), // Adjusted vertical position
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF648BA2),
                      padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 25), // Adjusted width and height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () => registerUser(context), // Call registerUser function
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Login Text
                Transform.translate(
                  offset: const Offset(0, -50), // Adjust the vertical position to move it up
                  child: Text.rich(
                    TextSpan(
                      text: 'Already have an account? ',
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context); // Navigate back to login
                            },
                        ),
                      ],
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

// Helper extension to capitalize text (for dynamic title)
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final double width; // Added width parameter
  final double height; // Added height parameter

  const CustomTextField({
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.width = 400, // Default width
    this.height = 60, // Default height
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Use dynamic width
      height: height, // Use dynamic height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF6EABCF), width: 2),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: labelText,
            hintStyle: const TextStyle(fontSize: 18, color: Colors.black54),
            contentPadding: const EdgeInsets.symmetric(vertical: 20), // Center text vertically
          ),
        ),
      ),
    );
  }
}