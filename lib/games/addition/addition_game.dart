import 'dart:math';
import 'package:flutter/material.dart';

class AdditionGame extends StatefulWidget {
  const AdditionGame({super.key});

  @override
  State<AdditionGame> createState() => _AdditionGameState();
}

class _AdditionGameState extends State<AdditionGame> {
  int _num1 = 0;
  int _num2 = 0;
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
    _num1 = random.nextInt(5) + 1;
    _num2 = random.nextInt(5) + 1;

    final correctAnswer = _num1 + _num2;
    _options = [correctAnswer];
    while (_options.length < 4) {
      final option = random.nextInt(10) + 1;
      if (!_options.contains(option)) {
        _options.add(option);
      }
    }
    _options.shuffle();
  }

  void _checkAnswer(int selected) {
    final correct = _num1 + _num2;
    setState(() {
      if (selected == correct) {
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
        content: Text('再算一算！'),
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
          const SizedBox(height: 30),
          const Text('计算结果', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      '$_num1',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(Icons.add, size: 40),
                const SizedBox(width: 20),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      '$_num2',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                const Text('=', style: TextStyle(fontSize: 40)),
                const SizedBox(width: 20),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text('?', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
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
