import 'package:flutter/material.dart';

class Game1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text("Game 1"),
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
