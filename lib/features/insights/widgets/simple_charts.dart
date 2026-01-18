import 'dart:math';

import 'package:flutter/material.dart';

class SimpleLineChart extends StatelessWidget {
  final List<double> values;
  final Color color;
  final double height;
  final double strokeWidth;

  const SimpleLineChart({
    super.key,
    required this.values,
    required this.color,
    this.height = 120,
    this.strokeWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _LinePainter(values: values, color: color, strokeWidth: strokeWidth),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<double> values;
  final Color color;
  final double strokeWidth;

  _LinePainter({required this.values, required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final minV = values.reduce(min);
    final maxV = values.reduce(max);
    final range = (maxV - minV).abs() < 1e-9 ? 1.0 : (maxV - minV);

    final padding = 6.0;
    final w = size.width - padding * 2;
    final h = size.height - padding * 2;

    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final t = values.length == 1 ? 0.0 : i / (values.length - 1);
      final x = padding + w * t;
      final y = padding + h * (1 - ((values[i] - minV) / range));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Subtle area fill
    final fillPath = Path.from(path)
      ..lineTo(padding + w, padding + h)
      ..lineTo(padding, padding + h)
      ..close();

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withOpacity(0.12);

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white.withOpacity(0.06)
      ..strokeWidth = 1;

    // grid lines
    for (var i = 1; i <= 3; i++) {
      final y = padding + h * (i / 4);
      canvas.drawLine(Offset(padding, y), Offset(padding + w, y), gridPaint);
    }

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    // last point
    final lastIdx = values.length - 1;
    final t = values.length == 1 ? 0.0 : lastIdx / (values.length - 1);
    final x = padding + w * t;
    final y = padding + h * (1 - ((values[lastIdx] - minV) / range));

    final dotPaint = Paint()..color = color;
    canvas.drawCircle(Offset(x, y), 4.2, dotPaint);
    canvas.drawCircle(Offset(x, y), 8.2, dotPaint..color = color.withOpacity(0.16));
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}

class SimpleBarChart extends StatelessWidget {
  final List<double> values;
  final Color color;
  final double height;

  const SimpleBarChart({
    super.key,
    required this.values,
    required this.color,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _BarPainter(values: values, color: color),
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  final List<double> values;
  final Color color;

  _BarPainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final maxV = values.reduce(max);
    final scale = maxV <= 0 ? 1.0 : maxV;

    final padding = 6.0;
    final w = size.width - padding * 2;
    final h = size.height - padding * 2;

    final barCount = values.length;
    final gap = 6.0;
    final barWidth = (w - gap * (barCount - 1)) / barCount;

    final paint = Paint()..color = color;
    final bgPaint = Paint()..color = color.withOpacity(0.12);

    for (var i = 0; i < barCount; i++) {
      final x = padding + i * (barWidth + gap);
      final barH = (values[i] / scale).clamp(0.0, 1.0) * h;
      final r = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, padding + (h - barH), barWidth, barH),
        const Radius.circular(6),
      );
      final bg = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, padding, barWidth, h),
        const Radius.circular(6),
      );
      canvas.drawRRect(bg, bgPaint);
      canvas.drawRRect(r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BarPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color;
  }
}
