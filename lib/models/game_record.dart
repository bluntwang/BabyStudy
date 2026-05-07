class GameRecord {
  final int? id;
  final String gameType;
  final String ageGroup;
  final int score;
  final int stars;
  final DateTime playedAt;

  GameRecord({
    this.id,
    required this.gameType,
    required this.ageGroup,
    required this.score,
    required this.stars,
    required this.playedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gameType': gameType,
      'ageGroup': ageGroup,
      'score': score,
      'stars': stars,
      'playedAt': playedAt.toIso8601String(),
    };
  }

  factory GameRecord.fromMap(Map<String, dynamic> map) {
    return GameRecord(
      id: map['id'],
      gameType: map['gameType'],
      ageGroup: map['ageGroup'],
      score: map['score'],
      stars: map['stars'],
      playedAt: DateTime.parse(map['playedAt']),
    );
  }
}
