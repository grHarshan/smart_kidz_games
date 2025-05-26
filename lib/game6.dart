import 'package:flutter/material.dart';
import 'dart:math';

class Game6 extends StatefulWidget {
  @override
  _Game6State createState() => _Game6State();
}

class _Game6State extends State<Game6> {
  final List<String> wordList = ["apple", "table", "chair", "smart", "phone"];
  late String targetWord;
  List<List<String>> attempts = [];
  int maxAttempts = 5;
  int currentAttempt = 0;
  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];
  Set<String> guessedLetters = Set<String>();
  Map<String, Color> letterColors = {};
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    targetWord = wordList[Random().nextInt(wordList.length)];
    attempts = List.generate(maxAttempts, (_) => List.filled(targetWord.length, ""));
    controllers = List.generate(targetWord.length, (_) => TextEditingController());
    focusNodes = List.generate(targetWord.length, (_) => FocusNode());
    guessedLetters.clear();
    letterColors.clear();
    currentAttempt = 0;
    isGameOver = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNodes[0].requestFocus();
    });

    setState(() {});
  }

  void checkWord() {
    if (isGameOver) return;

    String userInput = controllers.map((c) => c.text.toLowerCase()).join();
    if (userInput.length != targetWord.length) return;

    setState(() {
      attempts[currentAttempt] = userInput.split('');
      currentAttempt++;

      for (int i = 0; i < targetWord.length; i++) {
        String letter = userInput[i];
        if (!guessedLetters.contains(letter)) {
          guessedLetters.add(letter);
          if (targetWord[i] == letter) {
            letterColors[letter] = Colors.green;
          } else if (targetWord.contains(letter)) {
            letterColors[letter] = Colors.yellow;
          } else {
            letterColors[letter] = Colors.grey;
          }
        }
      }

      controllers.forEach((controller) => controller.clear());

      if (currentAttempt < maxAttempts) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          focusNodes[0].requestFocus();
        });
      }

      if (userInput == targetWord) {
        _navigateToVictoryScreen(message: "🎉 You Win!");
      } else if (currentAttempt >= maxAttempts) {
        _navigateToVictoryScreen(message: "😞 Game Over!\nCorrect word was: $targetWord");
      }
    });
  }

  void _navigateToVictoryScreen({String message = "You Win!"}) {
    setState(() {
      isGameOver = true;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VictoryScreen(message: message),
      ),
    );
  }

  Color getLetterColor(int attemptIndex, int letterIndex) {
    String word = attempts[attemptIndex].join();
    if (word.length != targetWord.length) return Colors.white;

    if (word[letterIndex] == targetWord[letterIndex]) {
      return Colors.green;
    } else if (targetWord.contains(word[letterIndex])) {
      return Colors.yellow;
    } else {
      return Colors.grey;
    }
  }

  Color getKeyboardButtonColor(String letter) {
    return letterColors[letter] ?? Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Word Guess Game")),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              // 🧠 Instruction Box
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text("Guess the word in $maxAttempts tries."),
                      SizedBox(height: 6),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          children: [
                            WidgetSpan(
                              child: Container(
                                width: 16,
                                height: 16,
                                color: Colors.green,
                                margin: EdgeInsets.only(right: 6),
                              ),
                            ),
                            TextSpan(text: "Letter is correct and in the correct position.\n"),
                            WidgetSpan(
                              child: Container(
                                width: 16,
                                height: 16,
                                color: Colors.yellow,
                                margin: EdgeInsets.only(right: 6),
                              ),
                            ),
                            TextSpan(text: "Letter is in the word but in the wrong position.\n"),
                            WidgetSpan(
                              child: Container(
                                width: 16,
                                height: 16,
                                color: Colors.grey,
                                margin: EdgeInsets.only(right: 6),
                              ),
                            ),
                            TextSpan(text: "Letter is not in the word."),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Word Rows
              for (int i = 0; i < maxAttempts; i++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(targetWord.length, (index) {
                    bool isEditable = (i == currentAttempt && !isGameOver);
                    return Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: i < currentAttempt ? getLetterColor(i, index) : Colors.white,
                        border: Border.all(
                          color: isEditable ? Colors.blue : Colors.black,
                          width: isEditable ? 3 : 1,
                        ),
                      ),
                      child: isEditable
                          ? TextField(
                              controller: controllers[index],
                              focusNode: focusNodes[index],
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              textCapitalization: TextCapitalization.characters,
                              style: TextStyle(fontSize: 24),
                              decoration: InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < targetWord.length - 1) {
                                  focusNodes[index + 1].requestFocus();
                                }
                              },
                              onSubmitted: (_) => checkWord(),
                            )
                          : Text(
                              attempts[i][index].toUpperCase(),
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                    );
                  }),
                ),

              SizedBox(height: 10),
              if (currentAttempt < maxAttempts && !isGameOver)
                ElevatedButton(
                  onPressed: checkWord,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: Text("Submit"),
                ),
              Spacer(),

              // ⌨️ Remaining Letters
              Text(
                "Remaining Letters:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.center,
                children: List.generate(26, (index) {
                  String letter = String.fromCharCode(index + 97);

                  if (letterColors[letter] == Colors.grey) {
                    return SizedBox.shrink();
                  }

                  return GestureDetector(
                    onTap: () {
                      if (!guessedLetters.contains(letter) && !isGameOver) {
                        guessedLetters.add(letter);
                        setState(() {});
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 40,
                      height: 40,
                      margin: EdgeInsets.all(4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: getKeyboardButtonColor(letter),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Text(
                        letter.toUpperCase(),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class VictoryScreen extends StatelessWidget {
  final String message;

  VictoryScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black26)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Game6()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepOrange,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: Text("Play Again"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
