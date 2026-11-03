import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flight.dart';
import '../theme/app_theme.dart';
import 'airline_logo.dart';
import 'flight_arc_painter.dart';

class TicketCard extends StatelessWidget {
  final Flight flight;
  final VoidCallback? onTap;
  final String unitText;

  const TicketCard({
    super.key,
    required this.flight,
    this.onTap,
    this.unitText = '/person',
  });

  @override
  Widget build(BuildContext context) {
    const double notchY = 170.0;
    const double notchRadius = 11.0;

    final card = Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: ShapeDecoration(
          shadows: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 22,
              cornerSmoothing: 0.6,
            ),
          ),
        ),
        child: ClipPath(
          clipper: TicketCardClipper(
            notchY: notchY,
            notchRadius: notchRadius,
            cornerRadius: 22,
          ),
          child: Container(
            color: Colors.white,
            child: Stack(
              children: [
                // Main Content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // TOP SECTION
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
                      child: Column(
                        children: [
                          // Airline Header Row
                          Row(
                            children: [
                              AirlineLogo(
                                logoType: flight.logoType,
                                size: 26,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  flight.airlineName,
                                  style: GoogleFonts.outfit(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark,
                                    letterSpacing: -0.2,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Airplane',
                                    style: GoogleFonts.outfit(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF9E9EA4),
                                    ),
                                  ),
                                  Text(
                                    flight.aircraft,
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primaryRed,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Route row (JFK --- arc --- ZHR)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Origin
                              SizedBox(
                                width: 70,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      flight.fromCode,
                                      style: GoogleFonts.outfit(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textDark,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    Text(
                                      flight.fromCity,
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textDarkSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Arc and Duration
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    children: [
                                      Text(
                                        flight.duration,
                                        style: GoogleFonts.outfit(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const SizedBox(
                                        height: 18,
                                        child: CustomPaint(
                                          painter: TicketFlightArcPainter(),
                                          size: Size(double.infinity, 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Destination
                              SizedBox(
                                width: 70,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      flight.toCode,
                                      style: GoogleFonts.outfit(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textDark,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    Text(
                                      flight.toCity,
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.textDarkSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Times track bar with stops pill
                          Container(
                            height: 32,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: ShapeDecoration(
                              color: AppColors.cardTrackGray,
                              shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                  cornerRadius: 16,
                                  cornerSmoothing: 0.6,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    flight.fromTime,
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF636366),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: ShapeDecoration(
                                    color: AppColors.cardPillDark,
                                    shape: SmoothRectangleBorder(
                                      borderRadius: SmoothBorderRadius(
                                        cornerRadius: 10,
                                        cornerSmoothing: 0.6,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    flight.stopsInfo,
                                    style: GoogleFonts.outfit(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: -0.1,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    flight.toTime,
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF636366),
                                    ),
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Divider Space for Notch
                    const SizedBox(height: 20),

                    // BOTTOM SECTION
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                      child: Row(
                        children: [
                          // Cabin class and date
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: ShapeDecoration(
                                    color: AppColors.primaryRed.withValues(alpha: 0.12),
                                    shape: SmoothRectangleBorder(
                                      borderRadius: SmoothBorderRadius(
                                        cornerRadius: 8,
                                        cornerSmoothing: 0.6,
                                      ),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.airline_seat_recline_extra_rounded,
                                    size: 15,
                                    color: AppColors.primaryRed,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    flight.cabinClass,
                                    style: GoogleFonts.outfit(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textDark,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: Text(
                                    '•',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    flight.date,
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textDarkSecondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Price
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '\$${flight.price}',
                                style: GoogleFonts.outfit(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                unitText,
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF8E8E93),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Perforated Dashed Line between notches
                Positioned(
                  top: notchY,
                  left: notchRadius + 4,
                  right: notchRadius + 4,
                  child: const CustomPaint(
                    painter: DashedLinePainter(
                      color: Color(0xFFE0E2E8),
                      dashWidth: 4,
                      dashSpace: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }
    return card;
  }
}

class TicketCardClipper extends CustomClipper<Path> {
  final double notchY;
  final double notchRadius;
  final double cornerRadius;

  TicketCardClipper({
    required this.notchY,
    required this.notchRadius,
    required this.cornerRadius,
  });

  @override
  Path getClip(Size size) {
    final rect = Offset.zero & size;
    final outerPath = SmoothBorderRadius(
      cornerRadius: cornerRadius,
      cornerSmoothing: 0.6,
    ).toPath(rect);

    // Left circular bite-out
    final leftNotch = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(0, notchY),
          radius: notchRadius,
        ),
      );

    // Right circular bite-out
    final rightNotch = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width, notchY),
          radius: notchRadius,
        ),
      );

    final notches = Path.combine(PathOperation.union, leftNotch, rightNotch);
    return Path.combine(PathOperation.difference, outerPath, notches);
  }

  @override
  bool shouldReclip(covariant TicketCardClipper oldClipper) =>
      oldClipper.notchY != notchY ||
      oldClipper.notchRadius != notchRadius ||
      oldClipper.cornerRadius != cornerRadius;
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  const DashedLinePainter({
    required this.color,
    this.dashWidth = 4,
    this.dashSpace = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant DashedLinePainter oldDelegate) => false;
}
