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
                const Text(
                  '读作',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
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