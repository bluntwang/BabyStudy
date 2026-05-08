import 'package:flutter/material.dart';
import '../core/router/app_router.dart';

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
          {'name': '动物认知', 'icon': Icons.pets, 'type': 'animal'},
          {'name': '大小识别', 'icon': Icons.straighten, 'type': 'size'},
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
