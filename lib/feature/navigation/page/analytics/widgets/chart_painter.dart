import 'dart:math' as math;

import 'package:flutter/material.dart';

class ChartPainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;
  final Color fillColor;
  final Color gridColor;
  final double animationValue;

  ChartPainter({
    required this.data,
    required this.lineColor,
    required this.fillColor,
    required this.gridColor,
    this.animationValue = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paintLine = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paintFill = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final paintGrid = Paint()
      ..color = gridColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw Grid (3 lines)
    for (int i = 1; i <= 3; i++) {
      double y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paintGrid);
    }

    final path = Path();
    final double stepX = size.width / (data.length - 1);

    // Dinamik maxY hesapla - verinin maksimum değerine göre
    final double dataMax = data.reduce(math.max);
    final double maxY = dataMax <= 0 ? 1.0 : dataMax * 1.2; // %20 padding

    // Move to first point
    // Invert Y axis because canvas 0,0 is top-left
    // value 0 -> height
    // value max -> 0

    double getX(int i) => i * stepX;
    double getY(double val) {
      // Animasyonu uygula - değeri animationValue ile çarp
      final animatedVal = val * animationValue;
      return size.height - (animatedVal / maxY) * size.height;
    }

    path.moveTo(getX(0), getY(data[0]));

    for (int i = 0; i < data.length - 1; i++) {
      double x1 = getX(i);
      double y1 = getY(data[i]);
      double x2 = getX(i + 1);
      double y2 = getY(data[i + 1]);

      // Control points for smooth curve
      double controlX1 = x1 + (x2 - x1) / 2;
      double controlY1 = y1;
      double controlX2 = x1 + (x2 - x1) / 2;
      double controlY2 = y2;

      path.cubicTo(controlX1, controlY1, controlX2, controlY2, x2, y2);
    }

    canvas.drawPath(path, paintLine);

    // Draw Fill
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paintFill);
  }

  @override
  bool shouldRepaint(covariant ChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor;
  }
}
