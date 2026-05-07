enum AgeGroup {
  small('小班', 3, 4, 'small'),
  medium('中班', 4, 5, 'medium'),
  large('大班', 5, 6, 'large');

  final String name;
  final int minAge;
  final int maxAge;
  final String key;

  const AgeGroup(this.name, this.minAge, this.maxAge, this.key);
}

class GameConfig {
  static const int starsForCorrect = 1;
  static const int starsForComplete = 2;
  static const int starsForPerfect = 3;
}
