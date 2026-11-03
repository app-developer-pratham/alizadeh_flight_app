import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flight.dart';
import '../screens/boarding_pass_screen.dart';
import '../theme/app_theme.dart';
import 'boarding_pass_card.dart';
import 'bounce_tap.dart';

class FlightDetailsSheet extends StatelessWidget {
  final Flight flight;
  final String? customSeat;
  final int? customPrice;
  final int passengerCount;
  final List<String>? selectedSeats;

  const FlightDetailsSheet({
    super.key,
    required this.flight,
    this.customSeat,
    this.customPrice,
    this.passengerCount = 1,
    this.selectedSeats,
  });

  String _formatPrice(int price) {
    return price
        .toString()
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    // Determine seats list
    final List<String> seatsList = selectedSeats ??
        (customSeat != null && customSeat!.contains(',')
            ? customSeat!.split(',').map((s) => s.trim()).toList()
            : [customSeat ?? flight.seat]);

    final int totalPrice = customPrice ?? (flight.price * passengerCount);
    final bool hasMultipleTickets = passengerCount > 1 || seatsList.length > 1;

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
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(
                        'Boarding Pass',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      if (hasMultipleTickets)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: ShapeDecoration(
                            color: AppColors.primaryRed.withValues(alpha: 0.15),
                            shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                cornerRadius: 6,
                                cornerSmoothing: 0.6,
                              ),
                            ),
                          ),
                          child: Text(
                            '${seatsList.length} Tickets',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryRed,
                            ),
                          ),
                        ),
                    ],
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
                  BoardingPassCard(
                    flight: flight,
                    seatNumber: seatsList.first,
                    allSeats: seatsList,
                    totalTickets: seatsList.length,
                    ticketIndex: 0,
                    onSeatChipTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BoardingPassScreen(
                            flight: flight,
                            selectedSeats: seatsList,
                            customPrice: totalPrice,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Confirm / Book Button (Overflow safe)
                  BounceTap(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BoardingPassScreen(
                            flight: flight,
                            selectedSeats: seatsList,
                            customPrice: totalPrice,
                            isBookingConfirmed: true,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        color: AppColors.primaryRed,
                        shadows: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                            cornerRadius: 18,
                            cornerSmoothing: 0.6,
                          ),
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.14),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_outline_rounded,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              hasMultipleTickets
                                  ? 'Book ${seatsList.length} Tickets • \$${_formatPrice(totalPrice)}'
                                  : 'Book Flight • \$${_formatPrice(totalPrice)}',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
}
