import 'package:flutter/material.dart';
import 'game1.dart';
import 'game2.dart';
import 'game3.dart';
import 'game4.dart';
import 'game5.dart';
import 'game6.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> games = [
    {'title': 'Game 1', 'color': Colors.pink, 'page': Game1()},
    {'title': 'Game 2', 'color': Colors.orange, 'page': Game2()},
    {'title': 'Game 3', 'color': Colors.green, 'page': Game3()},
    {'title': 'Game 4', 'color': Colors.blue, 'page': Game4()},
    {'title': 'Game 5', 'color': Colors.purple, 'page': Game5()},
    {'title': 'Game 6', 'color': Colors.yellow, 'page': Game6()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Grid with games
          Center(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: games.length,
              itemBuilder: (context, index) {
                var game = games[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (_) => game['page']));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: game['color'],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        game['title'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
