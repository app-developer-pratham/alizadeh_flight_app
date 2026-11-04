import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flight.dart';
import '../theme/app_theme.dart';
import '../widgets/bounce_tap.dart';
import 'boarding_pass_screen.dart';

class MyTicketsScreen extends StatefulWidget {
  final ValueChanged<int>? onSwitchTab;

  const MyTicketsScreen({super.key, this.onSwitchTab});

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  int _selectedTab = 0; // 0: Upcoming, 1: Past, 2: Saved

  final List<Flight> _upcomingFlights = [
    Flight.sampleFlights[0], // AA-2849 JFK -> ZHR
    Flight.sampleFlights[1], // DL-1940 JFK -> ZHR
  ];

  final List<Map<String, dynamic>> _pastFlights = const [
    {
      'airline': 'SWISS International',
      'flight': 'LX-401',
      'from': 'ZHR',
      'to': 'JFK',
      'date': 'Aug 14, 2024',
      'seat': '01A',
      'price': '\$820',
      'class': 'First class',
    },
    {
      'airline': 'Emirates',
      'flight': 'EK-202',
      'from': 'DXB',
      'to': 'JFK',
      'date': 'Jun 02, 2024',
      'seat': '07K',
      'price': '\$910',
      'class': 'Business class',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background ambient gradient glow
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

          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryRed,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'DIGITAL WALLET',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.4,
                                color: AppColors.primaryRed,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'My Boarding Passes',
                          style: GoogleFonts.outfit(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage electronic passes, gate alerts and baggage tracking',
                          style: GoogleFonts.outfit(
                            fontSize: 13.5,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Sub-tabs (Upcoming, Past, Saved)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.all(3.5),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF141318),
                        shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                            cornerRadius: 16,
                            cornerSmoothing: 0.6,
                          ),
                          side: const BorderSide(
                              color: Color(0xFF26252E), width: 1.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildSubTab(0, 'Upcoming (2)'),
                          _buildSubTab(1, 'Past Trips (2)'),
                          _buildSubTab(2, 'Saved (0)'),
                        ],
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                // Tickets list according to tab
                if (_selectedTab == 0) ...[
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final flight = _upcomingFlights[index];
                          return _buildUpcomingTicketCard(flight, index == 0);
                        },
                        childCount: _upcomingFlights.length,
                      ),
                    ),
                  ),
                ] else if (_selectedTab == 1) ...[
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final past = _pastFlights[index];
                          return _buildPastTicketCard(past);
                        },
                        childCount: _pastFlights.length,
                      ),
                    ),
                  ),
                ] else ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 60),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: ShapeDecoration(
                              color: const Color(0xFF191820),
                              shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                  cornerRadius: 20,
                                  cornerSmoothing: 0.6,
                                ),
                              ),
                            ),
                            child: const Icon(Icons.bookmark_border_rounded,
                                color: Colors.white38, size: 30),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Saved Routes Yet',
                            style: GoogleFonts.outfit(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Bookmark dream destinations from Explore to keep an eye on fare drops.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SliverToBoxAdapter(child: SizedBox(height: 110)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTab(int index, String title) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: BounceTap(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: isSelected
              ? ShapeDecoration(
                  color: AppColors.primaryRed,
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.28),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                      cornerRadius: 13,
                      cornerSmoothing: 0.6,
                    ),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.12),
                      width: 1.0,
                    ),
                  ),
                )
              : null,
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingTicketCard(Flight flight, bool isNext) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: BounceTap(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  BoardingPassScreen(
                flight: flight,
                selectedSeats: [flight.seat],
                isBookingConfirmed: true,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const curve = Curves.easeOutCubic;
                final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: curve),
                );
                return FadeTransition(opacity: fadeAnim, child: child);
              },
              transitionDuration: const Duration(milliseconds: 320),
            ),
          );
        },
        child: Hero(
          tag: 'boarding_pass_${flight.id}',
          child: Material(
            type: MaterialType.transparency,
            child: Container(
          decoration: ShapeDecoration(
            color: const Color(0xFF141318),
            shadows: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 24,
                cornerSmoothing: 0.6,
              ),
              side: BorderSide(
                color: isNext
                    ? const Color(0xFF381F23)
                    : const Color(0xFF26252F),
                width: 1.0,
              ),
            ),
          ),
          child: Column(
            children: [
              // Header ribbon
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: ShapeDecoration(
                              color: AppColors.primaryRed.withValues(alpha: 0.14),
                              shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                  cornerRadius: 8,
                                  cornerSmoothing: 0.6,
                                ),
                              ),
                            ),
                            child: const Icon(Icons.flight_takeoff_rounded,
                                color: AppColors.primaryRed, size: 16),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  flight.airlineName,
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${flight.flightNumber} • ${flight.aircraft}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
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
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: ShapeDecoration(
                        color: isNext
                            ? Colors.greenAccent.withValues(alpha: 0.15)
                            : const Color(0xFF222129),
                        shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                            cornerRadius: 8,
                            cornerSmoothing: 0.6,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          if (isNext) ...[
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.greenAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            isNext ? 'Boarding in 4h' : 'Confirmed',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isNext ? Colors.greenAccent : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: Color(0xFF22212A), height: 1),

              // Route & Times
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 76,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            flight.fromCode,
                            style: GoogleFonts.outfit(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            flight.fromCity,
                            style: GoogleFonts.outfit(
                              fontSize: 11.5,
                              color: AppColors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            flight.fromTime,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Flight duration and line
                    Column(
                      children: [
                        Text(
                          flight.duration,
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Container(
                              width: 18,
                              height: 1.5,
                              color: const Color(0xFF383745),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              child: Icon(Icons.flight_rounded,
                                  color: AppColors.primaryRed, size: 14),
                            ),
                            Container(
                              width: 18,
                              height: 1.5,
                              color: const Color(0xFF383745),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          flight.stopsInfo,
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      width: 76,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            flight.toCode,
                            style: GoogleFonts.outfit(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            flight.toCity,
                            style: GoogleFonts.outfit(
                              fontSize: 11.5,
                              color: AppColors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            flight.toTime,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom details strip (Gate, Seat, Terminal)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: const ShapeDecoration(
                  color: Color(0xFF1B1A20),
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.only(
                      bottomLeft:
                          SmoothRadius(cornerRadius: 24, cornerSmoothing: 0.6),
                      bottomRight:
                          SmoothRadius(cornerRadius: 24, cornerSmoothing: 0.6),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: _bottomMeta('GATE', flight.gate)),
                    Flexible(child: _bottomMeta('SEAT', flight.seat)),
                    Flexible(child: _bottomMeta('CLASS', flight.cabinClass)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Pass Details',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryRed,
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded,
                            color: AppColors.primaryRed, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
      ),
    );
  }

  Widget _bottomMeta(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 0.8,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildPastTicketCard(Map<String, dynamic> past) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: ShapeDecoration(
          color: const Color(0xFF141318),
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 20,
              cornerSmoothing: 0.6,
            ),
            side: const BorderSide(color: Color(0xFF24232C), width: 1.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${past['from']} ➔ ${past['to']}',
                  style: GoogleFonts.outfit(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${past['airline']} • ${past['date']}',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Completed',
                  style: GoogleFonts.outfit(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white54,
                  ),
                ),
                Text(
                  past['seat'] as String,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
