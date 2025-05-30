import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game1.dart';
import 'game2.dart';
import 'game3.dart';
import 'game4.dart';
import 'game5.dart';
import 'game6.dart';
import 'game7.dart';
import 'settings_page.dart';
import 'theme_notifier.dart';
import 'audio_controller.dart';

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
    {
      'title': 'Game 7',
      'color': const Color.fromARGB(255, 208, 211, 14),
      'page': Game7()
    },
  ];

  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _animations;
  late AnimationController _settingsController;
  late Animation<Offset> _settingsAnimation;

  List<bool> _hovering = [];
  bool _hoveringSettings = false;

  final AudioController _audioController = AudioController();

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      games.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _animations = _controllers
        .map((controller) => Tween<Offset>(
              begin: const Offset(0, 0.6),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: controller,
              curve: Curves.elasticOut,
            )))
        .toList();

    _hovering = List.generate(games.length, (_) => false);

    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: 100 * i), () {
        _controllers[i].forward();
      });
    }

    // Initialize settings icon animation
    _settingsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _settingsAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _settingsController,
      curve: Curves.elasticOut,
    ));

    Future.delayed(Duration(milliseconds: 100 * games.length), () {
      _settingsController.forward();
    });

    // Start background music
    _audioController.play(1);
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _settingsController.dispose();
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
    final isDark = Provider.of<ThemeNotifier>(context).isDarkMode;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/H1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Dark Overlay
          if (isDark)
            Container(
              color: Colors.black.withOpacity(0.5),
            ),

          // Settings Icon with Animation
          Positioned(
            bottom: 24,
            right: 24,
            child: MouseRegion(
              onEnter: (_) => setState(() => _hoveringSettings = true),
              onExit: (_) => setState(() => _hoveringSettings = false),
              child: SlideTransition(
                position: _settingsAnimation,
                child: AnimatedScale(
                  scale: _hoveringSettings ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SettingsPage()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(Icons.settings,
                          color: Colors.white, size: 30),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Game Buttons
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(games.length, (index) {
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
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
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
                                      offset: const Offset(2, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    game['title'],
                                    style: const TextStyle(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
