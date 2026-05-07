import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _currentAgeGroup = 'current_age_group';
  static const String _totalStars = 'total_stars';
  static const String _soundEnabled = 'sound_enabled';
  static const String _musicEnabled = 'music_enabled';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  String? getCurrentAgeGroup() => _prefs.getString(_currentAgeGroup);
  Future<bool> setCurrentAgeGroup(String ageGroup) =>
      _prefs.setString(_currentAgeGroup, ageGroup);

  int getTotalStars() => _prefs.getInt(_totalStars) ?? 0;
  Future<bool> setTotalStars(int stars) => _prefs.setInt(_totalStars, stars);
  Future<bool> addStars(int stars) =>
      setTotalStars(getTotalStars() + stars);

  bool isSoundEnabled() => _prefs.getBool(_soundEnabled) ?? true;
  Future<bool> setSoundEnabled(bool enabled) =>
      _prefs.setBool(_soundEnabled, enabled);

  bool isMusicEnabled() => _prefs.getBool(_musicEnabled) ?? true;
  Future<bool> setMusicEnabled(bool enabled) =>
      _prefs.setBool(_musicEnabled, enabled);
}
