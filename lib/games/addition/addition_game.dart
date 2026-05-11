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
  String _operator = '+'; // 运算符：加法或减法
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

    // 随机选择加法或减法
    _operator = random.nextBool() ? '+' : '-';

    if (_operator == '+') {
      // 加法：结果不超过 10
      _num1 = random.nextInt(5) + 1;
      _num2 = random.nextInt(5) + 1;
      final correctAnswer = _num1 + _num2;
      _options = _generateOptions(correctAnswer, 1, 10);
    } else {
      // 减法：结果不能为负数
      _num1 = random.nextInt(5) + 5; // 5-9
      _num2 = random.nextInt(_num1) + 1; // 1 到 _num1
      final correctAnswer = _num1 - _num2;
      _options = _generateOptions(correctAnswer, 0, 9);
    }
    _options.shuffle();
  }

  List<int> _generateOptions(int correctAnswer, int min, int max) {
    final random = Random();
    final options = <int>[correctAnswer];
    while (options.length < 4) {
      // 在正确答案附近生成干扰项
      int option = correctAnswer + random.nextInt(5) - 2;
      if (option < min) option = min;
      if (option > max) option = max;
      if (!options.contains(option)) {
        options.add(option);
      }
    }
    return options;
  }

  Widget _buildNumberBox(String text, Color bgColor) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildOperatorBox() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _operator == '+' ? Colors.orange.withOpacity(0.2) : Colors.purple.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          _operator,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: _operator == '+' ? Colors.orange : Colors.purple,
          ),
        ),
      ),
    );
  }

  void _checkAnswer(int selected) {
    final correct = _operator == '+' ? _num1 + _num2 : _num1 - _num2;
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
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNumberBox('$_num1', Colors.red.withOpacity(0.2)),
                  const SizedBox(width: 15),
                  _buildOperatorBox(),
                  const SizedBox(width: 15),
                  _buildNumberBox('$_num2', Colors.blue.withOpacity(0.2)),
                  const SizedBox(width: 15),
                  const Text('=', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 15),
                  _buildNumberBox('?', Colors.green.withOpacity(0.2)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
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
