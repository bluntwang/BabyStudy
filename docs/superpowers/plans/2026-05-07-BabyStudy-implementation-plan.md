# BabyStudy 儿童教育App实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 开发一款面向3-6岁儿童的Flutter跨平台教育App，通过趣味游戏提升专注力和逻辑思维

**Architecture:** Flutter + Riverpod状态管理 + SQLite本地存储 + audioplayers音频播放，采用模块化游戏架构，每个年龄段独立模块

**Tech Stack:** Flutter, Dart, Riverpod, SQLite, SharedPreferences, audioplayers, lottie

---

## 文件结构

```
lib/
├── main.dart                           # 应用入口
├── core/
│   ├── theme/
│   │   └── app_theme.dart              # 主题配置（颜色、按钮样式）
│   ├── router/
│   │   └── app_router.dart             # 路由配置
│   └── constants/
│       └── app_constants.dart         # 常量（年龄段、游戏配置）
├── models/
│   ├── game_record.dart               # 游戏记录模型
│   ├── user_progress.dart            # 用户进度模型
│   └── game_item.dart                # 游戏项目模型
├── providers/
│   ├── game_provider.dart             # 游戏状态管理
│   ├── progress_provider.dart        # 进度状态管理
│   └── audio_provider.dart           # 音频状态管理
├── services/
│   ├── storage_service.dart           # SharedPreferences存储
│   ├── database_service.dart         # SQLite数据库
│   └── audio_service.dart            # 音频播放服务
├── screens/
│   ├── splash_screen.dart             # 启动页
│   ├── home_screen.dart              # 首页（年龄段选择）
│   ├── game_list_screen.dart         # 游戏列表页
│   └── game_screen.dart              # 游戏主页面
└── games/
    ├── shape_recognition/            # 小班-形状识别
    │   └── shape_game.dart
    ├── color_recognition/            # 小班-颜色识别
    │   └── color_game.dart
    ├── size_recognition/             # 小班-大小识别
    │   └── size_game.dart
    ├── matching/                     # 小班-配对游戏
    │   └── matching_game.dart
    ├── connect_dots/                 # 小班-连连看
    │   └── connect_game.dart
    ├── counting/                    # 中班-数数游戏
    │   └── counting_game.dart
    ├── addition/                     # 中班-加法游戏
    │   └── addition_game.dart
    ├── vocabulary/                   # 中班-词汇学习
    │   └── vocabulary_game.dart
    ├── drawing/                     # 大班-自由绘画
    │   └── drawing_game.dart
    └── pinyin/                      # 大班-拼音学习
        └── pinyin_game.dart
```

---

## 实现阶段

### Phase 1: 基础框架搭建

#### Task 1: Flutter项目初始化

**Files:**
- Create: `pubspec.yaml` (已存在需修改)
- Create: `lib/main.dart`
- Create: `lib/core/theme/app_theme.dart`
- Create: `lib/core/constants/app_constants.dart`

- [ ] **Step 1: 创建Flutter项目**

```bash
cd e:/aicoding/BabyStudy
flutter create --org com.babystudy --project-name baby_study .
```

- [ ] **Step 2: 配置pubspec.yaml依赖**

```yaml
dependencies:
  flutter:
    sdk: flutter
  riverpod: ^2.4.9
  shared_preferences: ^2.2.2
  sqflite: ^2.3.0
  path: ^1.8.3
  audioplayers: ^5.2.1
  lottie: ^3.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
```

- [ ] **Step 3: 创建主题配置 app_theme.dart**

```dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF5B9BD5);
  static const Color secondaryColor = Color(0xFFFF9F43);
  static const Color accentColor = Color(0xFF2ECC71);
  static const Color backgroundColor = Color(0xFFFFF5F5);
  static const Color textColor = Color(0xFF333333);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(60, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(fontSize: 18),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        bodyLarge: TextStyle(fontSize: 18, color: textColor),
        bodyMedium: TextStyle(fontSize: 16, color: textColor),
      ),
    );
  }
}
```

- [ ] **Step 4: 创建常量配置 app_constants.dart**

```dart
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
```

- [ ] **Step 5: 创建main.dart**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: BabyStudyApp()));
}

