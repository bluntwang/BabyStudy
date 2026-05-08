import 'dart:math';
import 'package:flutter/material.dart';

class ShapeGame extends StatefulWidget {
  const ShapeGame({super.key});

  @override
  State<ShapeGame> createState() => _ShapeGameState();
}

class _ShapeGameState extends State<ShapeGame> {
  final List<Map<String, dynamic>> _shapes = [
    {'name': '圆形', 'type': 'circle', 'color': Colors.red},
    {'name': '方形', 'type': 'square', 'color': Colors.orange},
    {'name': '三角形', 'type': 'triangle', 'color': Colors.yellow},
    {'name': '星形', 'type': 'star', 'color': Colors.purple},
    {'name': '心形', 'type': 'heart', 'color': Colors.pink},
    {'name': '钻石形', 'type': 'diamond', 'color': Colors.cyan},
  ];

  late Map<String, dynamic> _targetShape;
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

  void _checkAnswer(String selected, Color color) {
    setState(() {
      if (selected == _targetShape['type'] && color == _targetShape['color']) {
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CustomPaint(
              painter: CartoonShapePainter(
                _targetShape['type'],
                _targetShape['color'],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _targetShape['name'],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _targetShape['color'],
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: _options.map((shape) {
              return GestureDetector(
                onTap: () => _checkAnswer(shape['type'], shape['color']),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    painter: CartoonShapePainter(
                      shape['type'],
                      shape['color'],
                      scale: 0.5,
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

class CartoonShapePainter extends CustomPainter {
  final String shapeType;
  final Color color;
  final double scale;

  CartoonShapePainter(this.shapeType, this.color, {this.scale = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * scale;

    final center = Offset(size.width / 2, size.height / 2);

    switch (shapeType) {
      case 'circle':
        _drawCircle(canvas, center, size, paint, strokePaint);
        break;
      case 'square':
        _drawSquare(canvas, center, size, paint, strokePaint);
        break;
      case 'triangle':
        _drawTriangle(canvas, center, size, paint, strokePaint);
        break;
      case 'star':
        _drawStar(canvas, center, size, paint, strokePaint);
        break;
      case 'heart':
        _drawHeart(canvas, center, size, paint, strokePaint);
        break;
      case 'diamond':
        _drawDiamond(canvas, center, size, paint, strokePaint);
        break;
    }
  }

  void _drawCircle(Canvas canvas, Offset center, Size size, Paint paint, Paint strokePaint) {
    final radius = size.width * 0.35 * scale;
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center, radius, strokePaint);

    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.3),
      radius * 0.25,
      highlightPaint,
    );
  }

  void _drawSquare(Canvas canvas, Offset center, Size size, Paint paint, Paint strokePaint) {
    final rect = Rect.fromCenter(
      center: center,
      width: size.width * 0.6 * scale,
      height: size.height * 0.6 * scale,
    );
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(10 * scale));
    canvas.drawRRect(rrect, paint);
    canvas.drawRRect(rrect, strokePaint);

    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          center.dx - size.width * 0.25 * scale,
          center.dy - size.height * 0.25 * scale,
          size.width * 0.15 * scale,
          size.height * 0.15 * scale,
        ),
        Radius.circular(5 * scale),
      ),
      highlightPaint,
    );
  }

  void _drawTriangle(Canvas canvas, Offset center, Size size, Paint paint, Paint strokePaint) {
    final path = Path();
    final w = size.width * 0.5 * scale;
    final h = size.height * 0.45 * scale;
    path.moveTo(center.dx, center.dy - h);
    path.lineTo(center.dx + w, center.dy + h * 0.8);
    path.lineTo(center.dx - w, center.dy + h * 0.8);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);

    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    final highlightPath = Path();
    highlightPath.moveTo(center.dx, center.dy - h * 0.6);
    highlightPath.lineTo(center.dx + w * 0.3, center.dy - h * 0.2);
    highlightPath.lineTo(center.dx - w * 0.2, center.dy - h * 0.2);
    highlightPath.close();
    canvas.drawPath(highlightPath, highlightPaint);
  }

  void _drawStar(Canvas canvas, Offset center, Size size, Paint paint, Paint strokePaint) {
    final path = Path();
    final outerRadius = size.width * 0.4 * scale;
    final innerRadius = size.width * 0.18 * scale;
    const points = 5;

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (i * 3.14159 / points) - (3.14159 / 2);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);

    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx - outerRadius * 0.2, center.dy - outerRadius * 0.3),
      innerRadius * 0.4,
      highlightPaint,
    );
  }

  void _drawHeart(Canvas canvas, Offset center, Size size, Paint paint, Paint strokePaint) {
    final path = Path();
    final w = size.width * 0.5 * scale;
    final h = size.height * 0.45 * scale;

    path.moveTo(center.dx, center.dy + h * 0.7);
    path.cubicTo(
      center.dx - w, center.dy,
      center.dx - w, center.dy - h * 0.8,
      center.dx, center.dy - h * 0.3,
    );
    path.cubicTo(
      center.dx + w, center.dy - h * 0.8,
      center.dx + w, center.dy,
      center.dx, center.dy + h * 0.7,
    );

    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);

    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx - w * 0.35, center.dy - h * 0.4),
      w * 0.15,
      highlightPaint,
    );
  }

  void _drawDiamond(Canvas canvas, Offset center, Size size, Paint paint, Paint strokePaint) {
    final path = Path();
    final w = size.width * 0.4 * scale;
    final h = size.height * 0.45 * scale;

    path.moveTo(center.dx, center.dy - h);
    path.lineTo(center.dx + w, center.dy);
    path.lineTo(center.dx, center.dy + h);
    path.lineTo(center.dx - w, center.dy);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);

    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    final highlightPath = Path();
    highlightPath.moveTo(center.dx, center.dy - h * 0.6);
    highlightPath.lineTo(center.dx + w * 0.3, center.dy - h * 0.1);
    highlightPath.lineTo(center.dx, center.dy - h * 0.2);
    highlightPath.lineTo(center.dx - w * 0.2, center.dy - h * 0.1);
    highlightPath.close();
    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}