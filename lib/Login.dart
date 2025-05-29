import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';
import 'start_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedRole;
  bool isLoading = false;

  final List<String> roles = ['parent', 'kid'];  // lowercase for easy matching

  Future<void> _loginUser() async {
    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();

    final savedParentName = prefs.getString('parentName')?.trim();
    final savedKidName = prefs.getString('kidName')?.trim();
    final savedPassword = prefs.getString('password')?.trim();

    final enteredName = nameController.text.trim();
    final enteredPassword = passwordController.text.trim();
    final role = selectedRole?.toLowerCase();

    print('Saved Parent Name: $savedParentName');
    print('Saved Kid Name: $savedKidName');
    print('Saved Password: $savedPassword');

    print('Entered Name: $enteredName');
    print('Entered Password: $enteredPassword');
    print('Selected Role: $role');

    await Future.delayed(const Duration(seconds: 1)); // Simulate delay

    setState(() => isLoading = false);

    bool isValid = false;

    if (role == 'parent' &&
        enteredName == savedParentName &&
        enteredPassword == savedPassword) {
      isValid = true;
    } else if (role == 'kid' &&
        enteredName == savedKidName &&
        enteredPassword == savedPassword) {
      isValid = true;
    }

    if (isValid) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StartPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid credentials")),
      );
    }
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
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6C2A),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Role Selection Dropdown
                  DropdownButtonFormField<String>(
                    decoration: buildInputDecoration("Select Role"),
                    value: selectedRole,
                    dropdownColor: Colors.black87,
                    iconEnabledColor: Colors.yellow,
                    style: const TextStyle(color: Colors.yellow),
                    items: roles.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role[0].toUpperCase() + role.substring(1)), // Capitalize for display
                      );
                    }).toList(),
                    validator: (value) => value == null ? 'Please select a role' : null,
                    onChanged: (value) {
                      setState(() => selectedRole = value);
                    },
                  ),
                  const SizedBox(height: 30),

                  buildTextField("Name", controller: nameController),
                  const SizedBox(height: 30),

                  buildTextField("Password", controller: passwordController, obscureText: true),
                  const SizedBox(height: 40),

                  isLoading
                      ? const CircularProgressIndicator(color: Colors.orange)
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6C2A),
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _loginUser();
                            }
                          },
                          child: const Text(
                            'LOGIN',
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
                      const Text("Not registered yet?", style: TextStyle(color: Colors.white)),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const Signup()),
                          );
                        },
                        child: const Text(
                          "Sign Up",
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

  InputDecoration buildInputDecoration(String label) {
    return InputDecoration(
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
    );
  }

  Widget buildTextField(String label,
      {required TextEditingController controller, bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
      decoration: buildInputDecoration(label),
      style: const TextStyle(color: Colors.yellow),
    );
  }
}
