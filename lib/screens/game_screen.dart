import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../games/shape_recognition/shape_game.dart';
import '../games/color_recognition/color_game.dart';
import '../games/size_recognition/size_game.dart';
import '../games/matching/matching_game.dart';
import '../games/connect_dots/connect_game.dart';
import '../games/counting/counting_game.dart';
import '../games/addition/addition_game.dart';
import '../games/vocabulary/vocabulary_game.dart';
import '../games/drawing/drawing_game.dart';
import '../games/pinyin/pinyin_game.dart';
import '../games/pinyin/pinyin_challenge_game.dart';
import '../games/animal_recognition/animal_game.dart';

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
  final AudioService _audioService = AudioService();

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
        child: _buildGameWidget(widget.gameType),
      ),
    );
  }

  Widget _buildGameWidget(String gameType) {
    switch (gameType) {
      case 'shape':
        return const ShapeGame();
      case 'color':
        return const ColorGame();
      case 'size':
        return const SizeGame();
      case 'matching':
        return const MatchingGame();
      case 'connect':
        return const ConnectGame();
      case 'counting':
        return const CountingGame();
      case 'addition':
        return const AdditionGame();
      case 'vocabulary':
        return const VocabularyGame();
      case 'pinyin':
        return const PinyinGame();
      case 'pinyin_game':
        return const PinyinChallengeGame();
      case 'drawing':
        return const DrawingGame();
      case 'animal':
        return const AnimalGame();
      case 'speaking':
        return _buildComingSoon();
      case 'story':
        return _buildComingSoon();
      default:
        return Center(
          child: Text(
            '游戏: $gameType',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        );
    }
  }

  Widget _buildComingSoon() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.construction, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            '即将推出',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
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
      'addition': '加减法',
      'vocabulary': '词汇学习',
      'speaking': '看图说话',
      'pinyin': '拼音认知',
      'pinyin_game': '拼音闯关',
      'drawing': '自由绘画',
      'story': '故事创编',
      'animal': '动物认知',
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