class BabyStudyApp extends StatelessWidget {
  const BabyStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BabyStudy',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
```

- [ ] **Step 6: 运行flutter pub get**

```bash
cd e:/aicoding/BabyStudy
flutter pub get
```

- [ ] **Step 7: 提交**

```bash
git add pubspec.yaml lib/main.dart lib/core/
git commit -m "feat: initialize BabyStudy Flutter project with theme and constants

- Add Riverpod for state management
- Add theme configuration with kid-friendly colors
- Add age group and game constants

Co-Authored-By: wangzy33973"
```

---

#### Task 2: 路由配置

**Files:**
- Create: `lib/core/router/app_router.dart`
- Modify: `lib/main.dart`

- [ ] **Step 1: 创建路由配置 app_router.dart**

```dart
import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/game_list_screen.dart';
import '../screens/game_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String gameList = '/game-list';
  static const String game = '/game';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case gameList:
        final ageGroup = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => GameListScreen(ageGroup: ageGroup),
        );
      case game:
        final gameParams = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => GameScreen(
            gameType: gameParams['gameType'],
            ageGroup: gameParams['ageGroup'],
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
```

- [ ] **Step 2: 更新main.dart使用路由**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: BabyStudyApp()));
}

class BabyStudyApp extends StatelessWidget {
  const BabyStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BabyStudy',
      theme: AppTheme.lightTheme,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRouter.splash,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

- [ ] **Step 3: 提交**

```bash
git add lib/core/router/app_router.dart lib/main.dart
git commit -m "feat: add routing configuration

Co-Authored-By: wangzy33973"
```

---

#### Task 3: 数据模型

**Files:**
- Create: `lib/models/game_record.dart`
- Create: `lib/models/user_progress.dart`
- Create: `lib/models/game_item.dart`

- [ ] **Step 1: 创建游戏记录模型 game_record.dart**

```dart
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
```

- [ ] **Step 2: 创建用户进度模型 user_progress.dart**

```dart
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
```

- [ ] **Step 3: 创建游戏项目模型 game_item.dart**

```dart
import 'package:flutter/material.dart';

class GameItem {
  final String id;
  final String name;
  final String description;
  final String gameType;
  final String ageGroup;
  final int requiredStars;
  final IconData icon;
  final bool isUnlocked;

  GameItem({
    required this.id,
    required this.name,
    required this.description,
    required this.gameType,
    required this.ageGroup,
    required this.requiredStars,
    required this.icon,
    this.isUnlocked = false,
  });
}
```

- [ ] **Step 4: 提交**

```bash
git add lib/models/
git commit -m "feat: add data models

- GameRecord for tracking game play history
- UserProgress for user advancement state
- GameItem for game catalog

Co-Authored-By: wangzy33973"
```

---

#### Task 4: 存储服务

**Files:**
- Create: `lib/services/storage_service.dart`
- Create: `lib/services/database_service.dart`

- [ ] **Step 1: 创建SharedPreferences存储服务 storage_service.dart**

```dart
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
```

- [ ] **Step 2: 创建SQLite数据库服务 database_service.dart**

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/game_record.dart';

class DatabaseService {
  static Database? _database;
  static const String _tableName = 'game_records';

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'babystudy.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            gameType TEXT NOT NULL,
            ageGroup TEXT NOT NULL,
            score INTEGER NOT NULL,
            stars INTEGER NOT NULL,
            playedAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertGameRecord(GameRecord record) async {
    final db = await database;
    return await db.insert(_tableName, record.toMap());
  }

  Future<List<GameRecord>> getGameRecordsByAgeGroup(String ageGroup) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'ageGroup = ?',
      whereArgs: [ageGroup],
      orderBy: 'playedAt DESC',
    );
    return maps.map((map) => GameRecord.fromMap(map)).toList();
  }

  Future<List<GameRecord>> getAllGameRecords() async {
    final db = await database;
    final maps = await db.query(_tableName, orderBy: 'playedAt DESC');
    return maps.map((map) => GameRecord.fromMap(map)).toList();
  }
}
```

- [ ] **Step 3: 提交**

```bash
git add lib/services/
git commit -m "feat: add storage and database services

- StorageService for SharedPreferences (settings, stars)
- DatabaseService for SQLite (game records)

Co-Authored-By: wangzy33973"
```

---

#### Task 5: 音频服务

**Files:**
- Create: `lib/services/audio_service.dart`

- [ ] **Step 1: 创建音频服务 audio_service.dart**

```dart
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
```

- [ ] **Step 2: 提交**

```bash
git add lib/services/audio_service.dart
git commit -m "feat: add audio service for BGM and sound effects

Co-Authored-By: wangzy33973"
```

---

### Phase 2: 启动页和首页

#### Task 6: 启动页

**Files:**
- Create: `lib/screens/splash_screen.dart`

- [ ] **Step 1: 创建启动页 splash_screen.dart**

```dart
import 'package:flutter/material.dart';
import '../core/router/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.home);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: const DecorationImage(
                          image: AssetImage('assets/logo/baby.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'BabyStudy',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '趣味学习 快乐成长',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add lib/screens/splash_screen.dart
git commit -m "feat: add splash screen with animation

- Animated logo and title
- Auto navigation to home after 3 seconds

Co-Authored-By: wangzy33973"
```

---

#### Task 7: 首页

**Files:**
- Create: `lib/screens/home_screen.dart`

- [ ] **Step 1: 创建首页 home_screen.dart**

```dart
import 'package:flutter/material.dart';
import '../core/router/app_router.dart';
import '../core/constants/app_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // 吉祥物
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: const DecorationImage(
                  image: AssetImage('assets/logo/baby.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'BabyStudy',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              '选择你的年龄段开始学习',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 40),
            // 年龄段选择
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _AgeGroupCard(
                      ageGroup: AgeGroup.small,
                      color: const Color(0xFF5B9BD5),
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRouter.gameList,
                        arguments: AgeGroup.small.key,
                      ),
                    ),
                    _AgeGroupCard(
                      ageGroup: AgeGroup.medium,
                      color: const Color(0xFFFF9F43),
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRouter.gameList,
                        arguments: AgeGroup.medium.key,
                      ),
                    ),
                    _AgeGroupCard(
                      ageGroup: AgeGroup.large,
                      color: const Color(0xFF2ECC71),
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRouter.gameList,
                        arguments: AgeGroup.large.key,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AgeGroupCard extends StatefulWidget {
  final AgeGroup ageGroup;
  final Color color;
  final VoidCallback onTap;

  const _AgeGroupCard({
    required this.ageGroup,
    required this.color,
    required this.onTap,
  });

  @override
  State<_AgeGroupCard> createState() => _AgeGroupCardState();
}

class _AgeGroupCardState extends State<_AgeGroupCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 35,
                ),
              ),
              const SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxis alignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.ageGroup.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${widget.ageGroup.minAge}-${widget.ageGroup.maxAge}岁',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add lib/screens/home_screen.dart
git commit -m "feat: add home screen with age group selection

- Display mascot logo
- Three cards for small/medium/large class
- Tap animation feedback

Co-Authored-By: wangzy33973"
```

---

#### Task 8: 游戏列表页

**Files:**
- Create: `lib/screens/game_list_screen.dart`

- [ ] **Step 1: 创建游戏列表页 game_list_screen.dart**

```dart
import 'package:flutter/material.dart';
import '../core/router/app_router.dart';
import '../core/constants/app_constants.dart';
import '../games/shape_recognition/shape_game.dart';
import '../games/color_recognition/color_game.dart';
import '../games/size_recognition/size_game.dart';
import '../games/matching/matching_game.dart';
import '../games/connect_dots/connect_game.dart';

class GameListScreen extends StatelessWidget {
  final String ageGroup;

  const GameListScreen({super.key, required this.ageGroup});

  @override
  Widget build(BuildContext context) {
    final games = _getGamesForAgeGroup(ageGroup);

    return Scaffold(
      appBar: AppBar(
        title: Text(_getAgeGroupName(ageGroup)),
        backgroundColor: _getAgeGroupColor(ageGroup),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.0,
            ),
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return _GameCard(
                game: game,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.game,
                    arguments: {
                      'gameType': game['type'],
                      'ageGroup': ageGroup,
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  String _getAgeGroupName(String key) {
    switch (key) {
      case 'small':
        return '小班';
      case 'medium':
        return '中班';
      case 'large':
        return '大班';
      default:
        return '';
    }
  }

  Color _getAgeGroupColor(String key) {
    switch (key) {
      case 'small':
        return const Color(0xFF5B9BD5);
      case 'medium':
        return const Color(0xFFFF9F43);
      case 'large':
        return const Color(0xFF2ECC71);
      default:
        return Colors.blue;
    }
  }

  List<Map<String, dynamic>> _getGamesForAgeGroup(String key) {
    switch (key) {
      case 'small':
        return [
          {'name': '形状识别', 'icon': Icons.category, 'type': 'shape'},
          {'name': '颜色识别', 'icon': Icons.palette, 'type': 'color'},
          {'name': '大小识别', 'icon': Icons.straighten, 'type': 'size'},
          {'name': '配对游戏', 'icon': Icons.grid_view, 'type': 'matching'},
          {'name': '连连看', 'icon': Icons.link, 'type': 'connect'},
        ];
      case 'medium':
        return [
          {'name': '数数游戏', 'icon': Icons.numbers, 'type': 'counting'},
          {'name': '加法挑战', 'icon': Icons.add_circle, 'type': 'addition'},
          {'name': '词汇学习', 'icon': Icons.book, 'type': 'vocabulary'},
          {'name': '看图说话', 'icon': Icons.image, 'type': 'speaking'},
        ];
      case 'large':
        return [
          {'name': '拼音认知', 'icon': Icons.abc, 'type': 'pinyin'},
          {'name': '拼音闯关', 'icon': Icons.flag, 'type': 'pinyin_game'},
          {'name': '自由绘画', 'icon': Icons.brush, 'type': 'drawing'},
          {'name': '故事创编', 'icon': Icons.auto_stories, 'type': 'story'},
        ];
      default:
        return [];
    }
  }
}

class _GameCard extends StatefulWidget {
  final Map<String, dynamic> game;
  final VoidCallback onTap;

  const _GameCard({required this.game, required this.onTap});

  @override
  State<_GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<_GameCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  widget.game['icon'],
                  size: 35,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                widget.game['name'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add lib/screens/game_list_screen.dart
git commit -m "feat: add game list screen

- Grid display of games for selected age group
- Animated tap cards

Co-Authored-By: wangzy33973"
```

---

#### Task 9: 游戏页面框架

**Files:**
- Create: `lib/screens/game_screen.dart`

- [ ] **Step 1: 创建游戏页面 game_screen.dart**

```dart
import 'package:flutter/material.dart';
import '../services/audio_service.dart';

class GameScreen extends StatefulWidget {
  final String gameType;
  final String ageGroup;

  const GameScreen({
    super.key,
    required this.gameType,
    required this.ageGroup,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _score = 0;
  int _stars = 0;
  final AudioService _audioService = AudioService();

  void _onCorrect() {
    setState(() {
      _score += 10;
      _stars += 1;
    });
    _audioService.playCorrect();
  }

  void _onWrong() {
    _audioService.playWrong();
  }

  void _onComplete() {
    _audioService.playWin();
    _showResultDialog();
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('太棒了！'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('你完成了！'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _stars.clamp(0, 3),
                (index) => const Icon(Icons.star, color: Colors.amber, size: 40),
              ),
            ),
            const SizedBox(height: 10),
            Text('得分: $_score'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('返回'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _score = 0;
                _stars = 0;
              });
            },
            child: const Text('再来一次'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getGameTitle(widget.gameType)),
        backgroundColor: _getAgeGroupColor(widget.ageGroup),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: Text(
            '游戏: ${widget.gameType}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }

  String _getGameTitle(String type) {
    final titles = {
      'shape': '形状识别',
      'color': '颜色识别',
      'size': '大小识别',
      'matching': '配对游戏',
      'connect': '连连看',
      'counting': '数数游戏',
      'addition': '加法挑战',
      'vocabulary': '词汇学习',
      'speaking': '看图说话',
      'pinyin': '拼音认知',
      'pinyin_game': '拼音闯关',
      'drawing': '自由绘画',
      'story': '故事创编',
    };
    return titles[type] ?? '游戏';
  }

  Color _getAgeGroupColor(String key) {
    switch (key) {
      case 'small':
        return const Color(0xFF5B9BD5);
      case 'medium':
        return const Color(0xFFFF9F43);
      case 'large':
        return const Color(0xFF2ECC71);
      default:
        return Colors.blue;
    }
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add lib/screens/game_screen.dart
git commit -m "feat: add game screen base framework

- Score and stars tracking
- Result dialog with replay option

Co-Authored-By: wangzy33973"
```

---

### Phase 3: 小班游戏

#### Task 10: 形状识别游戏

**Files:**
- Create: `lib/games/shape_recognition/shape_game.dart`

- [ ] **Step 1: 创建形状识别游戏 shape_game.dart**

```dart
import 'dart:math';
import 'package:flutter/material.dart';

class ShapeGame extends StatefulWidget {
  const ShapeGame({super.key});

  @override
  State<ShapeGame> createState() => _ShapeGameState();
}

class _ShapeGameState extends State<ShapeGame> {
  final List<String> _shapes = ['circle', 'square', 'triangle', 'star', 'heart'];
  final Map<String, IconData> _shapeIcons = {
    'circle': Icons.circle,
    'square': Icons.square,
    'triangle': Icons.change_history,
    'star': Icons.star,
    'heart': Icons.favorite,
  };

  late String _targetShape;
  late List<String> _options;
  int _score = 0;
  int _round = 0;
  static const int _totalRounds = 10;

  @override
  void initState() {
    super.initState();
    _generateNewRound();
  }

  void _generateNewRound() {
    final random = Random();
    _targetShape = _shapes[random.nextInt(_shapes.length)];

    _options = [_targetShape];
    while (_options.length < 4) {
      final option = _shapes[random.nextInt(_shapes.length)];
      if (!_options.contains(option)) {
        _options.add(option);
      }
    }
    _options.shuffle();
  }

  void _checkAnswer(String selected) {
    setState(() {
      if (selected == _targetShape) {
        _score += 10;
        _round++;
        if (_round < _totalRounds) {
          _generateNewRound();
        } else {
          _showCompleteDialog();
        }
      } else {
        _showWrongFeedback();
      }
    });
  }

  void _showWrongFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('没关系，再想想！'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showCompleteDialog() {
    final stars = (_score / 10).round().clamp(0, 3);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('太棒了！'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                stars,
                (index) => const Icon(Icons.star, color: Colors.amber, size: 40),
              ),
            ),
            const SizedBox(height: 10),
            Text('得分: $_score'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('返回'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('第 $_round/$_totalRounds 题', style: const TextStyle(fontSize: 18)),
              Text('得分: $_score', style: const TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 20),
          const Text('选择相同的形状', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
            ),
            child: Icon(
              _shapeIcons[_targetShape],
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: _options.map((shape) {
              return GestureDetector(
                onTap: () => _checkAnswer(shape),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                  ),
                  child: Icon(
                    _shapeIcons[shape],
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: 更新game_list_screen.dart导入**

```dart
import '../games/shape_recognition/shape_game.dart';
```

- [ ] **Step 3: 提交**

```bash
git add lib/games/shape_recognition/shape_game.dart
git commit -m "feat: add shape recognition game for small class

- 10 rounds of shape matching
- Score and star rewards
- Visual feedback for wrong answers

Co-Authored-By: wangzy33973"
```

---

#### Task 11: 颜色识别游戏

**Files:**
- Create: `lib/games/color_recognition/color_game.dart`

- [ ] **Step 1: 创建颜色识别游戏 color_game.dart**

```dart
import 'dart:math';
import 'package:flutter/material.dart';

class ColorGame extends StatefulWidget {
  const ColorGame({super.key});

  @override
  State<ColorGame> createState() => _ColorGameState();
}

class _ColorGameState extends State<ColorGame> {
  final List<Map<String, dynamic>> _colors = [
    {'name': '红色', 'color': Colors.red},
    {'name': '黄色', 'color': Colors.yellow},
    {'name': '蓝色', 'color': Colors.blue},
    {'name': '绿色', 'color': Colors.green},
    {'name': '橙色', 'color': Colors.orange},
    {'name': '紫色', 'color': Colors.purple},
  ];

  late Map<String, dynamic> _targetColor;
  late List<Map<String, dynamic>> _options;
  int _score = 0;
  int _round = 0;
  static const int _totalRounds = 10;

  @override
  void initState() {
    super.initState();
    _generateNewRound();
  }

  void _generateNewRound() {
    final random = Random();
    _targetColor = _colors[random.nextInt(_colors.length)];

    _options = [_targetColor];
    while (_options.length < 4) {
      final option = _colors[random.nextInt(_colors.length)];
      if (!_options.contains(option)) {
        _options.add(option);
      }
    }
    _options.shuffle();
  }

  void _checkAnswer(Map<String, dynamic> selected) {
    setState(() {
      if (selected['name'] == _targetColor['name']) {
        _score += 10;
        _round++;
        if (_round < _totalRounds) {
          _generateNewRound();
        } else {
          _showCompleteDialog();
        }
      } else {
        _showWrongFeedback();
      }
    });
  }

  void _showWrongFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('没关系，再想想！'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showCompleteDialog() {
    final stars = (_score / 10).round().clamp(0, 3);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('太棒了！'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                stars,
                (index) => const Icon(Icons.star, color: Colors.amber, size: 40),
              ),
            ),
            const SizedBox(height: 10),
            Text('得分: $_score'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('返回'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('第 $_round/$_totalRounds 题', style: const TextStyle(fontSize: 18)),
              Text('得分: $_score', style: const TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 20),
          const Text('选择相同的颜色', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: _targetColor['color'],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)],
            ),
            child: Center(
              child: Text(
                _targetColor['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: _options.map((color) {
              return GestureDetector(
                onTap: () => _checkAnswer(color),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: color['color'],
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add lib/games/color_recognition/color_game.dart
git commit -m "feat: add color recognition game for small class

- 6 colors with Chinese names
- Visual color display
- Score tracking

Co-Authored-By: wangzy33973"
```

---

#### Task 12: 大小识别游戏

**Files:**
- Create: `lib/games/size_recognition/size_game.dart`

- [ ] **Step 1: 创建大小识别游戏 size_game.dart**

```dart
import 'dart:math';
import 'package:flutter/material.dart';

class SizeGame extends StatefulWidget {
  const SizeGame({super.key});

  @override
  State<SizeGame> createState() => _SizeGameState();
}

class _SizeGameState extends State<SizeGame> {
  final List<double> _sizes = [40.0, 60.0, 80.0, 100.0, 120.0];
  final List<String> _labels = ['很小', '小', '中等', '大', '很大'];

  late List<double> _shuffledSizes;
  int _currentLevel = 0;
  int _score = 0;
  static const int _totalLevels = 8;

  @override
  void initState() {
    super.initState();
    _generateLevel();
  }

  void _generateLevel() {
    final random = Random();
    final levelSize = (_currentLevel ~/ 2 + 2).clamp(2, 5);
    final allSizes = List<double>.from(_sizes)..shuffle(random);
    _shuffledSizes = allSizes.take(levelSize).toList();
  }

  void _checkAnswer(int index) {
    final isCorrect = index == _shuffledSizes.length - 1;
    setState(() {
      if (isCorrect) {
        _score += 10;
        _currentLevel++;
        if (_currentLevel < _totalLevels) {
          _generateLevel();
        } else {
          _showCompleteDialog();
        }
      } else {
        _showWrongFeedback();
      }
    });
  }

  void _showWrongFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('从大到小点击！'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showCompleteDialog() {
    final stars = (_score / 10).round().clamp(0, 3);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('太棒了！'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                stars,
                (index) => const Icon(Icons.star, color: Colors.amber, size: 40),
              ),
            ),
            const SizedBox(height: 10),
            Text('得分: $_score'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('返回'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('第 $_currentLevel/$_totalLevels 题', style: const TextStyle(fontSize: 18)),
              Text('得分: $_score', style: const TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 20),
          const Text('按从大到小点击图标', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text('（${_labels[_shuffledSizes.length.clamp(0, 4)]}）', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: _shuffledSizes.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _checkAnswer(entry.key),
                child: Container(
                  width: entry.value,
                  height: entry.value,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                  ),
                  child: const Icon(
                    Icons.star,
                    color: Colors.white,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add lib/games/size_recognition/size_game.dart
git commit -m "feat: add size recognition game for small class

- Sort sizes from large to small
- Progressive difficulty

Co-Authored-By: wangzy33973"
```

---

#### Task 13: 配对游戏

**Files:**
- Create: `lib/games/matching/matching_game.dart`

- [ ] **Step 1: 创建配对游戏 matching_game.dart**

```dart
import 'dart:math';
import 'package:flutter/material.dart';

class MatchingGame extends StatefulWidget {
  const MatchingGame({super.key});

  @override
  State<MatchingGame> createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  final List<IconData> _icons = [
    Icons.pets,
    Icons.cake,
    Icons.flight,
    Icons.music_note,
    Icons.star,
    Icons.favorite,
  ];

  late List<int> _cards;
  late List<bool> _flipped;
  late List<bool> _matched;
  int _firstIndex = -1;
  int _secondIndex = -1;
  int _matches = 0;
  int _attempts = 0;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    final pairs = List<int>.from([0, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5]);
    pairs.shuffle();
    _cards = pairs;
    _flipped = List<bool>.filled(12, false);
    _matched = List<bool>.filled(12, false);
    _firstIndex = -1;
    _secondIndex = -1;
    _matches = 0;
    _attempts = 0;
  }

  void _onCardTap(int index) {
    if (_flipped[index] || _matched[index]) return;

    setState(() {
      _flipped[index] = true;
      if (_firstIndex == -1) {
        _firstIndex = index;
      } else {
        _secondIndex = index;
        _checkMatch();
      }
    });
  }

  void _checkMatch() {
    _attempts++;
    if (_cards[_firstIndex] == _cards[_secondIndex]) {
      setState(() {
        _matched[_firstIndex] = true;
        _matched[_secondIndex] = true;
        _matches++;
        _firstIndex = -1;
        _secondIndex = -1;
        if (_matches == 6) {
          _showCompleteDialog();
        }
      });
    } else {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _flipped[_firstIndex] = false;
            _flipped[_secondIndex] = false;
            _firstIndex = -1;
            _secondIndex = -1;
          });
        }
      });
    }
  }

  void _showCompleteDialog() {
    final stars = _attempts <= 8 ? 3 : (_attempts <= 12 ? 2 : 1);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('太棒了！'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                stars,
                (index) => const Icon(Icons.star, color: Colors.amber, size: 40),
              ),
            ),
            const SizedBox(height: 10),
            Text('尝试次数: $_attempts'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('返回'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('配对: $_matches/6', style: const TextStyle(fontSize: 18)),
              Text('尝试: $_attempts', style: const TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 20),
          const Text('找出相同的配对', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final isFlipped = _flipped[index] || _matched[index];
                final isMatched = _matched[index];

                return GestureDetector(
                  onTap: () => _onCardTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: isMatched
                          ? Colors.green.withOpacity(0.3)
                          : isFlipped
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                    ),
                    child: Center(
                      child: isFlipped
                          ? Icon(
                              _icons[_cards[index]],
                              size: 40,
                              color: Theme.of(context).primaryColor,
                            )
                          : const Icon(Icons.question_mark, color: Colors.white, size: 40),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add lib/games/matching/matching_game.dart
git commit -m "feat: add matching card game for small class

- Flip cards to find matching pairs
- 6 pairs of icons
- Track attempts for star rating

Co-Authored-By: wangzy33973"
```

---

#### Task 14: 连连看游戏

**Files:**
- Create: `lib/games/connect_dots/connect_game.dart`

- [ ] **Step 1: 创建连连看游戏 connect_game.dart**

```dart
import 'dart:math';
import 'package:flutter/material.dart';

class ConnectGame extends StatefulWidget {
  const ConnectGame({super.key});

  @override
  State<ConnectGame> createState() => _ConnectGameState();
}

class _ConnectGameState extends State<ConnectGame> {
  final List<IconData> _icons = [
    Icons.star, Icons.favorite, Icons.circle, Icons.square,
    Icons.pets, Icons.cake, Icons.music_note, Icons.flight,
  ];

  late List<int> _items;
  int _firstIndex = -1;
  int _matches = 0;
  int _score = 0;
  static const int _totalMatches = 4;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    final pairs = [0, 1, 2, 3, 0, 1, 2, 3];
    pairs.shuffle();
    _items = pairs;
    _firstIndex = -1;
    _matches = 0;
    _score = 0;
  }

  void _onItemTap(int index) {
    if (_firstIndex == -1) {
      setState(() => _firstIndex = index);
    } else {
      if (_items[_firstIndex] == _items[index] && _firstIndex != index) {
        setState(() {
          _matches++;
          _score += 20;
          _firstIndex = -1;
          if (_matches == _totalMatches) {
            _showCompleteDialog();
          }
        });
      } else {
        setState(() => _firstIndex = -1);
      }
    }
  }

  void _showCompleteDialog() {
    final stars = (_score / 20).round().clamp(0, 3);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('太棒了！'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                stars,
                (index) => const Icon(Icons.star, color: Colors.amber, size: 40),
              ),
            ),
            const SizedBox(height: 10),
            Text('得分: $_score'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('返回'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('配对: $_matches/$_totalMatches', style: const TextStyle(fontSize: 18)),
              Text('得分: $_score', style: const TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 20),
          const Text('点击两个相同的图标', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              final isSelected = _firstIndex == index;

              return GestureDetector(
                onTap: () => _onItemTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                  ),
                  child: Center(
                    child: Icon(
                      _icons[_items[index]],
                      size: 40,
                      color: isSelected ? Colors.white : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add lib/games/connect_dots/connect_game.dart
git commit -m "feat: add connect matching game for small class

- Tap two matching icons to clear
- Score based on matches

Co-Authored-By: wangzy33973"
```

---

### Phase 4: 中班游戏

#### Task 15: 数数游戏

**Files:**
- Create: `lib/games/counting/counting_game.dart`

- [ ] **Step 1: 创建数数游戏 counting_game.dart**

```dart
import 'dart:math';
import 'package:flutter/material.dart';

class CountingGame extends StatefulWidget {
  const CountingGame({super.key});

  @override
  State<CountingGame> createState() => _CountingGameState();
}

class _CountingGameState extends State<CountingGame> {
  final List<IconData> _itemIcons = [
    Icons.apple,
    Icons.local_cafe,
    Icons.egg,
    Icons.cookie,
    Icons.cake,
  ];

  int _targetCount = 0;
  late List<int> _options;
  int _score = 0;
  int _round = 0;
  static const int _totalRounds = 10;

  @override
  void initState() {
    super.initState();
    _generateNewRound();
  }

  void _generateNewRound() {
    final random = Random();
    _targetCount = random.nextInt(9) + 1;

    _options = [_targetCount];
    while (_options.length < 4) {
      final option = random.nextInt(9) + 1;
      if (!_options.contains(option)) {
        _options.add(option);
      }
    }
    _options.shuffle();
  }

  void _checkAnswer(int selected) {
    setState(() {
      if (selected == _targetCount) {
        _score += 10;
        _round++;
        if (_round < _totalRounds) {
          _generateNewRound();
        } else {
          _showCompleteDialog();
        }
      } else {
        _showWrongFeedback();
      }
    });
  }

  void _showWrongFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('再数一数！'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showCompleteDialog() {
    final stars = (_score / 10).round().clamp(0, 3);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('太棒了！'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                stars,
                (index) => const Icon(Icons.star, color: Colors.amber, size: 40),
              ),
            ),
            const SizedBox(height: 10),
            Text('得分: $_score'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('返回'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('第 $_round/$_totalRounds 题', style: const TextStyle(fontSize: 18)),
              Text('得分: $_score', style: const TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 20),
          const Text('数一数有多少个', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
            ),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                _targetCount,
                (index) => Icon(
                  _itemIcons[index % _itemIcons.length],
                  size: 40,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text('正确答案是一个数字', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _options.map((option) {
              return GestureDetector(
                onTap: () => _checkAnswer(option),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                  ),
                  child: Center(
                    child: Text(
                      '$option',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add lib/games/counting/counting_game.dart
git commit -m "feat: add counting game for medium class

- Count items and select correct number
- 10 rounds with score tracking

Co-Authored-By: wangzy33973"
```

---

#### Task 16: 加法游戏

**Files:**
- Create: `lib/games/addition/addition_game.dart`

- [ ] **Step 1: 创建加法游戏 addition_game.dart**

```dart
import 'dart:math';
import 'package:flutter/material.dart';

class AdditionGame extends StatefulWidget {
  const AdditionGame({super.key});

  @override
  State<AdditionGame> createState() => _AdditionGameState();
}

class _AdditionGameState extends State<AdditionGame> {
  int _num1 = 0;
  int _num2 = 0;
  late List<int> _options;
  int _score = 0;
  int _round = 0;
  static const int _totalRounds = 10;

  @override
  void initState() {
    super.initState();
    _generateNewRound();
  }

  void _generateNewRound() {
    final random = Random();
    _num1 = random.nextInt(5) + 1;
    _num2 = random.nextInt(5) + 1;

    final correctAnswer = _num1 + _num2;
    _options = [correctAnswer];
    while (_options.length < 4) {
      final option = random.nextInt(10) + 1;
      if (!_options.contains(option)) {
        _options.add(option);
      }
    }
    _options.shuffle();
  }

  void _checkAnswer(int selected) {
    final correct = _num1 + _num2;
    setState(() {
      if (selected == correct) {
        _score += 10;
        _round++;
        if (_round < _totalRounds) {
          _generateNewRound();
        } else {
          _showCompleteDialog();
        }
      } else {
        _showWrongFeedback();
      }
    });
  }

  void _showWrongFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('再算一算！'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showCompleteDialog() {
    final stars = (_score / 10).round().clamp(0, 3);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('太棒了！'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                stars,
                (index) => const Icon(Icons.star, color: Colors.amber, size: 40),
              ),
            ),
            const SizedBox(height: 10),
            Text('得分: $_score'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('返回'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('第 $_round/$_totalRounds 题', style: const TextStyle(fontSize: 18)),
              Text('得分: $_score', style: const TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 30),
          const Text('计算结果', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      '$_num1',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(Icons.add, size: 40),
                const SizedBox(width: 20),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      '$_num2',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                const Text('=', style: TextStyle(fontSize: 40)),
                const SizedBox(width: 20),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text('?', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _options.map((option) {
              return GestureDetector(
                onTap: () => _checkAnswer(option),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                  ),
                  child: Center(
                    child: Text(
                      '$option',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add lib/games/addition/addition_game.dart
git commit -m "feat: add addition game for medium class

- Simple addition problems (1-5 + 1-5)
- 10 rounds with score tracking

Co-Authored-By: wangzy33973"
```

---

#### Task 17: 词汇学习游戏

**Files:**
- Create: `lib/games/vocabulary/vocabulary_game.dart`

- [ ] **Step 1: 创建词汇学习游戏 vocabulary_game.dart**

```dart
import 'dart:math';
import 'package:flutter/material.dart';

class VocabularyGame extends StatefulWidget {
  const VocabularyGame({super.key});

  @override
  State<VocabularyGame> createState() => _VocabularyGameState();
}

class _VocabularyGameState extends State<VocabularyGame> {
  final List<Map<String, dynamic>> _words = [
    {'word': '苹果', 'icon': Icons.apple, 'color': Colors.red},
    {'word': '香蕉', 'icon': Icons.breakfast_dining, 'color': Colors.yellow},
    {'word': '猫咪', 'icon': Icons.pets, 'color': Colors.orange},
    {'word': '狗狗', 'icon': Icons.pets, 'color': Colors.brown},
    {'word': '汽车', 'icon': Icons.directions_car, 'color': Colors.blue},
    {'word': '花朵', 'icon': Icons.local_florist, 'color': Colors.pink},
    {'word': '书本', 'icon': Icons.menu_book, 'color': Colors.purple},
    {'word': '星星', 'icon': Icons.star, 'color': Colors.amber},
  ];

  late Map<String, dynamic> _currentWord;
  late List<Map<String, dynamic>> _options;
  int _score = 0;
  int _round = 0;
  static const int _totalRounds = 10;

  @override
  void initState() {
    super.initState();
    _generateNewRound();
  }

  void _generateNewRound() {
    final random = Random();
    _currentWord = _words[random.nextInt(_words.length)];

    _options = [_currentWord];
    while (_options.length < 4) {
      final option = _words[random.nextInt(_words.length)];
      if (!_options.contains(option)) {
        _options.add(option);
      }
    }
    _options.shuffle();
  }

  void _checkAnswer(Map<String, dynamic> selected) {
    setState(() {
      if (selected['word'] == _currentWord['word']) {
        _score += 10;
        _round++;
        if (_round < _totalRounds) {
          _generateNewRound();
        } else {
          _showCompleteDialog();
        }
      } else {
        _showWrongFeedback();
      }
    });
  }

  void _showWrongFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('再想一想！'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showCompleteDialog() {
    final stars = (_score / 10).round().clamp(0, 3);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('太棒了！'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                stars,
                (index) => const Icon(Icons.star, color: Colors.amber, size: 40),
              ),
            ),
            const SizedBox(height: 10),
            Text('得分: $_score'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('返回'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('第 $_round/$_totalRounds 题', style: const TextStyle(fontSize: 18)),
              Text('得分: $_score', style: const TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 20),
          const Text('选择正确的词语', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: _currentWord['color'].withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
            ),
            child: Icon(
              _currentWord['icon'],
              size: 80,
              color: _currentWord['color'],
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: _options.map((option) {
              return GestureDetector(
                onTap: () => _checkAnswer(option),
                child: Container(
                  width: 120,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                  ),
                  child: Center(
                    child: Text(
                      option['word'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add lib/games/vocabulary/vocabulary_game.dart
git commit -m "feat: add vocabulary game for medium class

- Match icons with Chinese words
- 8 different word categories
- 10 rounds

Co-Authored-By: wangzy33973"
```

---

### Phase 5: 大班游戏

#### Task 18: 拼音认知游戏

**Files:**
- Create: `lib/games/pinyin/pinyin_game.dart`

- [ ] **Step 1: 创建拼音认知游戏 pinyin_game.dart**

```dart
import 'dart:math';
import 'package:flutter/material.dart';

class PinyinGame extends StatefulWidget {
  const PinyinGame({super.key});

  @override
  State<PinyinGame> createState() => _PinyinGameState();
}

class _PinyinGameState extends State<PinyinGame> {
  final List<Map<String, dynamic>> _pinyinItems = [
    {'pinyin': 'a', 'word': '啊'},
    {'pinyin': 'o', 'word': '哦'},
    {'pinyin': 'e', 'word': '鹅'},
    {'pinyin': 'i', 'word': '衣'},
    {'pinyin': 'u', 'word': '屋'},
    {'pinyin': 'b', 'word': '玻'},
    {'pinyin': 'm', 'word': '摸'},
    {'pinyin': 'f', 'word': '佛'},
    {'pinyin': 'd', 'word': '得'},
    {'pinyin': 't', 'word': '特'},
    {'pinyin': 'n', 'word': '讷'},
    {'pinyin': 'l', 'word': '勒'},
  ];

  late Map<String, dynamic> _currentItem;
  late List<Map<String, dynamic>> _options;
  int _score = 0;
  int _round = 0;
  static const int _totalRounds = 10;

  @override
  void initState() {
    super.initState();
    _generateNewRound();
  }

  void _generateNewRound() {
    final random = Random();
    _currentItem = _pinyinItems[random.nextInt(_pinyinItems.length)];

    _options = [_currentItem];
    while (_options.length < 4) {
      final option = _pinyinItems[random.nextInt(_pinyinItems.length)];
      if (!_options.contains(option)) {
        _options.add(option);
      }
    }
    _options.shuffle();
  }

  void _checkAnswer(Map<String, dynamic> selected) {
    setState(() {
      if (selected['word'] == _currentItem['word']) {
        _score += 10;
        _round++;
        if (_round < _totalRounds) {
          _generateNewRound();
        } else {
          _showCompleteDialog();
        }
      } else {
        _showWrongFeedback();
      }
    });
  }

  void _showWrongFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('再想一想！'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showCompleteDialog() {
    final stars = (_score / 10).round().clamp(0, 3);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('太棒了！'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                stars,
                (index) => const Icon(Icons.star, color: Colors.amber, size: 40),
              ),
            ),
            const SizedBox(height: 10),
            Text('得分: $_score'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('返回'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('第 $_round/$_totalRounds 题', style: const TextStyle(fontSize: 18)),
              Text('得分: $_score', style: const TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 20),
          const Text('选择正确的汉字', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
            ),
            child: Column(
              children: [
                Text(
                  _currentItem['pinyin'],
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                const Text('读作', style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: _options.map((option) {
              return GestureDetector(
                onTap: () => _checkAnswer(option),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                  ),
                  child: Center(
                    child: Text(
                      option['word'],
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add lib/games/pinyin/pinyin_game.dart
git commit -m "feat: add pinyin learning game for large class

- Match pinyin with correct Chinese character
- 12 pinyin with examples
- 10 rounds

Co-Authored-By: wangzy33973"
```

---

#### Task 19: 拼音闯关游戏

**Files:**
- Create: `lib/games/pinyin/pinyin_challenge_game.dart`

- [ ] **Step 1: 创建拼音闯关游戏 pinyin_challenge_game.dart**

```dart
import 'dart:math';
import 'package:flutter/material.dart';

class PinyinChallengeGame extends StatefulWidget {
  const PinyinChallengeGame({super.key});

  @override
  State<PinyinChallengeGame> createState() => _PinyinChallengeGameState();
}

class _PinyinChallengeGameState extends State<PinyinChallengeGame> {
  final List<Map<String, dynamic>> _challenges = [
    {'word': '妈妈', 'pinyin': 'mā ma', 'hint': 'm开头'},
    {'word': '爸爸', 'pinyin': 'bà ba', 'hint': 'b开头'},
    {'word': '苹果', 'pinyin': 'píng guǒ', 'hint': 'p开头'},
    {'word': '西瓜', 'pinyin': 'xī guā', 'hint': 'x开头'},
    {'word': '学习', 'pinyin': 'xué xí', 'hint': 'x开头'},
    {'word': '朋友', 'pinyin': 'péng you', 'hint': 'p开头'},
    {'word': '老师', 'pinyin': 'lǎo shī', 'hint': 'l开头'},
    {'word': '同学', 'pinyin': 'tóng xué', 'hint': 't开头'},
    {'word': '学校', 'pinyin': 'xué xiào', 'hint': 'x开头'},
    {'word': '中国', 'pinyin': 'zhōng guó', 'hint': 'zh开头'},
  ];

  late Map<String, dynamic> _currentChallenge;
  late List<Map<String, dynamic>> _options;
  int _score = 0;
  int _round = 0;
  static const int _totalRounds = 10;

  @override
  void initState() {
    super.initState();
    _generateNewRound();
  }

  void _generateNewRound() {
    final random = Random();
    _currentChallenge = _challenges[random.nextInt(_challenges.length)];

    _options = [_currentChallenge];
    while (_options.length < 4) {
      final option = _challenges[random.nextInt(_challenges.length)];
      if (!_options.contains(option)) {
        _options.add(option);
      }
    }
    _options.shuffle();
  }

  void _checkAnswer(Map<String, dynamic> selected) {
    setState(() {
      if (selected['word'] == _currentChallenge['word']) {
        _score += 15;
        _round++;
        if (_round < _totalRounds) {
          _generateNewRound();
        } else {
          _showCompleteDialog();
        }
      } else {
        _showWrongFeedback();
      }
    });
  }

  void _showWrongFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('正确答案是: ${_currentChallenge['word']}'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showCompleteDialog() {
    final stars = _score >= 120 ? 3 : (_score >= 80 ? 2 : 1);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('闯关成功！'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                stars,
                (index) => const Icon(Icons.star, color: Colors.amber, size: 40),
              ),
            ),
            const SizedBox(height: 10),
            Text('得分: $_score'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('返回'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('第 $_round/$_totalRounds 关', style: const TextStyle(fontSize: 18)),
              Text('得分: $_score', style: const TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
            ),
            child: Column(
              children: [
                Text(
                  _currentChallenge['word'],
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  '提示: ${_currentChallenge['hint']}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text('选择正确的拼音', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            alignment: WrapAlignment.center,
            children: _options.map((option) {
              return GestureDetector(
                onTap: () => _checkAnswer(option),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                  ),
                  child: Text(
                    option['pinyin'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: 提交**

```bash
git add lib/games/pinyin/pinyin_challenge_game.dart
git commit -m "feat: add pinyin challenge game for large class

- Match Chinese words with their pinyin
- 10 levels with hints
- Higher difficulty

Co-Authored-By: wangzy33973"
```

---

#### Task 20: 自由绘画游戏

**Files:**
- Create: `lib/games/drawing/drawing_game.dart`

- [ ] **Step 1: 创建自由绘画游戏 drawing_game.dart**

```dart
import 'package:flutter/material.dart';

class DrawingGame extends StatefulWidget {
  const DrawingGame({super.key});

  @override
  State<DrawingGame> createState() => _DrawingGameState();
}

class _DrawingGameState extends State<DrawingGame> {
  final List<Color> _colors = [
    Colors.red, Colors.orange, Colors.yellow, Colors.green,
    Colors.blue, Colors.purple, Colors.black, Colors.brown,
  ];

  final List<double> _brushSizes = [4.0, 8.0, 12.0, 20.0];

  Color _selectedColor = Colors.black;
  double _brushSize = 8.0;
  List<List<Offset?>> _strokes = [];
  List<Offset?> _currentStroke = [];

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _currentStroke = [details.localPosition];
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _currentStroke.add(details.localPosition);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _strokes.add(List.from(_currentStroke));
      _currentStroke = [];
    });
  }

  void _clearCanvas() {
    setState(() {
      _strokes = [];
      _currentStroke = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              // 颜色选择
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _colors.length,
                  itemBuilder: (context, index) {
                    final color = _colors[index];
                    final isSelected = color == _selectedColor;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.white : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: isSelected
                              ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)]
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // 画笔大小
              ...List.generate(_brushSizes.length, (index) {
                final size = _brushSizes[index];
                final isSelected = size == _brushSize;
                return GestureDetector(
                  onTap: () => setState(() => _brushSize = size),
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.grey[300] : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          color: _selectedColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              // 清除按钮
              IconButton(
                onPressed: _clearCanvas,
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CustomPaint(
                  painter: _DrawingPainter(
                    strokes: _strokes,
                    currentStroke: _currentStroke,
                    color: _selectedColor,
                    brushSize: _brushSize,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<List<Offset?>> strokes;
  final List<Offset?> currentStroke;
  final Color color;
  final double brushSize;

  _DrawingPainter({
    required this.strokes,
    required this.currentStroke,
    required this.color,
    required this.brushSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = brushSize
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      _drawStroke(canvas, stroke, paint);
    }
    _drawStroke(canvas, currentStroke, paint);
  }

  void _drawStroke(Canvas canvas, List<Offset?> stroke, Paint paint) {
    for (int i = 0; i < stroke.length - 1; i++) {
      if (stroke[i] != null && stroke[i + 1] != null) {
        canvas.drawLine(stroke[i]!, stroke[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) => true;
}
```

- [ ] **Step 2: 提交**

```bash
git add lib/games/drawing/drawing_game.dart
git commit -m "feat: add free drawing game for large class

- Canvas with color selection
- Multiple brush sizes
- Clear canvas option

Co-Authored-By: wangzy33973"
```

---

### Phase 6: 奖励系统和进度存储

#### Task 21: Provider状态管理

**Files:**
- Create: `lib/providers/progress_provider.dart`
- Create: `lib/providers/game_provider.dart`

- [ ] **Step 1: 创建进度Provider progress_provider.dart**

```dart
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
```

- [ ] **Step 2: 创建游戏Provider game_provider.dart**

```dart
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
```

- [ ] **Step 3: 提交**

```bash
git add lib/providers/
git commit -m "feat: add progress and game state providers

- ProgressNotifier for user progress tracking
- GameState for current game session

Co-Authored-By: wangzy33973"
```

---

### Phase 7: 音效和动画集成

#### Task 22: 音效资源文件夹结构

**Files:**
- Create: `assets/audio/.gitkeep` (占位文件)

- [ ] **Step 1: 创建音频资源目录说明**

在项目中创建 `assets/audio/` 目录，添加以下音效文件（需自行准备或下载）：
- `bgm.mp3` - 背景音乐
- `correct.mp3` - 正确答案音效
- `wrong.mp3` - 错误答案音效
- `star.mp3` - 获得星星音效
- `click.mp3` - 点击按钮音效
- `win.mp3` - 通关胜利音效

- [ ] **Step 2: 更新pubspec.yaml**

```yaml
flutter:
  assets:
    - assets/logo/
    - assets/audio/
```

- [ ] **Step 3: 提交**

```bash
git add assets/audio/
git commit -m "feat: add audio assets structure

Note: Add actual audio files to assets/audio/

Co-Authored-By: wangzy33973"
```

---

### Phase 8: 测试和发布准备

#### Task 23: 项目配置和清理

**Files:**
- Modify: `pubspec.yaml`
- Create: `analysis_options.yaml`

- [ ] **Step 1: 配置analysis_options.yaml**

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    avoid_print: false
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
```

- [ ] **Step 2: 提交**

```bash
git add analysis_options.yaml
git commit -m "chore: add analysis options configuration

Co-Authored-By: wangzy33973"
```

---

## 实施检查清单

- [ ] Phase 1: 基础框架搭建完成
- [ ] Phase 2: 启动页和首页完成
- [ ] Phase 3: 小班游戏（形状、颜色、大小、配对、连连看）完成
- [ ] Phase 4: 中班游戏（数数、加法、词汇）完成
- [ ] Phase 5: 大班游戏（拼音、绘画）完成
- [ ] Phase 6: 奖励系统和数据存储完成
- [ ] Phase 7: 音效和动画集成完成
- [ ] Phase 8: 测试和发布准备完成

---

**作者**：wangzy33973
**创建日期**：2026-05-07
