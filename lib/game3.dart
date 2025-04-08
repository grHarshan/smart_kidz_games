import 'package:flutter/material.dart';

class Game3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 213, 139),
      appBar: AppBar(
        title: Text("Game 3"),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Text(
          "Game 1 Page",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
    );
  }
}
