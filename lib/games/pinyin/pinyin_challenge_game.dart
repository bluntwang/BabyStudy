import 'dart:math';
import 'package:flutter/material.dart';

class PinyinChallengeGame extends StatefulWidget {
  const PinyinChallengeGame({super.key});

  @override
  State<PinyinChallengeGame> createState() => _PinyinChallengeGameState();
}

class _PinyinChallengeGameState extends State<PinyinChallengeGame> {
  final List<Map<String, dynamic>> _challenges = [
    {'word': '妈妈', 'pinyin': 'mā ma', 'hint': 'm开头'},
    {'word': '爸爸', 'pinyin': 'bà ba', 'hint': 'b开头'},
    {'word': '苹果', 'pinyin': 'píng guǒ', 'hint': 'p开头'},
    {'word': '西瓜', 'pinyin': 'xī guā', 'hint': 'x开头'},
    {'word': '学习', 'pinyin': 'xué xí', 'hint': 'x开头'},
    {'word': '朋友', 'pinyin': 'péng you', 'hint': 'p开头'},
    {'word': '老师', 'pinyin': 'lǎo shī', 'hint': 'l开头'},
    {'word': '同学', 'pinyin': 'tóng xué', 'hint': 't开头'},
    {'word': '学校', 'pinyin': 'xué xiào', 'hint': 'x开头'},
    {'word': '中国', 'pinyin': 'zhōng guó', 'hint': 'zh开头'},
  ];

  late Map<String, dynamic> _currentChallenge;
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
    _currentChallenge = _challenges[random.nextInt(_challenges.length)];

    _options = [_currentChallenge];
    while (_options.length < 4) {
      final option = _challenges[random.nextInt(_challenges.length)];
      if (!_options.contains(option)) {
        _options.add(option);
      }
    }
    _options.shuffle();
  }

  void _checkAnswer(Map<String, dynamic> selected) {
    setState(() {
      if (selected['word'] == _currentChallenge['word']) {
        _score += 15;
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
      SnackBar(
        content: Text('正确答案是: ${_currentChallenge['word']}'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showCompleteDialog() {
    final stars = _score >= 120 ? 3 : (_score >= 80 ? 2 : 1);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('闯关成功！'),
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
              Text('第 $_round/$_totalRounds 关', style: const TextStyle(fontSize: 18)),
              Text('得分: $_score', style: const TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
            ),
            child: Column(
              children: [
                Text(
                  _currentChallenge['word'],
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  '提示: ${_currentChallenge['hint']}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text('选择正确的拼音', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            alignment: WrapAlignment.center,
            children: _options.map((option) {
              return GestureDetector(
                onTap: () => _checkAnswer(option),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                  ),
                  child: Text(
                    option['pinyin'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
