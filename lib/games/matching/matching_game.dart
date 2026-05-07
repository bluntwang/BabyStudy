import 'dart:math';
import 'package:flutter/material.dart';

class MatchingGame extends StatefulWidget {
  const MatchingGame({super.key});

  @override
  State<MatchingGame> createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  final List<IconData> _icons = [
    Icons.pets,
    Icons.cake,
    Icons.flight,
    Icons.music_note,
    Icons.star,
    Icons.favorite,
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
    final pairs = List<int>.from([0, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5]);
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
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _flipped[_firstIndex] = false;
            _flipped[_secondIndex] = false;
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

                return GestureDetector(
                  onTap: () => _onCardTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: isMatched
                          ? Colors.green.withOpacity(0.3)
                          : isFlipped
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                    ),
                    child: Center(
                      child: isFlipped
                          ? Icon(
                              _icons[_cards[index]],
                              size: 40,
                              color: Theme.of(context).primaryColor,
                            )
                          : const Icon(Icons.question_mark, color: Colors.white, size: 40),
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
