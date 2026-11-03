import 'package:flutter/material.dart';

class AirlineLogo extends StatelessWidget {
  final String logoType;
  final double size;

  const AirlineLogo({
    super.key,
    required this.logoType,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    switch (logoType.toLowerCase()) {
      case 'american':
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _AmericanAirlinesPainter(),
          ),
        );
      case 'delta':
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _DeltaPainter(),
          ),
        );
      case 'swiss':
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _SwissPainter(),
          ),
        );
      case 'emirates':
      default:
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _EmiratesPainter(),
          ),
        );
    }
  }
}

class _AmericanAirlinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // American Airlines flight ribbon / eagle wings
    // Blue left curve
    final bluePaint = Paint()
      ..color = const Color(0xFF0078D2)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final bluePath = Path()
      ..moveTo(w * 0.2, h * 0.75)
      ..quadraticBezierTo(w * 0.1, h * 0.25, w * 0.45, h * 0.15)
      ..quadraticBezierTo(w * 0.35, h * 0.45, w * 0.4, h * 0.7)
      ..close();
    canvas.drawPath(bluePath, bluePaint);

    // Center silver eagle beak
    final silverPaint = Paint()
      ..color = const Color(0xFFBDC3C7)
      ..style = PaintingStyle.fill;
    final centerPath = Path()
      ..moveTo(w * 0.46, h * 0.18)
      ..lineTo(w * 0.54, h * 0.18)
      ..lineTo(w * 0.50, h * 0.42)
      ..close();
    canvas.drawPath(centerPath, silverPaint);

    // Red right curve
    final redPaint = Paint()
      ..color = const Color(0xFFC8102E)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final redPath = Path()
      ..moveTo(w * 0.8, h * 0.75)
      ..quadraticBezierTo(w * 0.9, h * 0.25, w * 0.55, h * 0.15)
      ..quadraticBezierTo(w * 0.65, h * 0.45, w * 0.6, h * 0.7)
      ..close();
    canvas.drawPath(redPath, redPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DeltaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Delta iconic double red triangle
    final redPaint = Paint()
      ..color = const Color(0xFFE51937)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final darkRedPaint = Paint()
      ..color = const Color(0xFF990F23)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Left facet
    final leftPath = Path()
      ..moveTo(w * 0.5, h * 0.15)
      ..lineTo(w * 0.1, h * 0.85)
      ..lineTo(w * 0.5, h * 0.65)
      ..close();
    canvas.drawPath(leftPath, darkRedPaint);

    // Right facet
    final rightPath = Path()
      ..moveTo(w * 0.5, h * 0.15)
      ..lineTo(w * 0.9, h * 0.85)
      ..lineTo(w * 0.5, h * 0.65)
      ..close();
    canvas.drawPath(rightPath, redPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SwissPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final redPaint = Paint()
      ..color = const Color(0xFFE30613)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Rounded red shield
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.1, h * 0.1, w * 0.8, h * 0.8),
      Radius.circular(w * 0.2),
    );
    canvas.drawRRect(rrect, redPaint);

    // White swiss cross
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Horizontal arm
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.5),
          width: w * 0.52,
          height: h * 0.18,
        ),
        Radius.circular(w * 0.04),
      ),
      whitePaint,
    );

    // Vertical arm
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.5),
          width: w * 0.18,
          height: h * 0.52,
        ),
        Radius.circular(w * 0.04),
      ),
      whitePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _EmiratesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final redPaint = Paint()
      ..color = const Color(0xFFD71921)
      ..style = PaintingStyle.fill;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.05, h * 0.15, w * 0.9, h * 0.7),
      Radius.circular(w * 0.15),
    );
    canvas.drawRRect(rrect, redPaint);

    final goldPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawLine(
      Offset(w * 0.25, h * 0.5),
      Offset(w * 0.75, h * 0.5),
      goldPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

