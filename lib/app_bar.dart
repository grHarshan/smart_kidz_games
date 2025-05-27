import 'dart:async';
import 'package:flutter/material.dart';

class SimpleAppBar extends StatefulWidget {
  final VoidCallback? onHomePressed;
  final VoidCallback? onProfilePressed;

  const SimpleAppBar({
    super.key,
    this.onHomePressed,
    this.onProfilePressed,
  });

  @override
  State<SimpleAppBar> createState() => _SimpleAppBarState();
}

class _SimpleAppBarState extends State<SimpleAppBar> {
  late Timer _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    // Start the timer when the app bar is built
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get formattedTime {
    final minutes = _seconds ~/ 60;
    final seconds = _seconds % 60;
    return "${minutes}m ${seconds}s";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(221, 36, 163, 76),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Home button
            IconButton(
              icon: Icon(Icons.home, color: Colors.amber),
              onPressed: widget.onHomePressed,
            ),

            // Timer
            Text(
              "Play Time: $formattedTime",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Profile button
            IconButton(
              icon: Icon(Icons.person, color: Colors.amber),
              onPressed: widget.onProfilePressed,
            ),
          ],
        ),
      ),
    );
  }
}
