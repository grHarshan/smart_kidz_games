import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_notifier.dart';
import 'audio_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AudioController _audioController = AudioController();
  late bool isMusicEnabled;
  late int selectedTrack;
  bool startWithSignup = false;

  @override
  void initState() {
    super.initState();
    isMusicEnabled = _audioController.isMusicEnabled;
    selectedTrack = _audioController.currentTrack;
    _loadStartWithSignup();
  }

  Future<void> _loadStartWithSignup() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      startWithSignup = prefs.getBool('startWithSignup') ?? false;
    });
  }

  Future<void> _setStartWithSignup(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('startWithSignup', value);
    setState(() {
      startWithSignup = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text("Dark Mode"),
              value: themeNotifier.isDarkMode,
              onChanged: (val) => themeNotifier.toggleTheme(val),
            ),
            SwitchListTile(
              title: const Text("Background Music"),
              value: isMusicEnabled,
              onChanged: (val) {
                setState(() {
                  isMusicEnabled = val;
                });
                _audioController.setMusicEnabled(val);
              },
            ),
            const SizedBox(height: 20),
            const Text("Choose Music Track"),
            DropdownButton<int>(
              value: selectedTrack,
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    selectedTrack = val;
                  });
                  _audioController.play(selectedTrack);
                }
              },
              items: [1, 2, 3]
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text('Track $e'),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 30),
            SwitchListTile(
  title: const Text("Start with Sign Up Page"),
  value: startWithSignup,
  onChanged: (val) => _setStartWithSignup(val),
),
const Padding(
  padding: EdgeInsets.only(left: 16.0),
  child: Align(
    alignment: Alignment.centerLeft,
    child: Text(
      "Recommend to active login a parent's permission for this kids game app",
      style: TextStyle(fontSize: 12, color: Colors.grey),
    ),
  ),
),
          ],
        ),
      ),
    );
  }
}
