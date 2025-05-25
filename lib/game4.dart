import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class Game4 extends StatelessWidget {
  const Game4({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShapeColorGame();
  }
}

class ShapeColorGame extends StatefulWidget {
  const ShapeColorGame({super.key});

  @override
  State<ShapeColorGame> createState() => _ShapeColorGameState();
}

class _ShapeColorGameState extends State<ShapeColorGame> {
  Map<String, bool> score = {};
  final Map<String, String> correctAnswers = {
    'square': 'ORANGE',
    'triangle': 'BLUE',
    'circle': 'PINK',
  };

  List<String> remainingColors = ['ORANGE', 'BLUE', 'PINK'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game 4'),
        backgroundColor: const Color.fromARGB(255, 255, 251, 146),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        
      ),
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset(
              'assets/images/G4.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                shapeWithTarget('square', Colors.orange, 100),
                shapeWithTarget('triangle', Colors.cyan, 100, isTriangle: true),
                shapeWithTarget('circle', Colors.pinkAccent, 100, isCircle: true),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  children: remainingColors.map((text) {
                    return Draggable<String>(
                      data: text,
                      feedback: colorNameText(text),
                      childWhenDragging: Opacity(
                        opacity: 0.4,
                        child: colorNameText(text),
                      ),
                      child: colorNameText(text),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget colorNameText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: text == 'ORANGE'
            ? Colors.orange
            : text == 'BLUE'
                ? Colors.blue
                : Colors.pinkAccent,
      ),
    );
  }

  Widget shapeWithTarget(String shape, Color color, double size,
      {bool isTriangle = false, bool isCircle = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isTriangle
            ? CustomPaint(
                size: Size(size, size),
                painter: TrianglePainter(color),
              )
            : Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: color,
                  shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
                ),
              ),
        const SizedBox(width: 20),
        DragTarget<String>(
          builder: (context, candidateData, rejectedData) {
            return DottedBorder(
              color: Colors.black,
              dashPattern: [6, 3],
              strokeWidth: 2,
              child: Container(
                width: 120,
                height: 40,
                alignment: Alignment.center,
                child: score[shape] == true
                    ? colorNameText(correctAnswers[shape]!)
                    : const Text(''),
              ),
            );
          },
          onWillAcceptWithDetails: (data) => true,
          onAcceptWithDetails: (data) {
            if (data == correctAnswers[shape]) {
              setState(() {
                score[shape] = true;
                remainingColors.remove(data);
              });
              if (score.length == correctAnswers.length &&
                  score.values.every((v) => v)) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("🎉 Congratulations!"),
                      content: const Text("You won! Try again?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              score.clear();
                              remainingColors = ['ORANGE', 'BLUE', 'PINK'];
                            });
                          },
                          child: const Text("Play Again"),
                        ),
                      ],
                    ),
                  );
                });
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('❌ Wrong! Try again.'),
                  duration: Duration(seconds: 1),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
