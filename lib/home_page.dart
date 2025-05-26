import 'package:flutter/material.dart';
import 'game1.dart';
import 'game2.dart';
import 'game3.dart';
import 'game4.dart';
import 'game5.dart';
import 'game6.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> games = [
    {'title': 'Game 1', 'color': Colors.yellow[200], 'page': Game1()},
    {'title': 'Game 2', 'color': Colors.purple[300], 'page': Game2()},
    {'title': 'Game 3', 'color': Colors.cyan[300], 'page': Game3()},
    {'title': 'Game 4', 'color': Colors.pinkAccent[100], 'page': Game4()},
    {'title': 'Game 5', 'color': Colors.lightGreenAccent[100], 'page': Game5()},
    {'title': 'Game 6', 'color': Colors.orange[200], 'page': Game6()},
  ];

  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _animations;
  List<bool> _hovering = [];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      games.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _animations = _controllers
        .map((controller) => Tween<Offset>(
              begin: Offset(0, 0.6),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: controller,
              curve: Curves.elasticOut, // More playful
            )))
        .toList();

    _hovering = List.generate(games.length, (_) => false);

    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: 100 * i), () {
        _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/H1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Game Buttons
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(games.length, (index) {
                  final game = games[index];
                  return SlideTransition(
                    position: _animations[index],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: MouseRegion(
                        onEnter: (_) {
                          setState(() => _hovering[index] = true);
                        },
                        onExit: (_) {
                          setState(() => _hovering[index] = false);
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(_createRoute(game['page']));
                          },
                          child: AnimatedScale(
                            scale: _hovering[index] ? 1.08 : 1.0,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: 260,
                              height: 65,
                              decoration: BoxDecoration(
                                color: game['color'],
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: _hovering[index]
                                        ? Colors.white.withOpacity(0.6)
                                        : Colors.black26,
                                    blurRadius: _hovering[index] ? 12 : 4,
                                    offset: Offset(2, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  game['title'],
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'ComicSans',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
