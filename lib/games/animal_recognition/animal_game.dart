import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../services/audio_service.dart';

class AnimalGame extends StatefulWidget {
  const AnimalGame({super.key});

  @override
  State<AnimalGame> createState() => _AnimalGameState();
}

class _AnimalGameState extends State<AnimalGame>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _animals = [
    {'name': '小猫', 'emoji': '🐱', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Cat_November_2010-1a.jpg/400px-Cat_November_2010-1a.jpg', 'sound': '喵喵', 'category': '陆地'},
    {'name': '小狗', 'emoji': '🐶', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Golden_Retriever_Duk.jpg/400px-Golden_Retriever_Duk.jpg', 'sound': '汪汪', 'category': '陆地'},
    {'name': '小兔子', 'emoji': '🐰', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Rabbit_standing.jpg/400px-Rabbit_standing.jpg', 'sound': '咕咕', 'category': '陆地'},
    {'name': '小熊', 'emoji': '🐻', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/2010-kodiak-bear-1.jpg/400px-2010-kodiak-bear-1.jpg', 'sound': '嗷嗷', 'category': '陆地'},
    {'name': '熊猫', 'emoji': '🐼', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Giant_Panda_20.jpg/400px-Giant_Panda_20.jpg', 'sound': '哼哼', 'category': '陆地'},
    {'name': '老虎', 'emoji': '🐯', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Walking_tiger_female.jpg/400px-Walking_tiger_female.jpg', 'sound': '嗷呜', 'category': '陆地'},
    {'name': '狮子', 'emoji': '🦁', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Lion_waiting_in_Namibia.jpg/400px-Lion_waiting_in_Namibia.jpg', 'sound': '吼吼', 'category': '陆地'},
    {'name': '小猴子', 'emoji': '🐵', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Bonnet_macaque_%28Macaca_radiata%29_Photograph_By_Shantanu_Kuveskar.jpg/400px-Bonnet_macaque_%28Macaca_radiata%29_Photograph_By_Shantanu_Kuveskar.jpg', 'sound': '叽叽', 'category': '陆地'},
    {'name': '小猪', 'emoji': '🐷', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/Pig_portrait.jpg/400px-Pig_portrait.jpg', 'sound': '哼哼', 'category': '陆地'},
    {'name': '小马', 'emoji': '🐴', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/de/Nokota_Horses_cropped.jpg/400px-Nokota_Horses_cropped.jpg', 'sound': '嘶嘶', 'category': '陆地'},
    {'name': '小牛', 'emoji': '🐮', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Angusbull.jpg/400px-Angusbull.jpg', 'sound': '哞哞', 'category': '陆地'},
    {'name': '小山羊', 'emoji': '🐐', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b2/Hausziege_04.jpg/400px-Hausziege_04.jpg', 'sound': '咩咩', 'category': '陆地'},
    {'name': '小绵羊', 'emoji': '🐑', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Flock_of_sheep.jpg/400px-Flock_of_sheep.jpg', 'sound': '咩咩', 'category': '陆地'},
    {'name': '小鸡', 'emoji': '🐤', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/Chicken_portrait.jpg/400px-Chicken_portrait.jpg', 'sound': '叽叽', 'category': '陆地'},
    {'name': '小青蛙', 'emoji': '🐸', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Red-eyed_tree_frog_-Agalychnis_callidryas-2.jpg/400px-Red-eyed_tree_frog_-Agalychnis_callidryas-2.jpg', 'sound': '呱呱', 'category': '陆地'},
    {'name': '小狐狸', 'emoji': '🦊', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Red_Fox.jpg/400px-Red_Fox.jpg', 'sound': '嗷嗷', 'category': '陆地'},
    {'name': '小鹿', 'emoji': '🦌', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/37/Red_deer_schema.jpg/400px-Red_deer_schema.jpg', 'sound': '呦呦', 'category': '陆地'},
    {'name': '小鱼', 'emoji': '🐟', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Peacock_gudgeon.jpg/400px-Peacock_gudgeon.jpg', 'sound': '咕噜', 'category': '海洋'},
    {'name': '小鲸鱼', 'emoji': '🐋', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/63/Anim1754_-_Flickr_-_NOAA_Photo_Library.jpg/400px-Anim1754_-_Flickr_-_NOAA_Photo_Library.jpg', 'sound': '呜呜', 'category': '海洋'},
    {'name': '小海豚', 'emoji': '🐬', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Bottlenose_dolphin.jpg/400px-Bottlenose_dolphin.jpg', 'sound': '吱吱', 'category': '海洋'},
    {'name': '小鲨鱼', 'emoji': '🦈', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/GreatWhiteShark.jpg/400px-GreatWhiteShark.jpg', 'sound': '呼呼', 'category': '海洋'},
    {'name': '小海龟', 'emoji': '🐢', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/Sea_turtle_1.jpg/400px-Sea_turtle_1.jpg', 'sound': '爬爬', 'category': '海洋'},
    {'name': '小螃蟹', 'emoji': '🦀', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Cancer_pagurus.jpg/400px-Cancer_pagurus.jpg', 'sound': '咔咔', 'category': '海洋'},
    {'name': '小章鱼', 'emoji': '🐙', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Common_Octopus.jpg/400px-Common_Octopus.jpg', 'sound': '呼呼', 'category': '海洋'},
    {'name': '小海马', 'emoji': '🦭', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Hippocampus_bleekeri.jpg/400px-Hippocampus_bleekeri.jpg', 'sound': '哼哼', 'category': '海洋'},
    {'name': '小老鹰', 'emoji': '🦅', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Bald_Eagle_at_Las_Vegas.jpg/400px-Bald_Eagle_at_Las_Vegas.jpg', 'sound': '啸啸', 'category': '天空'},
    {'name': '小鹦鹉', 'emoji': '🦜', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/be/Psittacula_eupatria_0.jpg/400px-Psittacula_eupatria_0.jpg', 'sound': '叽叽', 'category': '天空'},
    {'name': '小鸽子', 'emoji': '🕊', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Rock_pigeon_on_the_West_Lake.jpg/400px-Rock_pigeon_on_the_West_Lake.jpg', 'sound': '咕咕', 'category': '天空'},
    {'name': '小鸭子', 'emoji': '🦆', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/Anas_platyrhynchos_male_female_quadrat.jpg/400px-Anas_platyrhynchos_male_female_quadrat.jpg', 'sound': '嘎嘎', 'category': '天空'},
    {'name': '小天鹅', 'emoji': '🦢', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bb/Mute_swan_1.jpg/400px-Mute_swan_1.jpg', 'sound': '啊啊', 'category': '天空'},
    {'name': '小蝴蝶', 'emoji': '🦋', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Butterfly_Purple_ Emperor.jpg/400px-Butterfly_Purple_Emperor.jpg', 'sound': '翩翩', 'category': '天空'},
    {'name': '小蜜蜂', 'emoji': '🐝', 'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/European_honey_bee.jpg/400px-European_honey_bee.jpg', 'sound': '嗡嗡', 'category': '天空'},
  ];

  late Map<String, dynamic> _targetAnimal;
  late List<Map<String, dynamic>> _options;
  int _score = 0;
  int _round = 0;
  static const int _totalRounds = 10;
  final Set<int> _usedAnimalIndices = {};
  final Random _random = Random();
  final AudioService _audioService = AudioService();

  late AnimationController _cardController;
  late Animation<double> _cardAnimation;

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _cardAnimation = CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutBack,
    );
    _generateNewRound();
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  void _generateNewRound() {
    if (_usedAnimalIndices.length >= _animals.length) {
      _usedAnimalIndices.clear();
    }

    int availableIndex;
    do {
      availableIndex = _random.nextInt(_animals.length);
    } while (_usedAnimalIndices.contains(availableIndex));

    _usedAnimalIndices.add(availableIndex);
    _targetAnimal = _animals[availableIndex];

    _options = [_targetAnimal];
    while (_options.length < 4) {
      final optionIndex = _random.nextInt(_animals.length);
      final option = _animals[optionIndex];
      if (!_options.contains(option)) {
        _options.add(option);
      }
    }
    _options.shuffle();

    _cardController.reset();
    _cardController.forward();
  }

  void _checkAnswer(Map<String, dynamic> selected) {
    if (selected['name'] == _targetAnimal['name']) {
      setState(() {
        _score += 10;
        _round++;
      });
      _audioService.playCorrect();
      if (_round < _totalRounds) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _generateNewRound();
        });
      } else {
        _showCompleteDialog();
      }
    } else {
      _showWrongFeedback();
      _audioService.playWrong();
    }
  }

  void _showWrongFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('没关系，再想想！', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(_targetAnimal['emoji'], style: const TextStyle(fontSize: 20)),
          ],
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: AppTheme.primaryOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showCompleteDialog() {
    _audioService.playWin();
    final stars = (_score / 10).round().clamp(0, 3);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            // 星星动画
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 300 + index * 150),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: index < stars ? value : 0.5,
                      child: Icon(
                        Icons.star_rounded,
                        color: index < stars ? Colors.amber : Colors.grey[300],
                        size: 50,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '太棒了！',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '得分: $_score',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildResultChip(Icons.check_circle, '$_round 题'),
                const SizedBox(width: 12),
                _buildResultChip(Icons.star, '$stars 星'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              '返回',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _score = 0;
                _round = 0;
              });
              _generateNewRound();
            },
            child: const Text('再来一次', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildResultChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.primaryBlue),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case '海洋':
        return const Color(0xFF4A90D9);
      case '天空':
        return const Color(0xFFFF8C42);
      case '陆地':
      default:
        return const Color(0xFF4CD964);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 顶部状态栏
          _buildStatusBar(),
          const SizedBox(height: 20),
          // 问题标题
          Text(
            '这是哪个动物？',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 20),
          // 目标动物卡片
          ScaleTransition(
            scale: _cardAnimation,
            child: _buildTargetAnimalCard(),
          ),
          const SizedBox(height: 20),
          // 选项网格
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: _options.length,
              itemBuilder: (context, index) {
                final animal = _options[index];
                return _buildOptionCard(animal, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 18, color: AppTheme.primaryBlue),
                    const SizedBox(width: 4),
                    Text(
                      '$_round/$_totalRounds',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, size: 18, color: AppTheme.primaryOrange),
                    const SizedBox(width: 4),
                    Text(
                      '$_score',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTargetAnimalCard() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: _getCategoryColor(_targetAnimal['category']).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.network(
                _targetAnimal['imageUrl'],
                width: 160,
                height: 160,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: Text(
                      _targetAnimal['emoji'],
                      style: const TextStyle(fontSize: 80),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      _targetAnimal['emoji'],
                      style: const TextStyle(fontSize: 80),
                    ),
                  );
                },
              ),
            ),
          ),
          // 分类标签
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getCategoryColor(_targetAnimal['category']),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _targetAnimal['category'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(Map<String, dynamic> animal, int index) {
    return GestureDetector(
      onTap: () => _checkAnswer(animal),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _getCategoryColor(animal['category']).withOpacity(0.85),
              _getCategoryColor(animal['category']),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _getCategoryColor(animal['category']).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  animal['imageUrl'],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: Text(
                        animal['emoji'],
                        style: const TextStyle(fontSize: 36),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        animal['emoji'],
                        style: const TextStyle(fontSize: 36),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                animal['name'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}