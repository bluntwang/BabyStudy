import 'package:flutter/material.dart';

class ConnectGame extends StatefulWidget {
  const ConnectGame({super.key});

  @override
  State<ConnectGame> createState() => _ConnectGameState();
}

class _ConnectGameState extends State<ConnectGame> {
  final List<IconData> _icons = [
    Icons.star, Icons.favorite, Icons.circle, Icons.square,
    Icons.pets, Icons.cake, Icons.music_note, Icons.flight,
  ];

  late List<int> _items;
  late List<bool> _matched;
  int _firstIndex = -1;
  int _matches = 0;
  int _score = 0;
  static const int _totalMatches = 4;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    final pairs = [0, 1, 2, 3, 0, 1, 2, 3];
    pairs.shuffle();
    _items = pairs;
    _matched = List<bool>.filled(8, false);
    _firstIndex = -1;
    _matches = 0;
    _score = 0;
  }

  void _onItemTap(int index) {
    if (_matched[index]) return;
    if (_firstIndex == -1) {
      setState(() => _firstIndex = index);
    } else {
      if (_items[_firstIndex] == _items[index] && _firstIndex != index) {
        setState(() {
          _matched[_firstIndex] = true;
          _matched[index] = true;
          _matches++;
          _score += 20;
          _firstIndex = -1;
          if (_matches == _totalMatches) {
            _showCompleteDialog();
          }
        });
      } else {
        setState(() => _firstIndex = -1);
      }
    }
  }

  void _showCompleteDialog() {
    final stars = (_score / 20).round().clamp(0, 3);
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
              Text('配对: $_matches/$_totalMatches', style: const TextStyle(fontSize: 18)),
              Text('得分: $_score', style: const TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 20),
          const Text('点击两个相同的图标', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                final isSelected = _firstIndex == index;
                final isMatched = _matched[index];

                return GestureDetector(
                  onTap: () => _onItemTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isMatched
                          ? Colors.green.withOpacity(0.3)
                          : isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isMatched
                            ? Colors.green
                            : isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade300,
                        width: 2,
                      ),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                    ),
                    child: Center(
                      child: Icon(
                        _icons[_items[index]],
                        size: 40,
                        color: isMatched
                            ? Colors.green
                            : isSelected
                                ? Colors.white
                                : Theme.of(context).primaryColor,
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
