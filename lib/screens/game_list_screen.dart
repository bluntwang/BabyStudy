import 'package:flutter/material.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';

class GameListScreen extends StatelessWidget {
  final String ageGroup;

  const GameListScreen({super.key, required this.ageGroup});

  @override
  Widget build(BuildContext context) {
    final games = _getGamesForAgeGroup(ageGroup);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _getAgeGroupColor(ageGroup).withOpacity(0.15),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 自定义AppBar
              _buildAppBar(context),
              // 游戏网格
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      final game = games[index];
                      return _GameCard(
                        game: game,
                        color: _getAgeGroupColor(ageGroup),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // 返回按钮
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _getAgeGroupColor(ageGroup).withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: _getAgeGroupColor(ageGroup),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // 标题
          Text(
            _getAgeGroupName(ageGroup),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _getAgeGroupColor(ageGroup),
            ),
          ),
          const Spacer(),
          // 装饰图标
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getAgeGroupColor(ageGroup).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: _getAgeGroupColor(ageGroup),
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  '学习',
                  style: TextStyle(
                    color: _getAgeGroupColor(ageGroup),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
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
        return AppTheme.smallClassColor;
      case 'medium':
        return AppTheme.mediumClassColor;
      case 'large':
        return AppTheme.largeClassColor;
      default:
        return AppTheme.primaryBlue;
    }
  }

  List<Map<String, dynamic>> _getGamesForAgeGroup(String key) {
    switch (key) {
      case 'small':
        return [
          {'name': '形状识别', 'icon': Icons.category_rounded, 'type': 'shape'},
          {'name': '颜色识别', 'icon': Icons.palette_rounded, 'type': 'color'},
          {'name': '动物认知', 'icon': Icons.pets_rounded, 'type': 'animal'},
          {'name': '大小识别', 'icon': Icons.straighten_rounded, 'type': 'size'},
        ];
      case 'medium':
        return [
          {'name': '数数游戏', 'icon': Icons.numbers_rounded, 'type': 'counting'},
          {'name': '加减法', 'icon': Icons.add_circle_rounded, 'type': 'addition'},
          {'name': '词汇学习', 'icon': Icons.book_rounded, 'type': 'vocabulary'},
          {'name': '看图说话', 'icon': Icons.image_rounded, 'type': 'speaking'},
        ];
      case 'large':
        return [
          {'name': '拼音认知', 'icon': Icons.abc_rounded, 'type': 'pinyin'},
          {'name': '拼音闯关', 'icon': Icons.flag_rounded, 'type': 'pinyin_game'},
          {'name': '自由绘画', 'icon': Icons.brush_rounded, 'type': 'drawing'},
          {'name': '故事创编', 'icon': Icons.auto_stories_rounded, 'type': 'story'},
        ];
      default:
        return [];
    }
  }
}

class _GameCard extends StatefulWidget {
  final Map<String, dynamic> game;
  final Color color;
  final VoidCallback onTap;

  const _GameCard({
    required this.game,
    required this.color,
    required this.onTap,
  });

  @override
  State<_GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<_GameCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(_isPressed ? 0.3 : 0.15),
                    blurRadius: _isPressed ? 15 : 10,
                    offset: Offset(0, _isPressed ? 8 : 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 图标容器
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.color.withOpacity(0.15),
                          widget.color.withOpacity(0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      widget.game['icon'],
                      size: 38,
                      color: widget.color,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // 游戏名称
                  Text(
                    widget.game['name'],
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // 装饰点
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(0.3 + index * 0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}