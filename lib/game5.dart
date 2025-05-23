import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';


class PepperSortingGame extends StatefulWidget {
  const PepperSortingGame({Key? key}) : super(key: key);

  @override
  State<PepperSortingGame> createState() => _PepperSortingGameState();
}

class _PepperSortingGameState extends State<PepperSortingGame> {
  final List<Pepper> _peppers = [];
  int _score = 0;
  Timer? _gameTimer;
  Timer? _countdownTimer;
  int _timeLeft = 180; // 3 minutes
  bool _gameStarted = false;
  int _correctMatches = 0;
  int _wrongMatches = 0;

  @override
  void dispose() {
    _gameTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _gameStarted = true;
      _score = 0;
      _correctMatches = 0;
      _wrongMatches = 0;
      _peppers.clear();
      _timeLeft = 180;
    });

    _gameTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      _addNewPepper();
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          _endGame();
        }
      });
    });
  }

  void _endGame() {
    _gameTimer?.cancel();
    _countdownTimer?.cancel();

    setState(() {
      _gameStarted = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Final Score: $_score'),
            Text('Correct Matches: $_correctMatches'),
            Text('Wrong Matches: $_wrongMatches'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _addNewPepper() {
    if (_peppers.length >= 8) return;

    final random = Random();
    final isBig = random.nextBool();
    final initialX = random.nextDouble() * 0.8 + 0.1;

    setState(() {
      _peppers.add(
        Pepper(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          isBig: isBig,
          xPosition: initialX,
          yPosition: 0.0,
        ),
      );
    });
  }

  void _updatePepperPositions() {
    setState(() {
      for (int i = _peppers.length - 1; i >= 0; i--) {
        final pepper = _peppers[i];
        pepper.yPosition += 0.01;
        if (pepper.yPosition > 1.0) {
          _peppers.removeAt(i);
          _score -= 5;
        }
      }
    });
  }

  void _checkBoxDrop(Pepper pepper, bool boxIsBig) {
    setState(() {
      _peppers.remove(pepper);
      if ((pepper.isBig && boxIsBig) || (!pepper.isBig && !boxIsBig)) {
        _score += 10;
        _correctMatches++;
      } else {
        _score -= 5;
        _wrongMatches++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_gameStarted) {
      Future.delayed(const Duration(milliseconds: 50), _updatePepperPositions);
    }

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Positioned(left: 20, top: 100, child: _buildCloud(100, 60)),
          Positioned(right: 40, top: 150, child: _buildCloud(120, 70)),
          Positioned(left: 150, top: 200, child: _buildCloud(90, 50)),
          Positioned(left: 50, bottom: 200, child: _buildTree()),
          Positioned(
            top: 20,
            left: 20,
            child: InkWell(
              onTap: () {
                if (_gameStarted) {
                  _endGame();
                }
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBasket(true),
                _buildBasket(false),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Column(
              children: [
                _buildScoreBox('Score: $_score'),
                const SizedBox(height: 10),
                if (_gameStarted)
                  _buildScoreBox('Time: ${_formatTime(_timeLeft)}'),
              ],
            ),
          ),
          ..._buildPeppers(),
          if (!_gameStarted) _buildStartScreen(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF40E0D0), Color(0xFFB0E57C)],
            stops: [0.6, 0.6],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBox(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  Widget _buildStartScreen() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pepper Jump',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text(
                'Let’s play and learn!',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('Start Game', style: TextStyle(fontSize: 20)),
              ),
              if (_correctMatches > 0 || _wrongMatches > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Text('Correct matches: $_correctMatches',
                          style: const TextStyle(
                              color: Colors.green, fontSize: 18)),
                      Text('Wrong matches: $_wrongMatches',
                          style:
                              const TextStyle(color: Colors.red, fontSize: 18)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCloud(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  Widget _buildTree() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.green.shade300,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        Container(
          width: 20,
          height: 40,
          color: Colors.brown,
        ),
      ],
    );
  }

  List<Widget> _buildPeppers() {
    final List<Widget> pepperWidgets = [];
    final size = MediaQuery.of(context).size;

    for (final pepper in _peppers) {
      pepperWidgets.add(
        Positioned(
          left: pepper.xPosition * size.width - 30,
          top: pepper.yPosition * (size.height - 120),
          child: Draggable<Pepper>(
            data: pepper,
            feedback: _buildPepperImage(pepper.isBig),
            childWhenDragging: const SizedBox(),
            onDragEnd: (details) {
              final dx = details.offset.dx;
              final dy = details.offset.dy;
              final basketY = size.height - 60;

              if (dy > basketY) {
                if (dx < size.width / 2) {
                  _checkBoxDrop(pepper, true);
                } else {
                  _checkBoxDrop(pepper, false);
                }
              }
            },
            child: _buildPepperImage(pepper.isBig),
          ),
        ),
      );
    }

    return pepperWidgets;
  }

  Widget _buildPepperImage(bool isBig) {
    return Image.asset(
      'assets/pepper.png',
      width: isBig ? 60 : 40,
      height: isBig ? 60 : 40,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: isBig ? 60 : 40,
          height: isBig ? 60 : 40,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBasket(bool isBig) {
    return DragTarget<Pepper>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: isBig ? 100 : 85,
          height: isBig ? 100 : 85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.asset(
            isBig ? 'assets/Basket.png' : 'assets/Basket.png',
            fit: BoxFit.contain,
          ),
        );
      },
      onAccept: (pepper) => _checkBoxDrop(pepper, isBig),
    );
  }
}

class Pepper {
  final String id;
  final bool isBig;
  double xPosition;
  double yPosition;

  Pepper({
    required this.id,
    required this.isBig,
    required this.xPosition,
    required this.yPosition,
  });
}
