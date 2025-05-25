import 'package:flutter/material.dart';

class Game2 extends StatelessWidget {
  const Game2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        title: Text("Game 2"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text(
          "🎯 Welcome to Game 2!",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(blurRadius: 4, color: Colors.black45, offset: Offset(2, 2))
            ],
          ),
        ),
      ),
    );
  }
}
