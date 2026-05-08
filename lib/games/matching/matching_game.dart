import 'dart:math';
import 'package:flutter/material.dart';

class MatchingGame extends StatefulWidget {
  const MatchingGame({super.key});

  @override
  State<MatchingGame> createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  final List<Map<String, dynamic>> _patterns = [
    {'emoji': '🌟', 'color': Colors.amber},
    {'emoji': '🍎', 'color': Colors.red},
    {'emoji': '🦋', 'color': Colors.blue},
    {'emoji': '🌸', 'color': Colors.pink},
    {'emoji': '🐱', 'color': Colors.orange},
    {'emoji': '🌈', 'color': Colors.purple},
  ];

  late List<int> _cards;
  late List<bool> _flipped;
  late List<bool> _matched;
  int _firstIndex = -1;
  int _secondIndex = -1;
  int _matches = 0;
  int _attempts = 0;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    final pairs = [0, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5];
    pairs.shuffle();
    _cards = pairs;
    _flipped = List<bool>.filled(12, false);
    _matched = List<bool>.filled(12, false);
    _firstIndex = -1;
    _secondIndex = -1;
    _matches = 0;
    _attempts = 0;
  }

  void _onCardTap(int index) {
    if (_flipped[index] || _matched[index]) return;

    setState(() {
      _flipped[index] = true;
      if (_firstIndex == -1) {
        _firstIndex = index;
      } else {
        _secondIndex = index;
        _checkMatch();
      }
    });
  }

  void _checkMatch() {
    _attempts++;
    if (_cards[_firstIndex] == _cards[_secondIndex]) {
      setState(() {
        _matched[_firstIndex] = true;
        _matched[_secondIndex] = true;
        _matches++;
        _firstIndex = -1;
        _secondIndex = -1;
        if (_matches == 6) {
          _showCompleteDialog();
        }
      });
    } else {
      final first = _firstIndex;
      final second = _secondIndex;
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            if (first >= 0 && first < _flipped.length) {
              _flipped[first] = false;
            }
            if (second >= 0 && second < _flipped.length) {
              _flipped[second] = false;
            }
            _firstIndex = -1;
            _secondIndex = -1;
          });
        }
      });
    }
  }

  void _showCompleteDialog() {
    final stars = _attempts <= 8 ? 3 : (_attempts <= 12 ? 2 : 1);
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
            Text('尝试次数: $_attempts'),
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

  Color _getCardColor(int index) {
    return _patterns[_cards[index]]['color'];
  }

  String _getCardEmoji(int index) {
    return _patterns[_cards[index]]['emoji'];
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
              Text('配对: $_matches/6', style: const TextStyle(fontSize: 18)),
              Text('尝试: $_attempts', style: const TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 20),
          const Text('找出相同的配对', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final isFlipped = _flipped[index] || _matched[index];
                final isMatched = _matched[index];
                final cardColor = _getCardColor(index);

                return GestureDetector(
                  onTap: () => _onCardTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      gradient: isMatched
                          ? LinearGradient(
                              colors: [Colors.green.shade300, Colors.green.shade400],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : isFlipped
                              ? LinearGradient(
                                  colors: [cardColor.withOpacity(0.7), cardColor],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [
                                    Theme.of(context).primaryColor.withOpacity(0.5),
                                    Theme.of(context).primaryColor.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: isFlipped
                          ? Text(
                              _getCardEmoji(index),
                              style: const TextStyle(fontSize: 35),
                            )
                          : Icon(
                              Icons.touch_app,
                              color: Colors.white.withOpacity(0.9),
                              size: 35,
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}