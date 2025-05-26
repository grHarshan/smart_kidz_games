import 'package:flutter/material.dart';
import 'Login.dart'; // Make sure you have Login.dart in the same folder

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // Controllers for each input
  final TextEditingController parentNameController = TextEditingController();
  final TextEditingController kidNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Key for form validation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/backgroundSL.png',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.3)),

          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'SIGN IN HERE',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6C2A),
                    ),
                  ),
                  const SizedBox(height: 40),

                  buildTextField("Parent's Name", controller: parentNameController),
                  const SizedBox(height: 30),

                  buildTextField("Kid's Name", controller: kidNameController),
                  const SizedBox(height: 30),

                  buildTextField("Password", controller: passwordController, obscureText: true),
                  const SizedBox(height: 30),

                  buildTextField("Confirm Password", controller: confirmPasswordController, obscureText: true),
                  const SizedBox(height: 40),

                  // Signup Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6C2A),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (passwordController.text != confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Passwords do not match")),
                          );
                          return;
                        }

                        // Simulate data submission
                        print('Parent: ${parentNameController.text}');
                        print('Kid: ${kidNameController.text}');
                        print('Password: ${passwordController.text}');

                        // Navigate to Login Page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      }
                    },
                    child: const Text(
                      'SIGNIN',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable text field builder
  Widget buildTextField(String label,
      {required TextEditingController controller, bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: (value) =>
      value == null || value.isEmpty ? 'Please enter $label' : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.yellow),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.yellow),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.yellow),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
