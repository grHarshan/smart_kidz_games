import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';
import 'Login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController parentNameController = TextEditingController();
  final TextEditingController kidNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> _saveUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('parentName', parentNameController.text.trim());
    await prefs.setString('kidName', kidNameController.text.trim());
    await prefs.setString('password', passwordController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/backgroundSL.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.3)),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'SIGN UP HERE',
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

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6C2A),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (passwordController.text != confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Passwords do not match")),
                          );
                          return;
                        }

                        await _saveUserDetails();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfilePage()),
                        );
                      }
                    },
                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already signed up?", style: TextStyle(color: Colors.white)),
                      TextButton(
                        onPressed: () { Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Color(0xFFFF6C2A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label,
      {required TextEditingController controller, bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
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
      style: const TextStyle(color: Colors.yellow),
    );
  }
}
