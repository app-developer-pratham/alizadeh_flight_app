import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flight.dart';
import '../theme/app_theme.dart';
import '../widgets/boarding_pass_card.dart';
import '../widgets/bounce_tap.dart';

class BoardingPassScreen extends StatefulWidget {
  final Flight? flight;
  final List<String>? selectedSeats;
  final List<String>? passengerNames;
  final int? customPrice;
  final bool isBookingConfirmed;

  const BoardingPassScreen({
    super.key,
    this.flight,
    this.selectedSeats,
    this.passengerNames,
    this.customPrice,
    this.isBookingConfirmed = false,
  });

  @override
  State<BoardingPassScreen> createState() => _BoardingPassScreenState();
}

class _BoardingPassScreenState extends State<BoardingPassScreen> {
  late final Flight _flight;
  late final List<String> _seats;
  late final List<String> _passengers;
  late final PageController _pageController;
  int _currentTicketIndex = 0;
  bool _isConfirmed = false;

  @override
  void initState() {
    super.initState();
    _flight = widget.flight ?? Flight.sampleFlights.first;

    // Support default 1 seat or passed multi-seat list (e.g., up to 10 seats!)
    _seats = widget.selectedSeats != null && widget.selectedSeats!.isNotEmpty
        ? widget.selectedSeats!
        : [_flight.seat];

    // Generate passenger names for all tickets if not supplied
    if (widget.passengerNames != null &&
        widget.passengerNames!.length >= _seats.length) {
      _passengers = widget.passengerNames!;
    } else {
      _passengers = List.generate(_seats.length, (index) {
        if (index == 0) return _flight.passengerName;
        return 'Passenger ${index + 1}';
      });
    }

    _pageController = PageController();
    _isConfirmed = widget.isBookingConfirmed;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int get _totalPrice {
    if (widget.customPrice != null) return widget.customPrice!;
    return _flight.price * _seats.length;
  }

  String _formatCurrency(int amount) {
    return amount
        .toString()
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }

  void _onTicketSwiped(int index) {
    setState(() {
      _currentTicketIndex = index;
    });
  }

  void _confirmBooking() {
    setState(() {
      _isConfirmed = true;
    });
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
            Expanded(
              child: Text(
                _seats.length > 1
                    ? 'Confirmed ${_seats.length} Tickets for ${_flight.fromCity} ➔ ${_flight.toCity}!'
                    : 'Ticket Confirmed for ${_passengers[0]}!',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveToAppleWallet() {
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
            const Icon(Icons.wallet_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _seats.length > 1
                    ? '${_seats.length} Boarding Passes saved to Apple Wallet'
                    : 'Boarding Pass saved to Apple Wallet',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasMultipleTickets = _seats.length > 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background ambient gradient glow
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 400,
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.3),
                  radius: 0.95,
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

          SafeArea(
            child: Column(
              children: [
                // Top App Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: ShapeDecoration(
                            color: AppColors.surfaceDark,
                            shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                cornerRadius: 14,
                                cornerSmoothing: 0.6,
                              ),
                              side: const BorderSide(
                                color: AppColors.surfaceDarkBorder,
                                width: 1,
                              ),
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),

                      // Title
                      Text(
                        'Boarding Pass',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),

                      // Right Action: Share or Close
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Boarding pass link copied!',
                                  style: GoogleFonts.outfit()),
                              backgroundColor: AppColors.surfaceDark,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: ShapeDecoration(
                            color: AppColors.surfaceDark,
                            shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                cornerRadius: 14,
                                cornerSmoothing: 0.6,
                              ),
                              side: const BorderSide(
                                color: AppColors.surfaceDarkBorder,
                                width: 1,
                              ),
                            ),
                          ),
                          child: const Icon(
                            Icons.ios_share_rounded,
                            color: Colors.white70,
                            size: 19,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Multi-Ticket Selector Bar (Shows when user books > 1 ticket, up to 10!)
                if (hasMultipleTickets) ...[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'TICKETS (${_seats.length} BOOKED)',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: AppColors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
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
                            'Pass ${_currentTicketIndex + 1} of ${_seats.length}',
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

                  // Horizontal scrollable ticket tabs
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: _seats.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final isSelected = index == _currentTicketIndex;
                        return GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 280),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: ShapeDecoration(
                              color: isSelected
                                  ? AppColors.primaryRed
                                  : AppColors.surfaceDark,
                              shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                  cornerRadius: 12,
                                  cornerSmoothing: 0.6,
                                ),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primaryRed
                                      : AppColors.surfaceDarkBorder,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.airplane_ticket_outlined,
                                  size: 14,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white60,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '#${index + 1} (${_seats[index]})',
                                  style: GoogleFonts.outfit(
                                    fontSize: 11.5,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // Main Scrollable Area with Boarding Pass Card
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                    child: Column(
                      children: [
                        if (hasMultipleTickets) ...[
                          // Multi-Ticket PageView Carousel
                          SizedBox(
                            height: 690,
                            child: PageView.builder(
                              controller: _pageController,
                              onPageChanged: _onTicketSwiped,
                              itemCount: _seats.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: BoardingPassCard(
                                    flight: _flight,
                                    seatNumber: _seats[index],
                                    passengerName: _passengers[index],
                                    ticketIndex: index,
                                    totalTickets: _seats.length,
                                    allSeats: _seats,
                                    barcodeNumber:
                                        '0942 8493 2198 0041 ${3800 + index}',
                                  ),
                                );
                              },
                            ),
                          ),
                        ] else ...[
                          // Single Ticket Pass Card
                          BoardingPassCard(
                            flight: _flight,
                            seatNumber: _seats.first,
                            passengerName: _passengers.first,
                            ticketIndex: 0,
                            totalTickets: 1,
                            allSeats: _seats,
                          ),
                        ],

                        const SizedBox(height: 18),

                        // Flight Status Information Widget
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: ShapeDecoration(
                            color: AppColors.surfaceDark,
                            shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                cornerRadius: 18,
                                cornerSmoothing: 0.6,
                              ),
                              side: const BorderSide(
                                color: AppColors.surfaceDarkBorder,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: ShapeDecoration(
                                  color: Colors.green.withValues(alpha: 0.15),
                                  shape: SmoothRectangleBorder(
                                    borderRadius: SmoothBorderRadius(
                                      cornerRadius: 12,
                                      cornerSmoothing: 0.6,
                                    ),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.green,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Flight on Schedule',
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Terminal ${_flight.fromTerminal} • Gate ${_flight.gate} • Boarding ${_flight.boardingTime}',
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        color: AppColors.textMuted,
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

                        const SizedBox(height: 18),

                        // Primary Action Button (Overflow safe for 1 to 10+ tickets!)
                        BounceTap(
                          onTap: _isConfirmed
                              ? _saveToAppleWallet
                              : _confirmBooking,
                          child: Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.center,
                            decoration: ShapeDecoration(
                              color: AppColors.primaryRed,
                              shadows: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.32),
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
                                Icon(
                                  _isConfirmed
                                      ? Icons.wallet_rounded
                                      : Icons.check_circle_outline_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    _isConfirmed
                                        ? (hasMultipleTickets
                                            ? 'Save ${_seats.length} Passes to Apple Wallet'
                                            : 'Save to Apple Wallet')
                                        : (hasMultipleTickets
                                            ? 'Book ${_seats.length} Tickets • \$${_formatCurrency(_totalPrice)}'
                                            : 'Book Flight • \$${_formatCurrency(_totalPrice)}'),
                                    style: GoogleFonts.outfit(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: -0.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Secondary actions row
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: _saveToAppleWallet,
                                child: Container(
                                  height: 48,
                                  alignment: Alignment.center,
                                  decoration: ShapeDecoration(
                                    color: AppColors.surfaceDark,
                                    shape: SmoothRectangleBorder(
                                      borderRadius: SmoothBorderRadius(
                                        cornerRadius: 14,
                                        cornerSmoothing: 0.6,
                                      ),
                                      side: const BorderSide(
                                        color: AppColors.surfaceDarkBorder,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.wallet_rounded,
                                          color: Colors.white, size: 18),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'Apple Wallet',
                                          style: GoogleFonts.outfit(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
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
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('PDF downloaded!',
                                          style: GoogleFonts.outfit()),
                                      backgroundColor: AppColors.surfaceDark,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 48,
                                  alignment: Alignment.center,
                                  decoration: ShapeDecoration(
                                    color: AppColors.surfaceDark,
                                    shape: SmoothRectangleBorder(
                                      borderRadius: SmoothBorderRadius(
                                        cornerRadius: 14,
                                        cornerSmoothing: 0.6,
                                      ),
                                      side: const BorderSide(
                                        color: AppColors.surfaceDarkBorder,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.download_rounded,
                                          color: Colors.white, size: 18),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'Download PDF',
                                          style: GoogleFonts.outfit(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
