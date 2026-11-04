import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flight.dart';
import '../theme/app_theme.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/flight_details_sheet.dart';
import '../widgets/seat_bottom_sheet.dart';
import '../widgets/seat_widget.dart';
import '../widgets/ticket_card.dart';
import 'boarding_pass_screen.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Flight flight;

  const SeatSelectionScreen({
    super.key,
    required this.flight,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  // Matching reference Figma design: 1E and 1F pre-selected
  final Set<String> _selectedSeats = {'1E', '1F'};

  // Matching reference Figma layout of unavailable seats
  final Set<String> _unavailableSeats = {
    '1B',
    '2B',
    '2C',
    '3A',
    '3D',
    '3E',
    '4C',
    '4E',
    '4F',
    '5E',
    '6A',
    '6B',
    '7D',
    '8B',
    '8F',
  };

  final int _rowCount = 8;
  final List<String> _leftColumns = ['A', 'B', 'C'];
  final List<String> _rightColumns = ['D', 'E', 'F'];

  void _onSeatTap(String seatId) {
    if (_unavailableSeats.contains(seatId)) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Seat $seatId is unavailable', style: GoogleFonts.outfit()),
          backgroundColor: AppColors.surfaceDark,
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      if (_selectedSeats.contains(seatId)) {
        _selectedSeats.remove(seatId);
      } else {
        _selectedSeats.add(seatId);
      }
    });
  }

  void _openPaymentAndBoardingPass() {
    if (_selectedSeats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one seat', style: GoogleFonts.outfit()),
          backgroundColor: AppColors.primaryRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final sortedSeats = _selectedSeats.toList()..sort();
    final totalPrice = widget.flight.price * _selectedSeats.length;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FlightDetailsSheet(
        flight: widget.flight,
        customSeat: sortedSeats.join(', '),
        customPrice: totalPrice,
        passengerCount: _selectedSeats.length,
        selectedSeats: sortedSeats,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedSeats = _selectedSeats.toList()..sort();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ambient Red Glow at Top (consistent with FlightBookingScreen)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 380,
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.2),
                  radius: 0.9,
                  colors: [
                    Color(0xFF280B10),
                    Color(0xFF140608),
                    AppColors.background,
                  ],
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),

          // Main Content Area with Pinned Top Bar
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Pinned Top App Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppBackButton(),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Choose your seats',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final sorted = _selectedSeats.toList()..sort();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BoardingPassScreen(
                                flight: widget.flight,
                                selectedSeats: sorted.isNotEmpty ? sorted : [widget.flight.seat],
                              ),
                            ),
                          );
                        },
                        child: const AppProfileAvatar(),
                      ),
                    ],
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Selected Flight Ticket Card (reused component with Hero transition)
                        Hero(
                          tag: 'flight_ticket_${widget.flight.id}',
                          child: Material(
                            type: MaterialType.transparency,
                            child: TicketCard(
                              flight: widget.flight,
                              unitText: '/pax',
                            ),
                          ),
                        ),

                        // Seat Map Legend (Unavailable, Available, Selected)
                        const SeatMapLegend(),

                        const SizedBox(height: 6),

                        // Seat Map Grid
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildSeatGrid(),
                        ),

                        // Padding to scroll cleanly above the bottom sheet
                        const SizedBox(height: 230),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Summary Checkout Sheet (pinned to screen bottom)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SeatBottomSummarySheet(
              cabinClass: widget.flight.cabinClass,
              passengerCount: _selectedSeats.isEmpty ? 1 : _selectedSeats.length,
              selectedSeats: sortedSeats,
              basePrice: widget.flight.price,
              onPaymentTap: _openPaymentAndBoardingPass,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatGrid() {
    return Column(
      children: [
        // Column Letters Header: A B C   [aisle]   D E F
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              // Left columns: A, B, C
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _leftColumns.map((col) => _buildColumnHeader(col)).toList(),
                ),
              ),

              // Aisle space matching row number width
              const SizedBox(width: 36),

              // Right columns: D, E, F
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _rightColumns.map((col) => _buildColumnHeader(col)).toList(),
                ),
              ),
            ],
          ),
        ),

        // Seat Rows: 1 to 8
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _rowCount,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final int rowNum = index + 1;
            return Row(
              children: [
                // Left 3 seats (A, B, C)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _leftColumns.map((col) {
                      final seatId = '$rowNum$col';
                      return SeatWidget(
                        seatId: seatId,
                        size: 40.0,
                        status: _getSeatStatus(seatId),
                        onTap: () => _onSeatTap(seatId),
                      );
                    }).toList(),
                  ),
                ),

                // Center Aisle Row Number
                SizedBox(
                  width: 36,
                  child: Center(
                    child: Text(
                      '$rowNum',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF8E8E93),
                      ),
                    ),
                  ),
                ),

                // Right 3 seats (D, E, F)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _rightColumns.map((col) {
                      final seatId = '$rowNum$col';
                      return SeatWidget(
                        seatId: seatId,
                        size: 40.0,
                        status: _getSeatStatus(seatId),
                        onTap: () => _onSeatTap(seatId),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildColumnHeader(String letter) {
    return SizedBox(
      width: 40,
      child: Center(
        child: Text(
          letter,
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  SeatStatus _getSeatStatus(String seatId) {
    if (_selectedSeats.contains(seatId)) {
      return SeatStatus.selected;
    }
    if (_unavailableSeats.contains(seatId)) {
      return SeatStatus.unavailable;
    }
    return SeatStatus.available;
  }
}
