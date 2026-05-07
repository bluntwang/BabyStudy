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
