import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'app_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String parentName = '';
  String kidName = '';

  late Timer _timer;
  int _liveSeconds = 0;
  int _totalSeconds = 0;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
    _loadTotalPlayTime();
    _startLiveTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _saveTotalPlayTime();
    super.dispose();
  }

  Future<void> _loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      parentName = prefs.getString('parentName') ?? '';
      kidName = prefs.getString('kidName') ?? '';
    });
  }

  Future<void> _loadTotalPlayTime() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalSeconds = prefs.getInt('totalPlayTime') ?? 0;
    });
  }

  Future<void> _saveTotalPlayTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalPlayTime', _totalSeconds + _liveSeconds);
  }

  void _startLiveTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _liveSeconds++;
      });
    });
  }
Future<void> _logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', false); // Just update the session status
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
}


  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return [
      if (hours > 0) hours.toString().padLeft(2, '0'),
      minutes.toString().padLeft(2, '0'),
      secs.toString().padLeft(2, '0')
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
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
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/H1.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.5)),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🎮 Kid\'s Profile 🎲',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFA726),
                    shadows: [
                      Shadow(blurRadius: 5, color: Colors.black54, offset: Offset(2, 2)),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  "Parent's Name: $parentName",
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  "Kid's Name: $kidName",
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 30),
                Text(
                  "⏳ Current Session Time: ${_formatTime(_liveSeconds)}",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  "🎉 Total Play Time Today: ${_formatTime(_totalSeconds + _liveSeconds)}",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6C2A),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text(
                      'LOGOUT',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
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
