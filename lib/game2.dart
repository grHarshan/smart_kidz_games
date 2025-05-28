import 'dart:math';
import 'package:flutter/material.dart';
import 'app_bar.dart'; 

class Game2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StartScreen();
  }
}

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NumberGameScreen()),
            );
          },
          child: Text("Start Game", style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }
}

class NumberGameScreen extends StatefulWidget {
  @override
  _NumberGameScreenState createState() => _NumberGameScreenState();
}

class _NumberGameScreenState extends State<NumberGameScreen> {
  List<int> numbers = [];
  Map<int, bool> dropped = {};
  List<int> draggableNumbers = [];
  String hint = "";
  int currentLevel = 1;
  int boxesToFill = 3;

  @override
  void initState() {
    super.initState();
    randomizeGame();
  }

  void randomizeGame() {
    Set<int> generatedSet = {};
    Random rand = Random();
    while (generatedSet.length < boxesToFill) {
      generatedSet.add(10 + rand.nextInt(90));
    }

    List<int> selected = generatedSet.toList();
    int patternType = Random().nextInt(2);
    switch (patternType) {
      case 0:
        numbers = List.from(selected)..sort();
        hint = "Arrange from smallest to biggest";
        break;
      case 1:
        numbers = List.from(selected)..sort((a, b) => b.compareTo(a));
        hint = "Arrange from biggest to smallest";
        break;
    }

    draggableNumbers = List.from(selected)..shuffle();
    dropped = {};
  }

  bool checkCompletion() => dropped.length == boxesToFill;

  void nextLevel() {
    setState(() {
      if (currentLevel < 3) {
        currentLevel++;
        boxesToFill = currentLevel + 2;
        randomizeGame();
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EndScreen()),
        );
      }
    });
  }

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
          Column(
            children: [


              SimpleAppBar(
    onHomePressed: () {
      Navigator.popUntil(context, (route) => route.isFirst);
    },
    onProfilePressed: () {
      Navigator.pushNamed(context, '/profile');
    },
  ),





              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(hint,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: numbers.map((number) {
                                return DragTarget<int>(
                                  onAccept: (receivedNumber) {
                                    if (receivedNumber == number) {
                                      setState(() {
                                        dropped[number] = true;
                                        if (checkCompletion()) {
                                          if (currentLevel < 3) {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AlertDialog(
                                                title: Text("Well Done!"),
                                                content: Text(
                                                    "You completed level $currentLevel successfully."),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      nextLevel();
                                                    },
                                                    child: Text("Next Level"),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            nextLevel();
                                          }
                                        }
                                      });
                                    }
                                  },
                                  builder: (context, candidateData,
                                          rejectedData) =>
                                      NumberBox(
                                          number:
                                              dropped[number] == true ? number : null,
                                          isTarget: true),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(width: 50),
                          Container(
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: draggableNumbers.map((number) {
                                return Draggable<int>(
                                  data: number,
                                  child: dropped[number] == true
                                      ? SizedBox.shrink()
                                      : NumberBox(number: number),
                                  feedback: NumberBox(
                                      number: number, isDragging: true),
                                  childWhenDragging: SizedBox.shrink(),
                                );
                              }).toList(),
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
        ],
      ),
    );
  }
}

class EndScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("🎉 You completed all levels!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => StartScreen()),
                  (route) => false,
                );
              },
              child: Text("Play Again", style: TextStyle(fontSize: 24)),
            ),
          ],
        ),
      ),
    );
  }
}

class NumberBox extends StatelessWidget {
  final int? number;
  final bool isDragging;
  final bool isTarget;

  NumberBox({this.number, this.isDragging = false, this.isTarget = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: number != null
            ? Colors.blueAccent
            : isTarget
                ? Colors.grey[300]
                : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: number != null
          ? Text(
              "$number",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )
          : null,
    );
  }
}
