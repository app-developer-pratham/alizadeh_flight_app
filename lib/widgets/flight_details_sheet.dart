import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flight.dart';
import '../theme/app_theme.dart';
import 'airline_logo.dart';
import 'flight_arc_painter.dart';
import 'ticket_card.dart';

class FlightDetailsSheet extends StatelessWidget {
  final Flight flight;

  const FlightDetailsSheet({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: AppColors.backgroundSecondary,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.only(
            topLeft: SmoothRadius(cornerRadius: 32, cornerSmoothing: 0.6),
            topRight: SmoothRadius(cornerRadius: 32, cornerSmoothing: 0.6),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 38,
              height: 4,
              decoration: ShapeDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 2,
                    cornerSmoothing: 0.6,
                  ),
                ),
              ),
            ),
          ),

          // Header title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Boarding Pass',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: ShapeDecoration(
                      color: AppColors.surfaceDark,
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 12,
                          cornerSmoothing: 0.6,
                        ),
                      ),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white70,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                children: [
                  // Full Boarding Pass Card
                  Container(
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 26,
                          cornerSmoothing: 0.6,
                        ),
                      ),
                    ),
                    child: ClipPath(
                      clipper: TicketCardClipper(
                        notchY: 260.0,
                        notchRadius: 14.0,
                        cornerRadius: 26,
                      ),
                      child: Container(
                        color: Colors.white,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(22),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Airline & Airplane
                                  Row(
                                    children: [
                                      AirlineLogo(
                                        logoType: flight.logoType,
                                        size: 32,
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            flight.airlineName,
                                            style: GoogleFonts.outfit(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                          Text(
                                            'Flight ${flight.flightNumber}',
                                            style: GoogleFonts.outfit(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.textDarkSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: ShapeDecoration(
                                          color: AppColors.primaryRed
                                              .withValues(alpha: 0.1),
                                          shape: SmoothRectangleBorder(
                                            borderRadius: SmoothBorderRadius(
                                              cornerRadius: 10,
                                              cornerSmoothing: 0.6,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          flight.aircraft,
                                          style: GoogleFonts.outfit(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.primaryRed,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),

                                  // Route row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            flight.fromCode,
                                            style: GoogleFonts.outfit(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                          Text(
                                            flight.fromCity,
                                            style: GoogleFonts.outfit(
                                              fontSize: 13,
                                              color: AppColors.textDarkSecondary,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            flight.fromTime,
                                            style: GoogleFonts.outfit(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
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
                                              const SizedBox(height: 6),
                                              const SizedBox(
                                                height: 20,
                                                child: CustomPaint(
                                                  painter:
                                                      TicketFlightArcPainter(),
                                                  size: Size(
                                                      double.infinity, 20),
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                flight.stopsInfo,
                                                style: GoogleFonts.outfit(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.primaryRed,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            flight.toCode,
                                            style: GoogleFonts.outfit(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                          Text(
                                            flight.toCity,
                                            style: GoogleFonts.outfit(
                                              fontSize: 13,
                                              color: AppColors.textDarkSecondary,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            flight.toTime,
                                            style: GoogleFonts.outfit(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 52), // Space for notch

                                  // Passenger details grid
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _detailItem('Passenger', flight.passengerName),
                                      _detailItem('Date', flight.date),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _detailItem('Gate', flight.gate),
                                      _detailItem('Seat', flight.seat),
                                      _detailItem('Class', flight.cabinClass),
                                      _detailItem('Boarding', flight.boardingTime),
                                    ],
                                  ),
                                  const SizedBox(height: 24),

                                  // Realistic Barcode
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    decoration: ShapeDecoration(
                                      color: AppColors.cardTrackGray,
                                      shape: SmoothRectangleBorder(
                                        borderRadius: SmoothBorderRadius(
                                          cornerRadius: 14,
                                          cornerSmoothing: 0.6,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          child: CustomPaint(
                                            painter: _BarcodePainter(),
                                            size: const Size(double.infinity, 50),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '0942 8493 2198 0041 3829',
                                          style: GoogleFonts.spaceMono(
                                            fontSize: 11,
                                            letterSpacing: 2.0,
                                            color: AppColors.textDarkSecondary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Perforated line at notch
                            Positioned(
                              top: 260.0,
                              left: 18,
                              right: 18,
                              child: const CustomPaint(
                                painter: DashedLinePainter(
                                  color: Color(0xFFDCDFE6),
                                  dashWidth: 5,
                                  dashSpace: 5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Confirm / Book Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.surfaceDark,
                          behavior: SnackBarBehavior.floating,
                          shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 14,
                              cornerSmoothing: 0.6,
                            ),
                          ),
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle_rounded,
                                  color: AppColors.primaryRed),
                              const SizedBox(width: 10),
                              Text(
                                'Ticket Confirmed for ${flight.passengerName}!',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 56,
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        color: AppColors.primaryRed,
                        shadows: [
                          BoxShadow(
                            color: AppColors.primaryRed.withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                            cornerRadius: 18,
                            cornerSmoothing: 0.6,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_outline_rounded,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'Book Flight • \$${flight.price}',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: const Color(0xFF9E9EA4),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

class _BarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF141416)
      ..style = PaintingStyle.fill;

    const pattern = [
      3, 1, 2, 4, 1, 3, 2, 1, 4, 2, 1, 3, 1, 2, 3, 4, 1, 2, 1, 4,
      3, 2, 1, 1, 3, 2, 4, 1, 2, 3, 1, 4, 2, 1, 3, 2, 1, 4, 1, 3,
      2, 4, 1, 2, 3, 1, 2, 4, 1, 3, 2, 1, 4, 2, 1, 3, 1, 2, 4, 2
    ];

    double currentX = 10.0;
    final totalWidth = size.width - 20;
    final unitWidth = totalWidth / 140;

    for (int i = 0; i < pattern.length; i++) {
      final width = pattern[i] * unitWidth;
      if (i % 2 == 0) {
        canvas.drawRect(
          Rect.fromLTWH(currentX, 0, width, size.height),
          paint,
        );
      }
      currentX += width;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

