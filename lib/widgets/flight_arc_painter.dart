import 'package:flutter/material.dart';

class HeaderFlightArcPainter extends CustomPainter {
  final Color lineColor;
  final Color iconColor;

  const HeaderFlightArcPainter({
    this.lineColor = const Color(0xFF6B181E),
    this.iconColor = const Color(0xFFE52828),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Curved arc bowing upwards over the duration text
    final path = Path();
    path.moveTo(0, h * 0.9);
    path.quadraticBezierTo(w * 0.5, 0, w, h * 0.9);

    // Subtle outer glow
    final glowPaint = Paint()
      ..color = iconColor.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawPath(path, glowPaint);

    // Main curved line
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);

    // Center apex diamond
    final center = Offset(w * 0.5, 0);
    final diamondPaint = Paint()
      ..color = iconColor
      ..style = PaintingStyle.fill;

    final diamondPath = Path()
      ..moveTo(center.dx, center.dy - 5.5)
      ..lineTo(center.dx + 4.5, center.dy)
      ..lineTo(center.dx, center.dy + 5.5)
      ..lineTo(center.dx - 4.5, center.dy)
      ..close();
    canvas.drawPath(diamondPath, diamondPaint);

    // Tiny center white dot
    final dotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, 1.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant HeaderFlightArcPainter oldDelegate) => false;
}

class TicketFlightArcPainter extends CustomPainter {
  final Color lineColor;
  final Color iconColor;

  const TicketFlightArcPainter({
    this.lineColor = const Color(0xFFE2E4EA),
    this.iconColor = const Color(0xFFE52828),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path();
    path.moveTo(0, h * 0.7);
    path.quadraticBezierTo(w * 0.5, h * 0.15, w, h * 0.7);

    // Curved dashed or soft line
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);

    // Small red airplane symbol at top apex
    final center = Offset(w * 0.5, h * 0.29);

    final iconPaint = Paint()
      ..color = iconColor
      ..style = PaintingStyle.fill;

    // Mini airplane silhouette pointing right
    final planePath = Path();
    planePath.moveTo(center.dx + 6, center.dy);
    planePath.lineTo(center.dx - 2, center.dy - 5);
    planePath.lineTo(center.dx - 1, center.dy - 1.5);
    planePath.lineTo(center.dx - 5, center.dy - 1.5);
    planePath.lineTo(center.dx - 6, center.dy - 3.5);
    planePath.lineTo(center.dx - 7, center.dy - 3.5);
    planePath.lineTo(center.dx - 6, center.dy);
    planePath.lineTo(center.dx - 7, center.dy + 3.5);
    planePath.lineTo(center.dx - 6, center.dy + 3.5);
    planePath.lineTo(center.dx - 5, center.dy + 1.5);
    planePath.lineTo(center.dx - 1, center.dy + 1.5);
    planePath.lineTo(center.dx - 2, center.dy + 5);
    planePath.close();

    canvas.drawPath(planePath, iconPaint);
  }

  @override
  bool shouldRepaint(covariant TicketFlightArcPainter oldDelegate) => false;
}
