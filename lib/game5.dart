import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'app_bar.dart';

class Game5 extends StatefulWidget {
  const Game5({Key? key}) : super(key: key);

  @override
  State<Game5> createState() => _PepperSortingGameState();
}

class _PepperSortingGameState extends State<Game5>
    with SingleTickerProviderStateMixin {
  final List<Pepper> _peppers = [];
  late Ticker _ticker;
  int _score = 0;
  int _timeLeft = 180;
  bool _gameStarted = false;
  int _correctMatches = 0;
  int _wrongMatches = 0;
  int _bigBasketCount = 0;
  int _smallBasketCount = 0;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      _updatePepperPositions();
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _score = 0;
      _timeLeft = 180;
      _gameStarted = true;
      _correctMatches = 0;
      _wrongMatches = 0;
      _bigBasketCount = 0;
      _smallBasketCount = 0;
      _peppers.clear();
    });

    _ticker.start();
    _addNewPepperPeriodically();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          _endGame();
        }
      });
    });
  }

  void _addNewPepperPeriodically() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_gameStarted) {
        timer.cancel();
        return;
      }
      if (_peppers.length < 8) _addNewPepper();
    });
  }

  void _addNewPepper() {
    final rand = Random();
    setState(() {
      _peppers.add(
        Pepper(
          id: UniqueKey().toString(),
          isBig: rand.nextBool(),
          xPosition: rand.nextDouble() * 0.8 + 0.1,
          yPosition: 0.0,
        ),
      );
    });
  }

  void _updatePepperPositions() {
    setState(() {
      for (int i = _peppers.length - 1; i >= 0; i--) {
        final p = _peppers[i];
        p.yPosition += 0.005;
        if (p.yPosition > 1.0) {
          _peppers.removeAt(i);
          if (_gameStarted) {
            _score -= 5;
          }
        }
      }
    });
  }

  void _checkDrop(Pepper pepper, bool boxIsBig) {
    if (!_peppers.contains(pepper)) return;
    setState(() {
      _peppers.remove(pepper);
      if ((pepper.isBig && boxIsBig) || (!pepper.isBig && !boxIsBig)) {
        _score += 10;
        _correctMatches++;
        boxIsBig ? _bigBasketCount++ : _smallBasketCount++;
      } else {
        _score -= 5;
        _wrongMatches++;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Oops! Try matching the correct pepper size."),
          duration: Duration(seconds: 2),
        ));
      }
    });
  }

  void _endGame() {
    _ticker.stop();
    _countdownTimer?.cancel();
    setState(() {
      _gameStarted = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Game Over'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Score: $_score'),
            Text('Correct: $_correctMatches'),
            Text('Wrong: $_wrongMatches'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
          _buildBackground(),
          if (!_gameStarted) _buildStartOverlay(),
          ..._peppers.map((pepper) {
            return Positioned(
              left: pepper.xPosition * size.width - 30,
              top: pepper.yPosition * (size.height - 140),
              child: Draggable<Pepper>(
                data: pepper,
                feedback: _buildPepperImage(pepper.isBig),
                childWhenDragging: const SizedBox(),
                onDragEnd: (details) {
                  final dx = details.offset.dx;
                  final dy = details.offset.dy;
                  if (dy > size.height - 160) {
                    _checkDrop(pepper, dx < size.width / 2);
                  }
                },
                child: _buildPepperImage(pepper.isBig),
              ),
            );
          }),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBasket(true, _bigBasketCount),
                _buildBasket(false, _smallBasketCount),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                _buildInfoBox("Score: $_score"),
                const SizedBox(height: 10),
                if (_gameStarted)
                  _buildInfoBox("Time: ${_formatTime(_timeLeft)}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.lightBlue),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(100, 135, 206, 250),
                  Color.fromARGB(100, 152, 251, 152),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.6),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pepper Jump',
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sort the peppers!\nDrag big ones to the left basket and small ones to the right!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child:
                    const Text('Start Game', style: TextStyle(fontSize: 20)),
              ),
              if (_correctMatches + _wrongMatches > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Text('Correct Matches: $_correctMatches',
                          style: const TextStyle(
                              color: Colors.green, fontSize: 16)),
                      Text('Wrong Matches: $_wrongMatches',
                          style: const TextStyle(
                              color: Colors.red, fontSize: 16)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPepperImage(bool isBig) {
    return Image.asset(
      'assets/images/pepper.jpg',
      width: isBig ? 70 : 50,
      height: isBig ? 70 : 50,
      errorBuilder: (_, __, ___) => Container(
        width: isBig ? 70 : 50,
        height: isBig ? 70 : 50,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildBasket(bool isBig, int count) {
    return Column(
      children: [
        DragTarget<Pepper>(
          onAccept: (pepper) => _checkDrop(pepper, isBig),
          builder: (_, __, ___) {
            return SizedBox(
              width: isBig ? 120 : 90,
              height: isBig ? 120 : 90,
              child: Image.asset('assets/images/Basket.jpg',
                  fit: BoxFit.contain),
            );
          },
        ),
        const SizedBox(height: 5),
        Text('Count: $count',
            style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildInfoBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }
}

// Pepper class
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
