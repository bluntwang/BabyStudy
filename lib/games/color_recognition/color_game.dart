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
  final Set<int> _usedColorIndices = {}; // 记录已出题目，确保不重复

  @override
  void initState() {
    super.initState();
    _generateNewRound();
  }

  void _generateNewRound() {
    final random = Random();

    // 如果所有颜色都用过了，重置记录
    if (_usedColorIndices.length >= _colors.length) {
      _usedColorIndices.clear();
    }

    // 选择一个未被使用过的颜色
    int availableIndex;
    do {
      availableIndex = random.nextInt(_colors.length);
    } while (_usedColorIndices.contains(availableIndex));

    _usedColorIndices.add(availableIndex);
    _targetColor = _colors[availableIndex];

    _options = [_targetColor];
    while (_options.length < 4) {
      final optionIndex = random.nextInt(_colors.length);
      final option = _colors[optionIndex];
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
