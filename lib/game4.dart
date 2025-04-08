import 'package:flutter/material.dart';

class Game4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 149, 142),
      appBar: AppBar(
        title: Text("Game 4"),
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
