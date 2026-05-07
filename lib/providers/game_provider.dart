import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentGameProvider = StateProvider<GameState>((ref) {
  return GameState.initial();
});

class GameState {
  final String gameType;
  final String ageGroup;
  final int score;
  final int stars;
  final int currentRound;
  final int totalRounds;
  final bool isComplete;

  GameState({
    required this.gameType,
    required this.ageGroup,
    required this.score,
    required this.stars,
    required this.currentRound,
    required this.totalRounds,
    required this.isComplete,
  });

  factory GameState.initial() {
    return GameState(
      gameType: '',
      ageGroup: 'small',
      score: 0,
      stars: 0,
      currentRound: 0,
      totalRounds: 10,
      isComplete: false,
    );
  }

  GameState copyWith({
    String? gameType,
    String? ageGroup,
    int? score,
    int? stars,
    int? currentRound,
    int? totalRounds,
    bool? isComplete,
  }) {
    return GameState(
      gameType: gameType ?? this.gameType,
      ageGroup: ageGroup ?? this.ageGroup,
      score: score ?? this.score,
      stars: stars ?? this.stars,
      currentRound: currentRound ?? this.currentRound,
      totalRounds: totalRounds ?? this.totalRounds,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
