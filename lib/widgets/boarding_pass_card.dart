import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flight.dart';
import '../theme/app_theme.dart';
import 'airline_logo.dart';
import 'flight_arc_painter.dart';
import 'ticket_card.dart';

class BoardingPassCard extends StatelessWidget {
  final Flight flight;
  final String? seatNumber;
  final String? passengerName;
  final String? cabinClass;
  final String? gate;
  final String? boardingTime;
  final String? barcodeNumber;
  final List<String>? allSeats;
  final int? ticketIndex;
  final int? totalTickets;
  final VoidCallback? onSeatChipTap;

  const BoardingPassCard({
    super.key,
    required this.flight,
    this.seatNumber,
    this.passengerName,
    this.cabinClass,
    this.gate,
    this.boardingTime,
    this.barcodeNumber,
    this.allSeats,
    this.ticketIndex,
    this.totalTickets,
    this.onSeatChipTap,
  });

  @override
  Widget build(BuildContext context) {
    const double notchY = 245.0;
    const double notchRadius = 14.0;
    const double cornerRadius = 26.0;

    final String displaySeat = seatNumber ?? flight.seat;
    final String displayPassenger = passengerName ?? flight.passengerName;
    final String displayClass = cabinClass ?? flight.cabinClass;
    final String displayGate = gate ?? flight.gate;
    final String displayBoarding = boardingTime ?? flight.boardingTime;
    final String displayBarcode = barcodeNumber ?? '0942 8493 2198 0041 3829';

    final hasMultipleTickets = (totalTickets ?? 1) > 1;

    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: cornerRadius,
            cornerSmoothing: 0.6,
          ),
        ),
      ),
      child: ClipPath(
        clipper: TicketCardClipper(
          notchY: notchY,
          notchRadius: notchRadius,
          cornerRadius: cornerRadius,
        ),
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top: Airline row with ticket sequence indicator if multiple tickets
                    Row(
                      children: [
                        AirlineLogo(
                          logoType: flight.logoType,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                flight.airlineName,
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                        ),
                        const SizedBox(width: 8),
                        if (hasMultipleTickets)
                          Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: ShapeDecoration(
                              color: const Color(0xFF141416),
                              shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                  cornerRadius: 8,
                                  cornerSmoothing: 0.6,
                                ),
                              ),
                            ),
                            child: Text(
                              'Pass ${(ticketIndex ?? 0) + 1}/$totalTickets',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: ShapeDecoration(
                            color:
                                AppColors.primaryRed.withValues(alpha: 0.1),
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
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryRed,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // Route Row (JFK -> Arc -> ZHR)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Origin
                        SizedBox(
                          width: 85,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                flight.fromCode,
                                style: GoogleFonts.outfit(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                flight.fromCity,
                                style: GoogleFonts.outfit(
                                  fontSize: 12.5,
                                  color: AppColors.textDarkSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                flight.fromTime,
                                style: GoogleFonts.outfit(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Center Arc
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: [
                                Text(
                                  flight.duration,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const SizedBox(
                                  height: 20,
                                  child: CustomPaint(
                                    painter: TicketFlightArcPainter(),
                                    size: Size(double.infinity, 20),
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Destination
                        SizedBox(
                          width: 85,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                flight.toCode,
                                style: GoogleFonts.outfit(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                flight.toCity,
                                style: GoogleFonts.outfit(
                                  fontSize: 12.5,
                                  color: AppColors.textDarkSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                flight.toTime,
                                style: GoogleFonts.outfit(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Clearance space across the perforated notch divider
                    const SizedBox(height: 48),

                    // Passenger Details Grid
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: _detailItem('PASSENGER', displayPassenger),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 4,
                          child: _detailItem('DATE', flight.date,
                              crossAxisAlignment: CrossAxisAlignment.end),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Flight Attributes Grid (Gate, Seat, Class, Boarding)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _detailItem('GATE', displayGate),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: _detailItem('SEAT', displaySeat),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: _detailItem('CLASS', displayClass),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: _detailItem('BOARDING', displayBoarding,
                              crossAxisAlignment: CrossAxisAlignment.end),
                        ),
                      ],
                    ),

                    // Multi-seat badge row if user is viewing multi-ticket reservation
                    if (allSeats != null && allSeats!.length > 1) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: ShapeDecoration(
                          color: AppColors.cardTrackGray,
                          shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 12,
                              cornerSmoothing: 0.6,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    'BOOKED SEATS (${allSeats!.length})',
                                    style: GoogleFonts.outfit(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.6,
                                      color: AppColors.textDarkSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Tap seat',
                                  style: GoogleFonts.outfit(
                                    fontSize: 9.5,
                                    color: AppColors.primaryRed,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: allSeats!.asMap().entries.map((entry) {
                                final idx = entry.key;
                                final s = entry.value;
                                final isCurrent = s == displaySeat;
                                return GestureDetector(
                                  onTap: onSeatChipTap != null
                                      ? () => onSeatChipTap!()
                                      : null,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: ShapeDecoration(
                                      color: isCurrent
                                          ? AppColors.primaryRed
                                          : Colors.white,
                                      shape: SmoothRectangleBorder(
                                        borderRadius: SmoothBorderRadius(
                                          cornerRadius: 8,
                                          cornerSmoothing: 0.6,
                                        ),
                                        side: BorderSide(
                                          color: isCurrent
                                              ? AppColors.primaryRed
                                              : const Color(0xFFDCDFE6),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      '#${idx + 1} $s',
                                      style: GoogleFonts.outfit(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: isCurrent
                                            ? Colors.white
                                            : AppColors.textDark,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

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
                            height: 48,
                            child: CustomPaint(
                              painter: const _RealisticBarcodePainter(),
                              size: const Size(double.infinity, 48),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            displayBarcode,
                            style: GoogleFonts.spaceMono(
                              fontSize: 11,
                              letterSpacing: 2.2,
                              color: AppColors.textDarkSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Perforated line at notch
              Positioned(
                top: notchY,
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
    );
  }

  Widget _detailItem(
    String label,
    String value, {
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: const Color(0xFF9E9EA4),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
            letterSpacing: -0.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _RealisticBarcodePainter extends CustomPainter {
  const _RealisticBarcodePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF141416)
      ..style = PaintingStyle.fill;

    // Pattern of barcode bar widths and spacings
    const pattern = [
      3, 1, 1, 2, 4, 1, 2, 2, 1, 3, 2, 1, 4, 1, 1, 2, 3, 2, 1, 1, 4, 2, 1, 3,
      1, 2, 2, 4, 1, 1, 3, 2, 1, 4, 2, 1, 1, 3, 2, 2, 4, 1, 2, 1, 3, 1, 2, 4,
      1, 2, 1, 3, 2, 1, 4, 1, 2, 2, 3, 1, 1, 2, 4, 2, 1, 3, 1, 2, 2, 4, 1, 3
    ];

    double totalUnits = 0;
    for (int p in pattern) {
      totalUnits += p;
    }

    final double unitWidth = size.width / totalUnits;
    double currentX = 0;
    bool isBar = true;

    for (int widthInUnits in pattern) {
      final barWidth = widthInUnits * unitWidth;
      if (isBar) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(currentX, 0, barWidth, size.height),
            const Radius.circular(0.8),
          ),
          paint,
        );
      }
      currentX += barWidth;
      isBar = !isBar;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
