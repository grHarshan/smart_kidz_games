import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:math' as math;
import 'app_bar.dart'; 

class Game4 extends StatelessWidget {
  const Game4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ShapeColorGame();
  }
}

class ShapeColorGame extends StatefulWidget {
  const ShapeColorGame({Key? key}) : super(key: key);

  @override
  State<ShapeColorGame> createState() => _ShapeColorGameState();
}

class _ShapeColorGameState extends State<ShapeColorGame> {
  int currentLevel = 1;
  Map<String, bool> score = {};
  List<String> remainingColors = [];

  final Map<int, Map<String, String>> levelAnswers = {
    1: {
      'square': 'ORANGE',
      'triangle': 'BLUE',
      'circle': 'PINK',
    },
    2: {
      'rectangle': 'GREEN',
      'oval': 'PURPLE',
      'rhombus': 'RED',
      'star': 'YELLOW',
    },
    3: {
      'pentagon': 'YELLOW',
      'hexagon': 'RED',
      'parallelogram': 'TEAL',
      'heptagon': 'BROWN',
      'octagon': 'CYAN',
    }
  };

  final Map<String, Color> colorMap = {
    'ORANGE': Colors.orange,
    'BLUE': Colors.blue,
    'PINK': Colors.pinkAccent,
    'GREEN': Colors.green,
    'PURPLE': Colors.purple,
    'YELLOW': Colors.yellow,
    'RED': Colors.red,
    'TEAL': Colors.teal,
    'BROWN': Colors.brown,
    'CYAN': Colors.cyan,
  };

  @override
  void initState() {
    super.initState();
    remainingColors = levelAnswers[currentLevel]!.values.toList();
  }

  void restartLevel(int level) {
    setState(() {
      currentLevel = level;
      score.clear();
      remainingColors = levelAnswers[level]!.values.toList();
    });
  }

  double getShapeSize() {
    switch (currentLevel) {
      case 1:
        return 120; // smaller shapes for level 1 (from 140)
      case 2:
        return 110; // medium shapes for level 2
      case 3:
        return 80; // smaller shapes for level 3
      default:
        return 110;
    }
  }

  double getTargetWidth() {
    switch (currentLevel) {
      case 1:
        return 120; // smaller width for selection field level 1
      case 2:
        return 150; // medium width for level 2
      case 3:
        return 110; // smaller width for level 3
      default:
        return 150;
    }
  }

  double getTargetHeight() {
    switch (currentLevel) {
      case 1:
        return 35; // smaller height for level 1
      case 2:
        return 45; // medium height for level 2
      case 3:
        return 35; // smaller height for level 3
      default:
        return 45;
    }
  }

  double getSpacingBetweenShapeAndTarget() {
    switch (currentLevel) {
      case 1:
        return 15;
      case 2:
        return 20;
      case 3:
        return 12;
      default:
        return 20;
    }
  }

