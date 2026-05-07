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
