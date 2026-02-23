import 'package:flutter/material.dart';

class TextOverlay {
  String text;
  Color color;
  Offset position;

  TextOverlay({
    required this.text,
    required this.color,
    required this.position,
  });
}

class DrawingPoint {
  Offset? offset;
  Paint? paint;

  DrawingPoint({this.offset, this.paint});
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].offset != null && points[i + 1].offset != null) {
        canvas.drawLine(
          points[i].offset!,
          points[i + 1].offset!,
          points[i].paint!,
        );
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
