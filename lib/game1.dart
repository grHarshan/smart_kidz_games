import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'app_bar.dart'; 

class Game1 extends StatelessWidget {
  const Game1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
          // Background image
          Positioned.fill(
            child: Image.asset(
              "assets/images/background1.png",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "🎨 Alphabet Drawing Game",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Learn to write the English alphabet!",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 86, 145, 255),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => AlphabetGameMain()),
                    );
                  },
                  child: Text(
                    "Start Game",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Data class for all letters
class AlphabetLetter {
  final String letter;
  final String imagePath;
  final List<Offset> animationPoints;
  bool isUnlocked;
  int starRating; // 0-3 stars based on drawing accuracy
  
  AlphabetLetter({
    required this.letter, 
    required this.imagePath, 
    required this.animationPoints,
    this.isUnlocked = false,
    this.starRating = 0,
  });
}

class AlphabetGameMain extends StatefulWidget {
  const AlphabetGameMain({super.key});

  @override
  _AlphabetGameMainState createState() => _AlphabetGameMainState();
}

class _AlphabetGameMainState extends State<AlphabetGameMain> with SingleTickerProviderStateMixin {
  // Current letter index
  int currentIndex = 0;
  
  // Show letter selection grid
  bool showLetterGrid = true;
  
  // Drawing paths for user
  List<List<Offset>> userStrokes = [];
  
  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  // Success tracking
  bool showAnimation = true;
  bool letterCompleted = false;
  bool showSuccess = false;
  
  // Alphabet data with animation points
  late List<AlphabetLetter> alphabet;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize the animation controller
    _animationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            showAnimation = false;
          });
        }
      });
    
    // Initialize alphabet data with animation points
    initializeAlphabetData();
    
    // First letter is unlocked by default
    alphabet[0].isUnlocked = true;
  }
  
  void initializeAlphabetData() {
    // Create animation points for each letter (simplified for example)
    // In a real application, these would be more detailed and accurate
    alphabet = [
      AlphabetLetter(
        letter: 'A',
        imagePath: 'assets/images/apple.jpg', // Placeholder - you'd add actual images
        animationPoints: _createLetterAPoints(),
      ),
      AlphabetLetter(
        letter: 'B',
        imagePath: 'assets/images/bird.jpg', // Using an existing image from assets
        animationPoints: _createLetterBPoints(),
      ),
      AlphabetLetter(
        letter: 'C',
        imagePath: 'assets/images/cat.jpg', // Using an existing image from assets
        animationPoints: _createLetterCPoints(),
      ),
      AlphabetLetter(
        letter: 'D',
        imagePath: 'assets/images/dog.jpg', // Using an existing image from assets
        animationPoints: _createLetterDPoints(),
      ),
      // More letters would be added here
    ];
  }
  
  // Helper methods to create animation points for letters
  List<Offset> _createLetterAPoints() {
    // These points would trace the letter A
    // They are simplified for demonstration
    double centerX = 180;
    List<Offset> points = [];
    
    // Left diagonal stroke
    for (double t = 0; t <= 1; t += 0.01) {
      points.add(Offset(centerX - 50 + t * 50, 240 - t * 120));
    }
    
    // Right diagonal stroke
    for (double t = 0; t <= 1; t += 0.01) {
      points.add(Offset(centerX + t * 50, 120 + t * 120));
    }
    
    // Middle horizontal stroke
    for (double t = 0; t <= 1; t += 0.01) {
      points.add(Offset(centerX - 30 + t * 60, 180));
    }
    
    return points;
  }
  
  List<Offset> _createLetterBPoints() {
    double centerX = 180;
    List<Offset> points = [];
    
    // Vertical stroke
    for (double t = 0; t <= 1; t += 0.01) {
      points.add(Offset(centerX - 40, 120 + t * 120));
    }
    
    // Top curve
    for (double t = 0; t <= 1; t += 0.01) {
      double angle = -90 + t * 180;
      double radian = angle * (3.14159 / 180);
      points.add(Offset(
        centerX - 40 + 40 * math.cos(radian),
        120 + 30 + 30 * math.sin(radian)
      ));
    }
    
    // Bottom curve
    for (double t = 0; t <= 1; t += 0.01) {
      double angle = -90 + t * 180;
      double radian = angle * (3.14159 / 180);
      points.add(Offset(
        centerX - 40 + 40 * math.cos(radian),
        180 + 30 + 30 * math.sin(radian)
      ));
    }
    
    return points;
  }
  
  List<Offset> _createLetterCPoints() {
    double centerX = 180;
    List<Offset> points = [];
    
    // C curve
    for (double t = 0; t <= 0.75; t += 0.01) {
      double angle = -60 + t * 300;
      double radian = angle * (3.14159 / 180);
      points.add(Offset(
        centerX + 40 * math.cos(radian),
        180 + 60 * math.sin(radian)
      ));
    }
    
    return points;
  }
  
  List<Offset> _createLetterDPoints() {
    double centerX = 180;
    List<Offset> points = [];
    
    // Vertical stroke
    for (double t = 0; t <= 1; t += 0.01) {
      points.add(Offset(centerX - 40, 120 + t * 120));
    }
    
    // Curved part
    for (double t = 0; t <= 1; t += 0.01) {
      double angle = -90 + t * 180;
      double radian = angle * (3.14159 / 180);
      points.add(Offset(
        centerX - 40 + 50 * math.cos(radian),
        180 + 60 * math.sin(radian)
      ));
    }
    
    return points;
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void _addStroke(List<Offset> points) {
    setState(() {
      userStrokes.add(points);
    });
  }
  void _checkLetterDrawing() {
    // More advanced implementation to check drawing accuracy
    
    if (userStrokes.isEmpty) {
      _showTryAgainDialog();
      return;
    }
    
    // Calculate how well the user's drawing matches the expected pattern
    int accuracy = _calculateDrawingAccuracy();
    
    if (accuracy > 30) { // Threshold for acceptance
      int starCount = 1; // Default 1 star
      
      // Determine star rating based on accuracy
      if (accuracy > 80) {
        starCount = 3; // Perfect drawing - 3 stars
      } else if (accuracy > 60) {
        starCount = 2; // Good drawing - 2 stars  
      }
      
      setState(() {
        letterCompleted = true;
        showSuccess = true;
        // Store the higher star rating if user improves
        if (starCount > alphabet[currentIndex].starRating) {
          alphabet[currentIndex].starRating = starCount;
        }
        
        // Hide success message after a delay
        Timer(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              showSuccess = false;
            });
          }
        });
      });
    } else {
      _showTryAgainDialog();
    }
  }
  
  // Calculate drawing accuracy by comparing with expected letter path
  int _calculateDrawingAccuracy() {
    // This is a simplified implementation
    // A real implementation would use shape matching algorithms
    
    // For now, we'll simulate different accuracy levels
    // Based on stroke count, stroke length and coverage of drawing area
    
    int totalPoints = 0;
    int totalStrokes = userStrokes.length;
    
    // Check if the user has enough strokes for the letter
    bool hasEnoughStrokes = false;
    
    // Different letters need different number of strokes
    switch(alphabet[currentIndex].letter) {
      case 'A': // A typically needs 3 strokes
        hasEnoughStrokes = totalStrokes >= 2;
        break;
      case 'B': // B typically needs 3 strokes (vertical + two curves)
        hasEnoughStrokes = totalStrokes >= 2;
        break;
      case 'C': // C typically needs 1 stroke
        hasEnoughStrokes = totalStrokes >= 1;
        break;
      case 'D': // D typically needs 2 strokes
        hasEnoughStrokes = totalStrokes >= 1;
        break;
      default:
        hasEnoughStrokes = totalStrokes >= 1;
    }
    
    if (hasEnoughStrokes) {
      totalPoints += 40;
    }
    
    // Check stroke length - longer strokes usually indicate more careful drawing
    int totalLength = 0;
    for (var stroke in userStrokes) {
      totalLength += stroke.length;
    }
    
    if (totalLength > 100) {
      totalPoints += 30;
    } else if (totalLength > 50) {
      totalPoints += 15;
    }
    
    // Check drawing coverage (did they draw in the right area)
    // For a real app, this would compare with the target letter's path
    totalPoints += 20; // Giving some base points
    
    // Random variation to simulate some inaccuracy in the algorithm
    totalPoints += (DateTime.now().millisecond % 20);
    
    return totalPoints.clamp(0, 100); // Return score between 0-100
  }
  
  void _showTryAgainDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Try Again", style: TextStyle(fontSize: 22)),
        content: Text("Please trace the letter completely."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
  
  void _nextLetter() {
    if (currentIndex < alphabet.length - 1) {
      setState(() {
        currentIndex++;
        userStrokes.clear();
        letterCompleted = false;
        showAnimation = true;
        showSuccess = false;
        _animationController.reset();
        _animationController.forward();
      });
    } else {
      // All letters completed
      _showGameCompletedDialog();
    }
  }
  
  void _showGameCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text("🎉 Game Completed!", style: TextStyle(fontSize: 22)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("You've learned to write all the letters!"),
            SizedBox(height: 20),
            Image.asset(
              "assets/images/logo.png",
              height: 100,
              width: 100,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (_) => Game1())
              );
            },
            child: Text("Play Again"),
          ),
        ],
      ),
    );
  }
  
  void _resetDrawing() {
    setState(() {
      userStrokes.clear();
    });
  }
  
  void _unlockNextLetter() {
    if (currentIndex < alphabet.length - 1) {
      setState(() {
        alphabet[currentIndex + 1].isUnlocked = true;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
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
          // Background image
          Positioned.fill(
            child: Image.asset(
              "assets/images/background1.png",
              fit: BoxFit.cover,
            ),
          ),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Letter and associated image
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Big letter display
                    Container(
                      margin: EdgeInsets.all(15),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          alphabet[currentIndex].letter,
                          style: TextStyle(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    
                    // Associated image
                    Container(
                      margin: EdgeInsets.all(15),
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          alphabet[currentIndex].imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 10),
                
                // Instructions
                Text(
                  showAnimation 
                      ? "Watch how to write it..." 
                      : "Now you try! Trace the letter:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 10),
                
                if (!showLetterGrid)
                  // Drawing area
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.blue,
                          width: 3,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Guide letter (faint)
                          CustomPaint(
                            size: Size.infinite,
                            painter: GuidePainter(
                              letter: alphabet[currentIndex].letter,
                            ),
                          ),
                          
                          // Animation of how to write
                          if (showAnimation)
                            CustomPaint(
                              size: Size.infinite,
                              painter: AnimationPainter(
                                points: alphabet[currentIndex].animationPoints,
                                progress: _animation.value,
                              ),
                            ),
                            
                          // User's drawing
                          if (!showAnimation)
                            GestureDetector(
                              onPanStart: (details) {
                                if (!letterCompleted) {
                                  _addStroke([details.localPosition]);
                                }
                              },
                              onPanUpdate: (details) {
                                if (!letterCompleted && userStrokes.isNotEmpty) {
                                  setState(() {
                                    userStrokes.last.add(details.localPosition);
                                  });
                                }
                              },
                              child: CustomPaint(
                                size: Size.infinite,
                                painter: DrawingPainter(
                                  strokes: userStrokes,
                                ),
                              ),
                            ),
                            
                          // Success overlay
                          if (showSuccess)
                            Container(
                              color: Colors.green.withOpacity(0.3),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green, size: 60),
                                      Text(
                                        "Great job!",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(3, (index) {
                                          return Icon(
                                            Icons.star,
                                            color: index < alphabet[currentIndex].starRating
                                                ? Colors.amber
                                                : Colors.grey.shade300,
                                            size: 30,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                
                if (!showLetterGrid)
                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(Icons.cleaning_services),
                          label: Text("Clear"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          onPressed: showAnimation || letterCompleted ? null : _resetDrawing,
                        ),
                        
                        ElevatedButton.icon(
                          icon: Icon(Icons.check),
                          label: Text("Check"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          onPressed: showAnimation || letterCompleted ? null : _checkLetterDrawing,
                        ),
                        
                        ElevatedButton.icon(
                          icon: Icon(Icons.arrow_forward),
                          label: Text("Next"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          onPressed: letterCompleted ? () {
                            _nextLetter();
                            _unlockNextLetter();
                          } : null,
                        ),
                      ],
                    ),
                  ),
                
                // Letter selection grid                if (showLetterGrid)
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Select a letter to practice",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.all(8),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6, // Increase columns from 3 to 6
                              crossAxisSpacing: 6,
                              mainAxisSpacing: 6,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: alphabet.length,
                            itemBuilder: (context, index) {
                              final letterData = alphabet[index];
                              
                              return GestureDetector(
                                onTap: letterData.isUnlocked ? () {
                                  setState(() {
                                    currentIndex = index;
                                    showLetterGrid = false;
                                    userStrokes.clear();
                                    letterCompleted = false;
                                    showAnimation = true;
                                    showSuccess = false;
                                    _animationController.reset();
                                    _animationController.forward();
                                  });
                                } : null,                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: letterData.isUnlocked ? Colors.white : Colors.grey[300],
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 5,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          letterData.letter,
                                          style: TextStyle(
                                            fontSize: 20, // Slightly smaller font
                                            fontWeight: FontWeight.bold,
                                            color: letterData.isUnlocked ? Colors.blue : Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ),
                                      // Lock icon
                                    if (!letterData.isUnlocked)
                                      Positioned(
                                        right: 5,
                                        top: 5,
                                        child: Icon(Icons.lock, color: Colors.black45, size: 16),
                                      ),
                                    
                                    // Star rating
                                    if (letterData.starRating > 0)
                                      Positioned(
                                        bottom: 5,
                                        left: 0,
                                        right: 0,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: List.generate(letterData.starRating, (i) {
                                            return Icon(Icons.star, color: Colors.amber, size: 14);
                                          }),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      // Add a button to go back to letter grid
      floatingActionButton: !showLetterGrid ? FloatingActionButton(
        onPressed: () {
          setState(() {
            showLetterGrid = true;
          });
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.grid_view),
      ) : null,
    );
  }
}

// Painter for the animation showing how to write the letter
class AnimationPainter extends CustomPainter {
  final List<Offset> points;
  final double progress;
  
  AnimationPainter({required this.points, required this.progress});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    
    int endIndex = (points.length * progress).floor();
    
    if (endIndex > 0) {
      path.moveTo(points[0].dx, points[0].dy);
      
      for (int i = 1; i < endIndex; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      
      canvas.drawPath(path, paint);
    }
  }
  
  @override
  bool shouldRepaint(AnimationPainter oldDelegate) => 
      oldDelegate.progress != progress;
}

// Painter for the user's drawing
class DrawingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  
  DrawingPainter({required this.strokes});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    for (final stroke in strokes) {
      if (stroke.length < 2) continue;
      
      final path = Path();
      path.moveTo(stroke.first.dx, stroke.first.dy);
      
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      
      canvas.drawPath(path, paint);
    }
  }
  
  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

// Faint guide for the letter
class GuidePainter extends CustomPainter {
  final String letter;
  
  GuidePainter({required this.letter});
  
  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: Colors.grey.withOpacity(0.3),
      fontSize: 250,
      fontWeight: FontWeight.bold,
    );
    
    final textSpan = TextSpan(
      text: letter,
      style: textStyle,
    );
    
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    textPainter.layout();
    
    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    
    textPainter.paint(canvas, offset);
  }
    @override
  bool shouldRepaint(GuidePainter oldDelegate) => 
      oldDelegate.letter != letter;
}