  @override
  Widget build(BuildContext context) {
    final answers = levelAnswers[currentLevel]!;
    final shapeSize = getShapeSize();
    final targetWidth = getTargetWidth();
    final targetHeight = getTargetHeight();
    final spacing = getSpacingBetweenShapeAndTarget();

    final availableHeight = MediaQuery.of(context).size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Scaffold(
      appBar: SimpleAppBar(
    onHomePressed: () {
      Navigator.popUntil(context, (route) => route.isFirst);
    },
    onProfilePressed: () {
      Navigator.pushNamed(context, '/profile');
    },
  ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/G4.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                height: availableHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...answers.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: shapeWithTarget(
                          shape: entry.key,
                          color: colorMap[entry.value]!,
                          size: shapeSize,
                          targetWidth: targetWidth,
                          targetHeight: targetHeight,
                          spacing: spacing,
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 15),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 15,
                      runSpacing: 10,
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
                    const SizedBox(height: 20),
                  ],
                ),
              ),
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
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: colorMap[text],
      ),
    );
  }

  Widget shapeWithTarget({
    required String shape,
    required Color color,
    required double size,
    required double targetWidth,
    required double targetHeight,
    required double spacing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: getShapePainter(shape, color),
          ),
          SizedBox(width: spacing),
          DragTarget<String>(
            builder: (context, candidateData, rejectedData) {
              return DottedBorder(
                color: Colors.black,
                dashPattern: const [5, 3],
                strokeWidth: 2,
                child: Container(
                  width: targetWidth,
                  height: targetHeight,
                  alignment: Alignment.center,
                  child: score[shape] == true
                      ? colorNameText(levelAnswers[currentLevel]![shape]!)
                      : const Text(''),
                ),
              );
            },
            onWillAccept: (data) => true,
            onAccept: (data) {
              if (data == levelAnswers[currentLevel]![shape]) {
                setState(() {
                  score[shape] = true;
                  remainingColors.remove(data);
                });

                if (score.length == levelAnswers[currentLevel]!.length &&
                    score.values.every((v) => v)) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (currentLevel < 3) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("🎉 Level Complete!"),
                          content: Text("Go to level ${currentLevel + 1}?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                restartLevel(currentLevel + 1);
                              },
                              child: const Text("Next Level"),
                            ),
                          ],
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("🏆 You Won!"),
                          content: const Text("Play again from level 1?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                restartLevel(1);
                              },
                              child: const Text("Play Again"),
                            ),
                          ],
                        ),
                      );
                    }
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
      ),
    );
  }

  CustomPainter getShapePainter(String shape, Color color) {
    switch (shape) {
      case 'triangle':
        return TrianglePainter(color);
      case 'oval':
        return OvalPainter(color);
      case 'pentagon':
        return PolygonPainter(color, sides: 5);
      case 'hexagon':
        return PolygonPainter(color, sides: 6);
      case 'heptagon':
        return PolygonPainter(color, sides: 7);
      case 'octagon':
        return PolygonPainter(color, sides: 8);
      case 'rhombus':
        return RhombusPainter(color);
      case 'parallelogram':
        return ParallelogramPainter(color);
      case 'star':
        return StarPainter(color);
      default:
        return ShapePainter(shape, color);
    }
  }
}

 
class ShapePainter extends CustomPainter {
  final String shape;
  final Color color;

  ShapePainter(this.shape, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final border = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    if (shape == 'circle') {
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, paint);
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, border);
    } else if (shape == 'rectangle') {
      final rect = Rect.fromLTWH(0, 0, size.width, size.height / 2);
      canvas.drawRect(rect, paint);
      canvas.drawRect(rect, border);
    } else {
      final rect = Rect.fromLTWH(0, 0, size.width, size.height);
      canvas.drawRect(rect, paint);
      canvas.drawRect(rect, border);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final border = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, border);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class OvalPainter extends CustomPainter {
  final Color color;
  OvalPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final border = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height / 2);
    canvas.drawOval(rect, paint);
    canvas.drawOval(rect, border);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class PolygonPainter extends CustomPainter {
  final Color color;
  final int sides;

  PolygonPainter(this.color, {required this.sides});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final border = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    final angle = (2 * math.pi) / sides;
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < sides; i++) {
      final x = center.dx + radius * math.cos(i * angle);
      final y = center.dy + radius * math.sin(i * angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, border);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class RhombusPainter extends CustomPainter {
  final Color color;
  RhombusPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final border = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, size.height / 2)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, border);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ParallelogramPainter extends CustomPainter {
  final Color color;
  ParallelogramPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final border = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path()
      ..moveTo(size.width * 0.25, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width * 0.75, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, border);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class StarPainter extends CustomPainter {
  final Color color;
  StarPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final border = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius / 2.5;
    const points = 5;
    final angle = (2 * math.pi) / points;

    for (int i = 0; i < points * 2; i++) {
      final r = (i % 2 == 0) ? outerRadius : innerRadius;
      final x = center.dx + r * math.cos(i * angle / 2 - math.pi / 2);
      final y = center.dy + r * math.sin(i * angle / 2 - math.pi / 2);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, border);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
