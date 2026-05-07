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
          Text('（从大到小排序）', style: const TextStyle(fontSize: 16)),
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
