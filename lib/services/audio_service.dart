import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _bgMusicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  bool _isMusicEnabled = true;
  bool _isSfxEnabled = true;

  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  void setMusicEnabled(bool enabled) {
    _isMusicEnabled = enabled;
    if (!enabled) _bgMusicPlayer.pause();
  }

  void setSfxEnabled(bool enabled) {
    _isSfxEnabled = enabled;
  }

  Future<void> playBGM() async {
    if (!_isMusicEnabled) return;
    await _bgMusicPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgMusicPlayer.play(AssetSource('audio/bgm.mp3'));
  }

  Future<void> stopBGM() async {
    await _bgMusicPlayer.stop();
  }

  Future<void> playCorrect() async {
    if (!_isSfxEnabled) return;
    await _sfxPlayer.play(AssetSource('audio/correct.mp3'));
  }

  Future<void> playWrong() async {
    if (!_isSfxEnabled) return;
    await _sfxPlayer.play(AssetSource('audio/wrong.mp3'));
  }

  Future<void> playStar() async {
    if (!_isSfxEnabled) return;
    await _sfxPlayer.play(AssetSource('audio/star.mp3'));
  }

  Future<void> playClick() async {
    if (!_isSfxEnabled) return;
    await _sfxPlayer.play(AssetSource('audio/click.mp3'));
  }

  Future<void> playWin() async {
    if (!_isSfxEnabled) return;
    await _sfxPlayer.play(AssetSource('audio/win.mp3'));
  }

  void dispose() {
    _bgMusicPlayer.dispose();
    _sfxPlayer.dispose();
  }
}
