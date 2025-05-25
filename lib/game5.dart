import 'package:flutter/material.dart';

class Game5 extends StatelessWidget {
  const Game5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 143, 225),
      appBar: AppBar(
        title: Text("Game 5"),
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
