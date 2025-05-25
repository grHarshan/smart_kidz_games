import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class Game3 extends StatefulWidget {
  const Game3({super.key});

  @override
  State<Game3> createState() => _Game3State();
}

class _Game3State extends State<Game3> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<List<Offset>> _allDrawnPoints = [[]]; // Store all drawing points
  String _currentLetter = 'A';
  int _currentLetterIndex = 0;
  bool _showAnimation = true;
  double _completionPercentage = 0.0;
  bool _dialogShown = false; // Flag to prevent multiple dialogs
  DateTime? _completionStartTime; // Track when user first reached completion threshold
  
  // Drawing settings
  final double _strokeWidth = 12.0;
  final Color _drawingColor = const Color(0xFF6A1B9A); // Deep purple
  final bool _smoothDrawing = true; // Enable smooth drawing
  
  // Animation settings
  late Animation<double> _backgroundAnimation;
  final List<Map<String, dynamic>> _letters = [
    {
      'letter': 'A',
      'image': 'assets/images/apple.jpg', 
      'instruction': 'Draw the letter A',
      'path': [Offset(75, 150), Offset(100, 50), Offset(125, 150), Offset(115, 100), Offset(85, 100)],
    },
    {
      'letter': 'B',
      'image': 'assets/images/ball.png', 
      'instruction': 'Draw the letter B',
      'path': [Offset(50, 50), Offset(50, 150), Offset(50, 100), Offset(125, 75), Offset(50, 50), Offset(50, 100), Offset(125, 125), Offset(50, 150)],
    },
    {
      'letter': 'C',
      'image': 'assets/images/cat.png', 
      'instruction': 'Draw the letter C',
      'path': [Offset(125, 75), Offset(100, 60), Offset(75, 75), Offset(60, 100), Offset(75, 125), Offset(100, 140), Offset(125, 125)],
    },
  ];
  @override
  void initState() {
    super.initState();
    // Initialize animation controller with slower animation for better guidance
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
      setState(() {});
    });
    
    // Setup background animation
    _backgroundAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
    
    // Start the animation
    _animationController.repeat();
    
    // Trigger haptic feedback when the app starts
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }  void _handleDragStart(DragStartDetails details) {
    // Trigger light haptic feedback for better tactile experience
    HapticFeedback.lightImpact();
    
    setState(() {
      // Start a new line with the first point
      _allDrawnPoints.add([details.localPosition]);
      _showAnimation = false;
    });
    
    _calculateCompletionPercentage();
  }
  
  void _handleDragUpdate(DragUpdateDetails details) {
    // Get current position
    final Offset currentPoint = details.localPosition;
    
    setState(() {
      // Only add point if we have an active stroke
      if (_allDrawnPoints.isNotEmpty) {
        final List<Offset> currentStroke = _allDrawnPoints.last;
        
        // If smooth drawing is enabled and we have previous points
        if (_smoothDrawing && currentStroke.isNotEmpty) {
          final Offset prevPoint = currentStroke.last;
          
          // Calculate distance between points
          final double distance = (currentPoint - prevPoint).distance;
          
          // If points are too far apart, interpolate between them for smoother lines
          // This is especially important for finger drawing where movement can be quick
          if (distance > 8.0) {
            final int segments = (distance ~/ 4).clamp(1, 10);
            
            for (int i = 1; i <= segments; i++) {
              final double t = i / segments;
              final Offset interpolatedPoint = Offset(
                prevPoint.dx + (currentPoint.dx - prevPoint.dx) * t,
                prevPoint.dy + (currentPoint.dy - prevPoint.dy) * t,
              );
              currentStroke.add(interpolatedPoint);
            }
          } else {
            // Otherwise just add the current point
            currentStroke.add(currentPoint);
          }
        } else {
          // Just add the point if smoothing is disabled
          currentStroke.add(currentPoint);
        }
      }
    });
    
    _calculateCompletionPercentage();
    
    // Only consider completion if we've drawn enough points
    // Make sure the user has drawn at least a certain number of points
    int totalPoints = 0;
    for (var pointList in _allDrawnPoints) {
      totalPoints += pointList.length;
    }
    
    // Only start checking for completion after user has drawn at least 30 points
    if (totalPoints < 30) {
      _completionStartTime = null;
      return;
    }
      // Check completion threshold (higher - 98%) and dialog not already shown
    // Using a very high threshold to ensure the letter is truly complete
    if (_completionPercentage >= 0.98 && !_dialogShown) {
      // Record the first time user reached threshold
      _completionStartTime ??= DateTime.now();
      
      // If completion threshold has been met for 1.5 seconds, show dialog
      // This longer delay ensures they've really completed it
      if (DateTime.now().difference(_completionStartTime!).inMilliseconds >= 1500) {
        setState(() {
          _dialogShown = true;
        });
        
        // Slight delay before showing dialog to let user see completed drawing
        Future.delayed(Duration(milliseconds: 300), () {
          _showCompletionDialog();
        });
      }
    } else if (_completionPercentage < 0.95) {
      // Reset timer if percentage drops below a certain threshold
      // Using an even higher drop threshold to prevent false triggers
      _completionStartTime = null;
    }
  }  void _calculateCompletionPercentage() {
    // Count total points across all drawn lines
    int totalPoints = 0;
    for (var pointList in _allDrawnPoints) {
      totalPoints += pointList.length;
    }
    
    if (totalPoints == 0) {
      _completionPercentage = 0.0;
      return;
    }
    
    // Get the current letter's path
    final List<Offset> letterPath = _letters[_currentLetterIndex]['path'];
    
    // Check if the user has drawn near each point in the letter's path
    int pointsMatched = 0;
    // Reduce proximity threshold to require more precision
    final double proximityThreshold = 25.0;
    
    // For each point in the letter path, check if the user drew near it
    for (Offset pathPoint in letterPath) {
      bool pointMatched = false;
      
      // Check against every point the user has drawn
      for (List<Offset> stroke in _allDrawnPoints) {
        for (Offset drawnPoint in stroke) {
          if ((pathPoint - drawnPoint).distance <= proximityThreshold) {
            pointMatched = true;
            break;
          }
        }
        if (pointMatched) break;
      }
      
      if (pointMatched) {
        pointsMatched++;
      }
    }
    
    // Calculate completion percentage based on matched points
    // Increase required match ratio to at least 80% of the letter's points
    final double matchRatio = pointsMatched / letterPath.length;
    
    // Add a minimum points threshold to ensure some drawing has occurred
    int minPointsNeeded;
    switch (_currentLetter) {
      case 'I':
        minPointsNeeded = 45; // Simpler letter
        break;
      case 'A':
      case 'V':
      case 'W':
        minPointsNeeded = 80; // Medium complexity
        break;
      case 'B': 
      case 'D':
      case 'P':
      case 'R':
        minPointsNeeded = 120; // More complex
        break;
      default:
        minPointsNeeded = 90; // Default threshold
    }
      // Check for sequence accuracy - did the user follow the right order of points?
    double sequenceAccuracy = 0.0;
    if (totalPoints >= 15) { // Only check sequence if enough points have been drawn
      // Simplify user's drawn path to key points for comparison
      List<Offset> simplifiedDrawnPath = _simplifyPath(_allDrawnPoints);
      
      // Compare direction changes in simplified path to letter path
      if (simplifiedDrawnPath.length >= 3 && letterPath.length >= 3) {
        // Check if the general shape follows the letter's outline
        sequenceAccuracy = _comparePathShapes(simplifiedDrawnPath, letterPath);
      }
    }
      // Calculate final completion percentage with more weight on path accuracy
    double pointsCompletion = math.min(1.0, totalPoints / minPointsNeeded);
    double pathAccuracy = matchRatio * 0.8 + (sequenceAccuracy * 0.2); // Much heavier weight on matched points
    
    // Implement stricter requirements for completion:
    // 1. Must have drawn at least minimum points
    // 2. Must have very high path accuracy
    if (pointsCompletion < 0.7) {
      // If not enough points drawn yet, cap the maximum completion percentage
      _completionPercentage = math.min(0.7, (pointsCompletion * 0.2) + (pathAccuracy * 0.8));
    } else {
      // When enough points are drawn, focus more on path accuracy
      _completionPercentage = (pointsCompletion * 0.2) + (pathAccuracy * 0.8);
      
      // If they matched almost all points but maybe in wrong sequence, still give high score
      if (matchRatio > 0.9) {
        _completionPercentage = math.max(_completionPercentage, 0.9);
      }
    }
    
    // Make the final stretch more challenging - exponential curve at the end
    if (_completionPercentage > 0.85) {
      double normalizedPercentage = (_completionPercentage - 0.85) / 0.15; // Scale to 0-1 for the final stretch
      double adjustedFinalStretch = math.pow(normalizedPercentage, 1.5) / 1.0; // Apply exponential curve
      _completionPercentage = 0.85 + (adjustedFinalStretch * 0.15); // Rescale back
    }
    
    // Clamp between 0 and 1 for safety
    _completionPercentage = math.max(0.0, math.min(1.0, _completionPercentage));
  }
  
  // Helper method to simplify paths for comparison
  List<Offset> _simplifyPath(List<List<Offset>> allStrokes) {
    // Combine all strokes and take sample points for simplification
    List<Offset> result = [];
    
    for (var stroke in allStrokes) {
      if (stroke.length < 2) continue;
      
      // Add first point of each stroke
      result.add(stroke.first);
      
      // Sample points from longer strokes
      if (stroke.length > 10) {
        for (int i = 1; i < stroke.length - 1; i += (stroke.length ~/ 10).clamp(1, 10)) {
          result.add(stroke[i]);
        }
      }
      
      // Add last point of each stroke
      result.add(stroke.last);
    }
    
    return result;
  }
  
  // Helper method to compare path shapes
  double _comparePathShapes(List<Offset> drawnPath, List<Offset> letterPath) {
    // Simple shape comparison - calculate general direction alignment
    int directionMatches = 0;
    int totalDirections = math.min(drawnPath.length - 2, letterPath.length - 2);
    
    if (totalDirections <= 0) return 0.0;
    
    for (int i = 0; i < totalDirections; i++) {
      // Calculate direction vectors for user path
      final Offset drawnDir = drawnPath[i + 1] - drawnPath[i];
      final Offset letterDir = letterPath[i + 1] - letterPath[i];
      
      // Calculate angle between vectors using dot product
      final double dotProduct = (drawnDir.dx * letterDir.dx) + (drawnDir.dy * letterDir.dy);
      final double drawnMag = math.sqrt((drawnDir.dx * drawnDir.dx) + (drawnDir.dy * drawnDir.dy));
      final double letterMag = math.sqrt((letterDir.dx * letterDir.dx) + (letterDir.dy * letterDir.dy));
      
      // Avoid division by zero
      if (drawnMag > 0 && letterMag > 0) {
        final double cosAngle = dotProduct / (drawnMag * letterMag);
        
        // Consider directions similar if angle is less than ~45 degrees
        if (cosAngle > 0.7) {
          directionMatches++;
        }
      }
    }
    
    return directionMatches / totalDirections;
  }

  void _nextLetter() {
    setState(() {
      _currentLetterIndex = (_currentLetterIndex + 1) % _letters.length;
      _currentLetter = _letters[_currentLetterIndex]['letter'];
      _allDrawnPoints = [[]];
      _completionPercentage = 0.0;
      _showAnimation = true;
      _dialogShown = false; // Reset dialog flag for new letter
      _completionStartTime = null; // Reset completion timer
    });
  }
  void _restartDrawing() {
    setState(() {
      _allDrawnPoints = [[]];
      _completionPercentage = 0.0;
      _showAnimation = true;
      _dialogShown = false; // Reset dialog flag when restarting
      _completionStartTime = null; // Reset completion timer
    });
  }  void _showCompletionDialog() {
    // Provide haptic feedback on completion
    HapticFeedback.mediumImpact();
    
    // Play success sound if you want to add sound effects:
    // SystemSound.play(SystemSoundType.click);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.purple.shade300, Colors.indigo.shade500],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Celebration icon
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer glow effect
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [Colors.amber.withOpacity(0.7), Colors.amber.withOpacity(0.0)],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                    ),
                    // Star icon
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 80,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Title with shadow effect
                Text(
                  'Amazing Job!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    shadows: [
                      Shadow(
                        blurRadius: 8.0,
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // Message with animation
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    'You successfully drew the letter $_currentLetter!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Subtext
                Text(
                  'Perfect writing!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.amber[200],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Draw Again button
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Draw Again'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                        backgroundColor: Colors.white,
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).pop();
                        _restartDrawing();
                      },
                    ),
                    // Next Letter button with glow effect
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Next Letter'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          Navigator.of(context).pop();
                          _nextLetter();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // Method to generate an animated background pattern
  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: BackgroundPatternPainter(
            animation: _backgroundAnimation.value,
            color1: Colors.indigo.shade100,
            color2: Colors.purple.shade50,
          ),
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final currentLetterData = _letters[_currentLetterIndex];
    
    return Scaffold(
      extendBodyBehindAppBar: true, // Allow body to extend behind app bar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Let's Draw Letter $_currentLetter", 
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple.withOpacity(0.7), Colors.indigo.withOpacity(0.7)],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)], // Soft cyan colors
          ),
        ),
        child: Stack(
          children: [
            // Animated pattern background
            _buildAnimatedBackground(),
            
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Instructions and progress
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                    child: Column(
                      children: [
                        // Instruction with animated background
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade100, Colors.indigo.shade100],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.gesture,
                                color: Colors.indigo,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  currentLetterData['instruction'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Enhanced progress bar
                        Stack(
                          children: [
                            // Progress bar background with gradient
                            Container(
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            // Animated progress indicator
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 12,
                              width: MediaQuery.of(context).size.width * 0.9 * _completionPercentage,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.green, Colors.lightGreen],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.5),
                                    blurRadius: _completionPercentage > 0.9 ? 6 : 0,
                                    spreadRadius: _completionPercentage > 0.9 ? 1 : 0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        // Progress text
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              '${(_completionPercentage * 100).toInt()}% completed',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Letter and image row with enhanced design
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        // Letter template with animation
                        Hero(
                          tag: 'letter_$_currentLetter',
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.indigo.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Letter with shadow
                                Text(
                                  _currentLetter,
                                  style: TextStyle(
                                    fontSize: 100,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade300,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 2,
                                        offset: const Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Pulsating highlight effect when animation is shown
                                if (_showAnimation)
                                  TweenAnimationBuilder<double>(
                                    tween: Tween<double>(begin: 0.0, end: 1.0),
                                    duration: const Duration(seconds: 2),
                                    builder: (context, value, child) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              Colors.blue.withOpacity(0.3 * (1 - value)),
                                              Colors.blue.withOpacity(0),
                                            ],
                                            stops: const [0.4, 1.0],
                                            radius: 0.7 + (0.3 * value),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Image related to letter with enhanced design
                        Expanded(
                          child: Container(
                            height: 140,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.grey.shade50],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _currentLetter == 'A' ? Icons.apple : (_currentLetter == 'B' ? Icons.sports_baseball : Icons.pets),
                                      size: 50,
                                      color: Colors.indigo.shade300,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Image for '$_currentLetter'",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.indigo.shade400,
                                      ),
                                    ),
                                    // In a real app, use this for actual images:
                                    // Image.asset(
                                    //   currentLetterData['image'],
                                    //   fit: BoxFit.contain,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Drawing area with enhanced appearance
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Paper texture background
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                  image: const NetworkImage(
                                    'https://www.transparenttextures.com/patterns/paper-fibers.png'
                                  ),
                                  repeat: ImageRepeat.repeat,
                                  opacity: 0.2,
                                ),
                              ),
                            ),
                            
                            // Guide letter
                            Center(
                              child: Text(
                                _currentLetter,
                                style: TextStyle(
                                  fontSize: 220,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[200],
                                ),
                              ),
                            ),
                            
                            // Animation
                            if (_showAnimation)
                              CustomPaint(
                                size: Size.infinite,
                                painter: AnimatedLetterPainter(
                                  path: currentLetterData['path'],
                                  animationValue: _animationController.value,
                                  color: Colors.blue.shade400,
                                ),
                              ),
                              
                            // User drawing with enhanced appearance
                            CustomPaint(
                              size: Size.infinite,
                              painter: DrawingPainter(
                                allPoints: _allDrawnPoints,
                                strokeWidth: _strokeWidth,
                                drawingColor: _drawingColor,
                              ),
                            ),
                            
                            // Touch detector with feedback
                            GestureDetector(
                              onPanStart: _handleDragStart,
                              onPanUpdate: _handleDragUpdate,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Action buttons with enhanced design
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Restart button
                        ElevatedButton.icon(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            _restartDrawing();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text("Restart"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            shadowColor: Colors.orange.withOpacity(0.5),
                          ),
                        ),
                        
                        // Show animation button
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _showAnimation = true;
                              _animationController.reset();
                              _animationController.forward();
                            });
                            HapticFeedback.lightImpact();
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text("Show Me"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            shadowColor: Colors.blue.withOpacity(0.5),
                          ),
                        ),
                        
                        // Next letter button
                        ElevatedButton.icon(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            _nextLetter();
                          },
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text("Next Letter"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            shadowColor: Colors.green.withOpacity(0.5),
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
      ),
    );
  }
}

