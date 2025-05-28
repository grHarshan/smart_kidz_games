import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    isMusicEnabled = _audioController.isMusicEnabled;
    selectedTrack = _audioController.currentTrack;
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
          ],
        ),
      ),
    );
  }
}
