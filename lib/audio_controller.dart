import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioController extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  int _currentTrack = 1;

  Future<void> play(int track) async {
    _currentTrack = track;
    await _player.stop();
    await _player.play(AssetSource('audio/track$_currentTrack.mp3'),
        volume: 0.5);
  }

  Future<void> stop() async {
    await _player.stop();
  }
}
