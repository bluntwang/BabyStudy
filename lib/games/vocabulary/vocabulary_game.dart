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