class AnimatedLetterPainter extends CustomPainter {
  final List<Offset> path;
  final double animationValue;
  final Color color;
  
  AnimatedLetterPainter({
    required this.path, 
    required this.animationValue, 
    required this.color,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    if (path.length < 2) return;
    
    final pathLength = _getPathLength(path);
    final currentDistance = pathLength * animationValue;
    double distanceCovered = 0;
    
    // Draw guiding path with fading trail
    // First draw the full path with transparency to show where to go
    final guidePathPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    
    // Create a full path for guiding
    final guidePath = Path();
    guidePath.moveTo(path.first.dx, path.first.dy);
    
    // Create smoother curves between points
    for (int i = 0; i < path.length - 1; i++) {
      if (i < path.length - 2) {
        // Use quadratic curves for smoother path
        final xc = (path[i].dx + path[i + 1].dx) / 2;
        final yc = (path[i].dy + path[i + 1].dy) / 2;
        guidePath.quadraticBezierTo(path[i].dx, path[i].dy, xc, yc);
      } else {
        // For last segment
        guidePath.lineTo(path[i + 1].dx, path[i + 1].dy);
      }
    }
    
    // Draw the guide path with low opacity
    canvas.drawPath(guidePath, guidePathPaint);
    
    // Draw animated stroke with higher opacity
    final Path animatedPath = Path();
    animatedPath.moveTo(path.first.dx, path.first.dy);
    
    // Keep track of last point to smoothly connect segments
    Offset lastPoint = path.first;
    
    for (int i = 0; i < path.length - 1; i++) {
      final start = path[i];
      final end = path[i + 1];
      final segmentLength = (end - start).distance;
      
      if (i < path.length - 2) {
        final xc = (start.dx + end.dx) / 2;
        final yc = (start.dy + end.dy) / 2;
        
        if (distanceCovered + segmentLength <= currentDistance) {
          // Draw full segment with smooth curve
          animatedPath.quadraticBezierTo(start.dx, start.dy, xc, yc);
          distanceCovered += segmentLength;
          lastPoint = Offset(xc, yc);
        } else if (distanceCovered < currentDistance) {
          // Draw partial segment
          final remainingDistance = currentDistance - distanceCovered;
          final t = remainingDistance / segmentLength;
          
          // Calculate intermediate point
          final partialX = start.dx + (xc - start.dx) * t;
          final partialY = start.dy + (yc - start.dy) * t;
          
          animatedPath.quadraticBezierTo(start.dx, start.dy, partialX, partialY);
          lastPoint = Offset(partialX, partialY);
          break;
        }
      } else {
        // For the last segment
        if (distanceCovered + segmentLength <= currentDistance) {
          animatedPath.lineTo(end.dx, end.dy);
          lastPoint = end;
        } else if (distanceCovered < currentDistance) {
          final remainingDistance = currentDistance - distanceCovered;
          final t = remainingDistance / segmentLength;
          
          final partialEnd = Offset(
            start.dx + (end.dx - start.dx) * t,
            start.dy + (end.dy - start.dy) * t,
          );
          
          animatedPath.lineTo(partialEnd.dx, partialEnd.dy);
          lastPoint = partialEnd;
        }
      }
    }
    
    // Draw main animated path with gradient stroke
    final Paint animatedPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(size.width, size.height),
        [color, color.withBlue((color.blue + 60) % 255)],
      )
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    
    // Add drop shadow to the animated path for depth
    canvas.drawPath(
      animatedPath,
      Paint()
        ..color = Colors.black.withOpacity(0.2)
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    
    canvas.drawPath(animatedPath, animatedPaint);
    
    // Draw animated finger dot with glow effect
    if (animationValue > 0) {
      // Draw larger soft glow
      canvas.drawCircle(
        lastPoint,
        20,
        Paint()
          ..color = Colors.red.withOpacity(0.3)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
      
      // Draw smaller bright core with shadow
      canvas.drawCircle(
        lastPoint,
        12,
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
      );
      
      // Draw finger icon indicating touch
      final fingerIconPath = Path();
      const double iconSize = 10.0;
      
      // Add a simple hand/finger shape
      fingerIconPath.moveTo(lastPoint.dx, lastPoint.dy - iconSize);
      fingerIconPath.lineTo(lastPoint.dx + iconSize, lastPoint.dy - iconSize * 0.3);
      fingerIconPath.lineTo(lastPoint.dx + iconSize * 0.7, lastPoint.dy + iconSize * 0.7);
      fingerIconPath.lineTo(lastPoint.dx, lastPoint.dy + iconSize * 0.5);
      fingerIconPath.lineTo(lastPoint.dx - iconSize * 0.7, lastPoint.dy + iconSize * 0.7);
      fingerIconPath.lineTo(lastPoint.dx - iconSize, lastPoint.dy - iconSize * 0.3);
      fingerIconPath.close();
      
      // Draw the finger icon with subtle animation (bounce effect)
      final double bounce = (math.sin(animationValue * math.pi * 5) * 2);
      canvas.save();
      canvas.translate(0, bounce);
      canvas.drawPath(
        fingerIconPath,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill,
      );
      canvas.restore();
    }
    
    // Draw arrow indicators at the start of the path when animation begins
    if (animationValue < 0.2) {
      final double arrowOpacity = 1.0 - (animationValue * 5);
      if (arrowOpacity > 0) {
        final arrowPaint = Paint()
          ..color = Colors.green.withOpacity(arrowOpacity)
          ..style = PaintingStyle.fill;
        
        // Draw an arrow at the start point
        final Offset startPoint = path.first;
        final double arrowSize = 12.0;
        
        // Determine direction between first two points
        final Offset direction = path[1] - path[0];
        final double angle = math.atan2(direction.dy, direction.dx);
        
        // Draw arrow
        final Path arrowPath = Path();
        arrowPath.moveTo(
          startPoint.dx - arrowSize * math.cos(angle + math.pi / 6),
          startPoint.dy - arrowSize * math.sin(angle + math.pi / 6),
        );
        arrowPath.lineTo(startPoint.dx, startPoint.dy);
        arrowPath.lineTo(
          startPoint.dx - arrowSize * math.cos(angle - math.pi / 6),
          startPoint.dy - arrowSize * math.sin(angle - math.pi / 6),
        );
        arrowPath.close();
        
        canvas.drawPath(arrowPath, arrowPaint);
        
        // Draw "Start Here" text
        final TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: 'Start Here',
            style: TextStyle(
              color: Colors.green.withOpacity(arrowOpacity),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        
        // Position text near the start point
        textPainter.paint(
          canvas,
          Offset(
            startPoint.dx - textPainter.width / 2,
            startPoint.dy - 30,
          ),
        );
      }
    }
  }
  
  double _getPathLength(List<Offset> path) {
    double length = 0;
    for (int i = 0; i < path.length - 1; i++) {
      length += (path[i + 1] - path[i]).distance;
    }
    return length;
  }
  
  @override
  bool shouldRepaint(covariant AnimatedLetterPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.color != color;
  }
}

class DrawingPainter extends CustomPainter {
  final List<List<Offset>> allPoints;
  final double strokeWidth;
  final Color drawingColor;
  
  DrawingPainter({
    required this.allPoints, 
    this.strokeWidth = 10.0,
    this.drawingColor = const Color(0xFF6A1B9A),
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = drawingColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;  // Makes the drawing smoother
    
    // Draw each stroke separately
    for (List<Offset> points in allPoints) {
      // Skip empty lists
      if (points.length < 2) continue;
      
      // Create a path for smoother rendering
      final path = Path();
      path.moveTo(points.first.dx, points.first.dy);
      
      // For smoother curves, we'll use quadratic bezier curves
      for (int i = 0; i < points.length - 1; i++) {
        // If we have enough points, create a smooth curve
        if (i < points.length - 2) {
          final xc = (points[i].dx + points[i + 1].dx) / 2;
          final yc = (points[i].dy + points[i + 1].dy) / 2;
          path.quadraticBezierTo(points[i].dx, points[i].dy, xc, yc);
        } else {
          // For the last segment, just draw to the point
          path.lineTo(points[i + 1].dx, points[i + 1].dy);
        }
      }
      
      // Draw the path
      canvas.drawPath(path, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return oldDelegate.allPoints != allPoints || 
           oldDelegate.strokeWidth != strokeWidth ||
           oldDelegate.drawingColor != drawingColor;
  }
}

// Background pattern painter for animated patterns
class BackgroundPatternPainter extends CustomPainter {
  final double animation;
  final Color color1;
  final Color color2;
  
  BackgroundPatternPainter({
    required this.animation,
    required this.color1,
    required this.color2,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    
    // Create subtle background patterns that move with animation
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    // Draw animated curved lines pattern
    for (int i = 0; i < 8; i++) {
      double offset = i * 50;
      double wave = 20 * math.sin(animation + (i * 0.3));
      
      final path = Path();
      paint.color = i % 2 == 0 ? color1 : color2;
      
      // Horizontal wavy lines
      path.moveTo(0, offset + wave);
      for (double x = 0; x <= width; x += width / 20) {
        double y = offset + 20 * math.sin((x / width) * 2 * math.pi + animation + (i * 0.3));
        path.lineTo(x, y);
      }
      
      // Vertical wavy lines
      path.moveTo(offset + wave, 0);
      for (double y = 0; y <= height; y += height / 20) {
        double x = offset + 20 * math.sin((y / height) * 2 * math.pi + animation + (i * 0.3));
        path.lineTo(x, y);
      }
      
      canvas.drawPath(path, paint);
    }
    
    // Draw subtle circles
    for (int i = 0; i < 5; i++) {
      final circlePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = (i % 2 == 0 ? color1 : color2).withOpacity(0.3);
      
      double radius = 50 + (i * 40);
      double offsetX = width / 2 + 30 * math.cos(animation * 0.5 + i);
      double offsetY = height / 2 + 30 * math.sin(animation * 0.5 + i);
      
      canvas.drawCircle(Offset(offsetX, offsetY), radius, circlePaint);
    }
  }
  
  @override
  bool shouldRepaint(covariant BackgroundPatternPainter oldDelegate) {
    return oldDelegate.animation != animation ||
           oldDelegate.color1 != color1 ||
           oldDelegate.color2 != color2;
  }
}