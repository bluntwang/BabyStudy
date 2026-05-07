import 'dart:math';
import 'package:flutter/material.dart';

class ShapeGame extends StatefulWidget {
  const ShapeGame({super.key});

  @override
  State<ShapeGame> createState() => _ShapeGameState();
}

class _ShapeGameState extends State<ShapeGame> {
  final List<String> _shapes = ['circle', 'square', 'triangle', 'star', 'heart'];
  final Map<String, IconData> _shapeIcons = {
    'circle': Icons.circle,
    'square': Icons.square,
    'triangle': Icons.change_history,
    'star': Icons.star,
    'heart': Icons.favorite,
  };

  late String _targetShape;
  late List<String> _options;
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
    _targetShape = _shapes[random.nextInt(_shapes.length)];

    _options = [_targetShape];
    while (_options.length < 4) {
      final option = _shapes[random.nextInt(_shapes.length)];
      if (!_options.contains(option)) {
        _options.add(option);
      }
    }
    _options.shuffle();
  }

  void _checkAnswer(String selected) {
    setState(() {
      if (selected == _targetShape) {
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
          const Text('选择相同的形状', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
            ),
            child: Icon(
              _shapeIcons[_targetShape],
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: _options.map((shape) {
              return GestureDetector(
                onTap: () => _checkAnswer(shape),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                  ),
                  child: Icon(
                    _shapeIcons[shape],
                    size: 50,
                    color: Theme.of(context).primaryColor,
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
