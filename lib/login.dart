import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Dropdown
  String? selectedRole;
  final List<String> roles = ['Parent', 'Child'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/Images/background.png',
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
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6C2A),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Role Dropdown
                  DropdownButtonFormField<String>(
                    decoration: _inputDecoration("Select Role"),
                    value: selectedRole,
                    items: roles.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    validator: (value) => value == null ? 'Please select a role' : null,
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value;
                      });
                    },
                  ),
                  const SizedBox(height: 30),

                  // Name field (dynamic label)
                  TextFormField(
                    controller: nameController,
                    decoration: _inputDecoration(
                        selectedRole == 'Parent'
                            ? "Enter Parent's Name"
                            : selectedRole == 'Child'
                            ? "Enter Child's Name"
                            : "Enter Name"),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter name' : null,
                  ),
                  const SizedBox(height: 30),

                  // Password field
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: _inputDecoration("Password"),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter password' : null,
                  ),
                  const SizedBox(height: 40),

                  // Login Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6C2A),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Simulate login
                        print('Logging in as: $selectedRole');
                        print('Name: ${nameController.text}');
                        print('Password: ${passwordController.text}');

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Login Successful!")),
                        );
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
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Input decoration helper
  InputDecoration _inputDecoration(String label) {
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
}
