import 'package:flutter/material.dart';

class DrawingGame extends StatefulWidget {
  const DrawingGame({super.key});

  @override
  State<DrawingGame> createState() => _DrawingGameState();
}

class _DrawingGameState extends State<DrawingGame> {
  final List<Color> _colors = [
    Colors.red, Colors.orange, Colors.yellow, Colors.green,
    Colors.blue, Colors.purple, Colors.black, Colors.brown,
  ];

  final List<double> _brushSizes = [4.0, 8.0, 12.0, 20.0];

  Color _selectedColor = Colors.black;
  double _brushSize = 8.0;
  List<List<Offset?>> _strokes = [];
  List<Offset?> _currentStroke = [];

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _currentStroke = [details.localPosition];
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _currentStroke.add(details.localPosition);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _strokes.add(List.from(_currentStroke));
      _currentStroke = [];
    });
  }

  void _clearCanvas() {
    setState(() {
      _strokes = [];
      _currentStroke = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              // 颜色选择
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _colors.length,
                  itemBuilder: (context, index) {
                    final color = _colors[index];
                    final isSelected = color == _selectedColor;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.white : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: isSelected
                              ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)]
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // 画笔大小
              ...List.generate(_brushSizes.length, (index) {
                final size = _brushSizes[index];
                final isSelected = size == _brushSize;
                return GestureDetector(
                  onTap: () => setState(() => _brushSize = size),
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.grey[300] : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          color: _selectedColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              // 清除按钮
              IconButton(
                onPressed: _clearCanvas,
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CustomPaint(
                  painter: _DrawingPainter(
                    strokes: _strokes,
                    currentStroke: _currentStroke,
                    color: _selectedColor,
                    brushSize: _brushSize,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<List<Offset?>> strokes;
  final List<Offset?> currentStroke;
  final Color color;
  final double brushSize;

  _DrawingPainter({
    required this.strokes,
    required this.currentStroke,
    required this.color,
    required this.brushSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = brushSize
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      _drawStroke(canvas, stroke, paint);
    }
    _drawStroke(canvas, currentStroke, paint);
  }

  void _drawStroke(Canvas canvas, List<Offset?> stroke, Paint paint) {
    for (int i = 0; i < stroke.length - 1; i++) {
      if (stroke[i] != null && stroke[i + 1] != null) {
        canvas.drawLine(stroke[i]!, stroke[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) => true;
}
