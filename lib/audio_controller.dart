import 'package:audioplayers/audioplayers.dart';

class AudioController {
  static final AudioController _instance = AudioController._internal();
  factory AudioController() => _instance;
  AudioController._internal();

  final AudioPlayer _player = AudioPlayer();
  int _currentTrack = 1;
  bool _isPlaying = false;
  bool _isMusicEnabled = true;

  bool get isMusicEnabled => _isMusicEnabled;

  void setMusicEnabled(bool enabled) {
    _isMusicEnabled = enabled;
    if (!enabled) {
      stop();
    } else {
      play(_currentTrack);
    }
  }

  Future<void> play(int track) async {
    _currentTrack = track;
    if (!_isMusicEnabled) return;
    await _player.stop();
    await _player.play(
      AssetSource('audio/track$_currentTrack.mp3'),
      volume: 0.5,
    );
    _isPlaying = true;
  }

  Future<void> stop() async {
    await _player.stop();
    _isPlaying = false;
  }

  int get currentTrack => _currentTrack;
}
