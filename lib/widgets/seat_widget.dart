import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

enum SeatStatus {
  available,
  unavailable,
  selected,
}

/// Custom painter to draw diagonal hatched stripes for unavailable seats
class HatchedPatternPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double spacing;

  const HatchedPatternPainter({
    this.color = const Color(0xFF555560),
    this.strokeWidth = 1.2,
    this.spacing = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double total = size.width + size.height;
    for (double i = -size.height; i <= total; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant HatchedPatternPainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      spacing != oldDelegate.spacing;
}

/// Individual Seat Widget
class SeatWidget extends StatelessWidget {
  final String seatId;
  final SeatStatus status;
  final VoidCallback? onTap;
  final double size;

  const SeatWidget({
    super.key,
    required this.seatId,
    required this.status,
    this.onTap,
    this.size = 38.0,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUnavailable = status == SeatStatus.unavailable;
    final bool isSelected = status == SeatStatus.selected;

    return GestureDetector(
      onTap: isUnavailable ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        width: size,
        height: size,
        decoration: ShapeDecoration(
          color: isSelected
              ? AppColors.primaryRed
              : isUnavailable
                  ? const Color(0xFF18181C)
                  : const Color(0xFF111114),
          shadows: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 10,
              cornerSmoothing: 0.6,
            ),
            side: isSelected
                ? BorderSide(
                    color: Colors.white.withValues(alpha: 0.16),
                    width: 1.0,
                  )
                : isUnavailable
                    ? const BorderSide(color: Color(0xFF282830), width: 1.0)
                    : const BorderSide(color: Color(0xFF282830), width: 1.2),
          ),
        ),
        child: ClipSmoothRect(
          radius: SmoothBorderRadius(
            cornerRadius: 10,
            cornerSmoothing: 0.6,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isUnavailable)
                Positioned.fill(
                  child: CustomPaint(
                    painter: const HatchedPatternPainter(
                      color: Color(0xFF4C4C56),
                      strokeWidth: 1.1,
                      spacing: 4.8,
                    ),
                  ),
                ),
              if (isSelected)
                const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Legend showing Unavailable, Available, and Selected states
class SeatMapLegend extends StatelessWidget {
  const SeatMapLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildLegendItem(
              status: SeatStatus.unavailable,
              label: 'Unavailable',
            ),
          ),
          Expanded(
            child: _buildLegendItem(
              status: SeatStatus.available,
              label: 'Available',
            ),
          ),
          Expanded(
            child: _buildLegendItem(
              status: SeatStatus.selected,
              label: 'Selected',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required SeatStatus status,
    required String label,
  }) {
    final bool isUnavailable = status == SeatStatus.unavailable;
    final bool isSelected = status == SeatStatus.selected;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: ShapeDecoration(
            color: isSelected
                ? AppColors.primaryRed
                : isUnavailable
                    ? const Color(0xFF18181C)
                    : const Color(0xFF111114),
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 6,
                cornerSmoothing: 0.6,
              ),
              side: isSelected
                  ? BorderSide.none
                  : const BorderSide(color: Color(0xFF33333A), width: 1.0),
            ),
          ),
          child: ClipSmoothRect(
            radius: SmoothBorderRadius(
              cornerRadius: 6,
              cornerSmoothing: 0.6,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isUnavailable)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: const HatchedPatternPainter(
                        color: Color(0xFF555562),
                        strokeWidth: 1.0,
                        spacing: 4.0,
                      ),
                    ),
                  ),
                if (isSelected)
                  const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFC0C0C8),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
