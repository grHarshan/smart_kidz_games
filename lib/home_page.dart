import 'package:flutter/material.dart';
import 'game1.dart';
import 'game2.dart';
import 'game3.dart';
import 'game4.dart';
import 'game5.dart';
import 'game6.dart';

class HomePage extends StatelessWidget {
  static final List<Map<String, dynamic>> games = [
    {'title': 'Game 1', 'color': Colors.yellow[200], 'page': const Game1()},
    {'title': 'Game 2', 'color': Colors.purple[300], 'page': const Game2()},
    {'title': 'Game 3', 'color': Colors.cyan[300], 'page': const Game3()},
    {'title': 'Game 4', 'color': Colors.pinkAccent[100], 'page': const Game4()},
    {'title': 'Game 5', 'color': Colors.lightGreenAccent[100], 'page': const Game5()},
    {'title': 'Game 6', 'color': Colors.orange[200], 'page': const Game6()},
  ];

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/H1.png'), // Updated image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Vertical List of Games
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: games.map((game) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => game['page']),
                        );
                      },
                      child: Container(
                        width: 250,
                        height: 60,
                        decoration: BoxDecoration(
                          color: game['color'],
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            game['title'],
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'ComicSans', // optional
                              shadows: [
                                Shadow(blurRadius: 2, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}