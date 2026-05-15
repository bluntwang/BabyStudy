import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import '../core/theme/app_theme.dart';
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

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    );
    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ageColor = _getAgeGroupColor(widget.ageGroup);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ageColor.withValues(alpha: 0.15),
              ageColor.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, ageColor),
              Expanded(
                child: _buildGameWidget(widget.gameType),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color ageColor) {
    return AnimatedBuilder(
      animation: _headerAnimation,
      builder: (context, child) {
        final animValue = _headerAnimation.value.clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, -20 * (1 - animValue)),
          child: Opacity(
            opacity: animValue,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: ageColor.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: ageColor,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGameTitle(widget.gameType),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textColor,
                          ),
                        ),
                        Text(
                          _getAgeGroupHint(),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: ageColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _getGameIcon(widget.gameType),
                      color: ageColor,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.construction_rounded,
              size: 50,
              color: AppTheme.primaryOrange,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '即将推出',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '敬请期待',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
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

  String _getAgeGroupHint() {
    switch (widget.ageGroup) {
      case 'small':
        return '小班 · 基础认知';
      case 'medium':
        return '中班 · 进阶学习';
      case 'large':
        return '大班 · 学前准备';
      default:
        return '';
    }
  }

  IconData _getGameIcon(String type) {
    final icons = {
      'shape': Icons.category_rounded,
      'color': Icons.palette_rounded,
      'size': Icons.straighten_rounded,
      'matching': Icons.grid_view_rounded,
      'connect': Icons.link_rounded,
      'counting': Icons.numbers_rounded,
      'addition': Icons.add_circle_rounded,
      'vocabulary': Icons.book_rounded,
      'speaking': Icons.image_rounded,
      'pinyin': Icons.abc_rounded,
      'pinyin_game': Icons.flag_rounded,
      'drawing': Icons.brush_rounded,
      'story': Icons.auto_stories_rounded,
      'animal': Icons.pets_rounded,
    };
    return icons[type] ?? Icons.gamepad_rounded;
  }

  Color _getAgeGroupColor(String key) {
    switch (key) {
      case 'small':
        return AppTheme.smallClassColor;
      case 'medium':
        return AppTheme.mediumClassColor;
      case 'large':
        return AppTheme.largeClassColor;
      default:
        return AppTheme.primaryBlue;
    }
  }
}