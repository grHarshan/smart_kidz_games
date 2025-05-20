import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFB3F0F7), Color(0xFF91E842)],
              ),
            ),
          ),
          Positioned.fill(
            child: Column(
              children: [
                const SizedBox(height: 60),
                const Text(
                  'SIGN IN HERE',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF7B1C),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildTextField('NAME'),
                        const SizedBox(height: 20),
                        buildTextField('PASSWORD', obscureText: true),
                        const SizedBox(height: 20),
                        buildTextField('CONFIRM PASSWORD', obscureText: true),
                        const SizedBox(height: 40),
                        buildSignInButton(),
                      ],
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

  Widget buildTextField(String labelText, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Color(0xFFFFD700),
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFFFD700), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFFFA500), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget buildSignInButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle sign in logic
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF7B1C),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        shadowColor: Colors.black,
      ),
      child: const Text(
        'SIGNIN',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }
}