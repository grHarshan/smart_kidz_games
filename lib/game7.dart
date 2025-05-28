import 'package:flutter/material.dart';
import 'app_bar.dart'; 

class Game7 extends StatefulWidget {
  @override
  _Game7State createState() => _Game7State();
}

class _Game7State extends State<Game7> {
  final List<String> vowels = ['A', 'E', 'I', 'O', 'U'];
  final List<String> consonants = [
    'B', 'C', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'M',
    'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'X', 'Y', 'Z'
  ];

  List<String> correctVowels = [];
  List<String> correctConsonants = [];

  @override
  Widget build(BuildContext context) {
    List<String> allLetters = [...vowels, ...consonants]..shuffle();
    allLetters = allLetters.take(10).toList();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final letterBoxSize = (screenWidth / 8).clamp(40.0, 70.0);
    final targetBoxWidth = (screenWidth * 0.4).clamp(120.0, 180.0);
    final targetBoxHeight = (screenHeight * 0.3).clamp(150.0, 250.0);

    return Scaffold(
      appBar: 
              SimpleAppBar(
    onHomePressed: () {
      Navigator.popUntil(context, (route) => route.isFirst);
    },
    onProfilePressed: () {
      Navigator.pushNamed(context, '/profile');
    },
  ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background1.png',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  "Drag the letters into the correct box",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 3,
                        color: Colors.black,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: allLetters
                      .map(
                        (letter) => Draggable<String>(
                          data: letter,
                          feedback: LetterBox(
                            letter: letter,
                            size: letterBoxSize,
                          ),
                          childWhenDragging: LetterBox(
                            letter: '',
                            faded: true,
                            size: letterBoxSize,
                          ),
                          child: LetterBox(
                            letter: letter,
                            size: letterBoxSize,
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTargetBox(
                      "🍎 Vowels",
                      vowels,
                      correctVowels,
                      isVowelBox: true,
                      width: targetBoxWidth,
                      height: targetBoxHeight,
                    ),
                    buildTargetBox(
                      "🐻 Consonants",
                      consonants,
                      correctConsonants,
                      isVowelBox: false,
                      width: targetBoxWidth,
                      height: targetBoxHeight,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget buildTargetBox(
    String title,
    List<String> validLetters,
    List<String> currentList, {
    required bool isVowelBox,
    required double width,
    required double height,
  }) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: width,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            border: Border.all(color: Colors.blueAccent, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                color: isVowelBox ? Colors.pink[100] : Colors.green[100],
                child: Text(
                  title,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                constraints: BoxConstraints(
                  minHeight: 100,
                  maxHeight: height - 60,
                ),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: currentList.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "Drop letters here",
                            style: TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: currentList
                            .map(
                              (e) => Text(
                                e,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isVowelBox
                                      ? Colors.pink[800]
                                      : Colors.green[800],
                                  shadows: [
                                    Shadow(
                                      color: Colors.black12,
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ),
            ],
          ),
        );
      },
      onAccept: (receivedLetter) {
        setState(() {
          if (validLetters.contains(receivedLetter)) {
            if (isVowelBox && !correctVowels.contains(receivedLetter)) {
              correctVowels.add(receivedLetter);
            } else if (!isVowelBox &&
                !correctConsonants.contains(receivedLetter)) {
              correctConsonants.add(receivedLetter);
            }
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Center(child: Text('Oops!')),
                content: Container(
                  height: 90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '😃 Nope! Wrong box! 🏠',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Try again! 🌈',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'You’re doing great! 👍',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        });
      },
    );
  }
}

class LetterBox extends StatelessWidget {
  final String letter;
  final bool faded;
  final double size;

  const LetterBox({
    required this.letter,
    this.faded = false,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: faded ? Colors.grey[300] : Colors.orange[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        letter,
        style: TextStyle(
          fontSize: size * 0.45,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
