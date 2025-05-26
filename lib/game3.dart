import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Game3(),
  ));
}

/// Start Screen for Game 3
class Game3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("🎮 Game 3: Animal Challenge",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 39, 255, 86),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (_) => Game3Main()));
                  },
                  child: Text("Start Game 3", style: TextStyle(fontSize: 24)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Victory Screen for Game 3
class Game3VictoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("🏆 You Won Game 3!",
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 20),
                Text("You completed all 3 levels!",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 68, 255, 93),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (_) => Game3Main()));
                  },
                  child: Text("Play Again", style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Main Game 3 Screen
class Game3Main extends StatefulWidget {
  @override
  _Game3MainState createState() => _Game3MainState();
}

class _Game3MainState extends State<Game3Main> {
  final List<Map<String, String>> allAnimals = [
    {"name": "CAT", "image": "assets/images/cat.jpg"},
    {"name": "DOG", "image": "assets/images/dog.jpg"},
    {"name": "COW", "image": "assets/images/cow.jpg"},
    {"name": "FISH", "image": "assets/images/fish.jpg"},
    {"name": "BIRD", "image": "assets/images/bird.jpg"},
  ];

  List<Map<String, String>> remainingAnimals = [];
  late Map<String, String> currentAnimal;
  List<String> shuffledLetters = [];
  List<String> userInput = [];
  int level = 1;

  @override
  void initState() {
    super.initState();
    remainingAnimals = List.from(allAnimals);
    _loadNewAnimal();
  }

  void _loadNewAnimal() {
    if (remainingAnimals.isNotEmpty) {
      final random = Random();
      int index = random.nextInt(remainingAnimals.length);
      currentAnimal = remainingAnimals.removeAt(index);
      shuffledLetters = currentAnimal["name"]!.split('')..shuffle();
      userInput = List.filled(currentAnimal["name"]!.length, '');
      setState(() {});
    }
  }

  void _onLetterTap(String letter) {
    for (int i = 0; i < userInput.length; i++) {
      if (userInput[i].isEmpty) {
        setState(() {
          userInput[i] = letter;
        });
        break;
      }
    }
  }

  void _clearInput() {
    setState(() {
      userInput = List.filled(currentAnimal["name"]!.length, '');
    });
  }

  void _checkAnswer() {
    String answer = userInput.join();
    if (answer == currentAnimal["name"]) {
      if (level == 3) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => Game3VictoryScreen()));
      } else {
        _showNextLevelDialog();
      }
    } else {
      _showDialog("❌ Incorrect", "That’s not the right animal. Try again.");
      _clearInput();
    }
  }

  void _showNextLevelDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text("✅ Correct!", style: TextStyle(fontSize: 22)),
        content: Text("Get ready for level ${level + 1}!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                level++;
                _loadNewAnimal();
              });
            },
            child: Text("Next"),
          ),
        ],
      ),
    );
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title, style: TextStyle(fontSize: 22)),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game 3 - Level $level"),
        backgroundColor: const Color.fromARGB(255, 146, 220, 241),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 3),
                    ),
                    child: Image.asset(
                      currentAnimal["image"]!,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: userInput.map((letter) {
                      return Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(letter, style: TextStyle(fontSize: 24)),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    children: shuffledLetters.map((letter) {
                      return ElevatedButton(
                        onPressed: () => _onLetterTap(letter),
                        child: Text(letter, style: TextStyle(fontSize: 24)),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _checkAnswer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                        child: Text("✅ Done", style: TextStyle(fontSize: 20)),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _clearInput,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                        child: Text("🔄 Clear", style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
