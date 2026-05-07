import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';
import '../services/database_service.dart';
import '../models/game_record.dart';

final progressProvider = StateNotifierProvider<ProgressNotifier, UserProgress>((ref) {
  return ProgressNotifier();
});

class ProgressNotifier extends StateNotifier<UserProgress> {
  ProgressNotifier() : super(UserProgress(
    currentAgeGroup: 'small',
    totalStars: 0,
    unlockedLevels: {},
  ));

  StorageService? _storageService;
  DatabaseService? _databaseService;

  Future<void> init(StorageService storage, DatabaseService database) async {
    _storageService = storage;
    _databaseService = database;
    await _loadProgress();
  }

  Future<void> _loadProgress() async {
    if (_storageService == null) return;

    final ageGroup = _storageService!.getCurrentAgeGroup() ?? 'small';
    final totalStars = _storageService!.getTotalStars() ?? 0;

    state = state.copyWith(
      currentAgeGroup: ageGroup,
      totalStars: totalStars,
    );
  }

  Future<void> setAgeGroup(String ageGroup) async {
    state = state.copyWith(currentAgeGroup: ageGroup);
    await _storageService?.setCurrentAgeGroup(ageGroup);
  }

  Future<void> addStars(int stars) async {
    state = state.copyWith(totalStars: state.totalStars + stars);
    await _storageService?.setTotalStars(state.totalStars);
  }

  Future<void> saveGameRecord(GameRecord record) async {
    await _databaseService?.insertGameRecord(record);
  }
}

class UserProgress {
  final String currentAgeGroup;
  final int totalStars;
  final Map<String, int> unlockedLevels;

  UserProgress({
    required this.currentAgeGroup,
    required this.totalStars,
    required this.unlockedLevels,
  });

  UserProgress copyWith({
    String? currentAgeGroup,
    int? totalStars,
    Map<String, int>? unlockedLevels,
  }) {
    return UserProgress(
      currentAgeGroup: currentAgeGroup ?? this.currentAgeGroup,
      totalStars: totalStars ?? this.totalStars,
      unlockedLevels: unlockedLevels ?? this.unlockedLevels,
    );
  }
}
