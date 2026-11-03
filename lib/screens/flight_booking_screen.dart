import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flight.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/date_selector.dart';
import '../widgets/filter_chips_row.dart';
import '../widgets/flight_arc_painter.dart';
import '../widgets/flight_details_sheet.dart';
import '../widgets/ticket_card.dart';

class FlightBookingScreen extends StatefulWidget {
  const FlightBookingScreen({super.key});

  @override
  State<FlightBookingScreen> createState() => _FlightBookingScreenState();
}

class _FlightBookingScreenState extends State<FlightBookingScreen> {
  bool isRoundTrip = true;
  int selectedDay = 21;
  String selectedFilter = 'Best deal';
  int currentNavIndex = 0;

  List<Flight> get filteredFlights {
    switch (selectedFilter) {
      case 'Cheapest':
        final list = List<Flight>.from(Flight.sampleFlights);
        list.sort((a, b) => a.price.compareTo(b.price));
        return list;
      case 'Fastest':
        return [
          Flight.sampleFlights[1],
          Flight.sampleFlights[0],
          Flight.sampleFlights[2],
          Flight.sampleFlights[3],
        ];
      case 'Best price':
        return [
          Flight.sampleFlights[0],
          Flight.sampleFlights[1],
          Flight.sampleFlights[2],
          Flight.sampleFlights[3],
        ];
      case 'Recommended':
      case 'Best deal':
      default:
        return Flight.sampleFlights;
    }
  }

  void _openFlightDetails(Flight flight) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FlightDetailsSheet(flight: flight),
    );
  }

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

          // Main Scrollable Content
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top App Bar Row
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                    child: _buildTopBar(),
                  ),
                ),

                // Flight Route & Duration Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: _buildRouteHeader(),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),

                // Date Selector Strip
                SliverToBoxAdapter(
                  child: DateSelectorStrip(
                    selectedDay: selectedDay,
                    onDaySelected: (day) {
                      setState(() {
                        selectedDay = day;
                      });
                    },
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 24),
                ),

                // Filter Chips Row
                SliverToBoxAdapter(
                  child: FilterChipsRow(
                    activeFlightsCount: 12,
                    selectedFilter: selectedFilter,
                    onFilterSelected: (filter) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),

                // Flight Ticket Cards List
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final flight = filteredFlights[index];
                      return TicketCard(
                        flight: flight,
                        onTap: () => _openFlightDetails(flight),
                      );
                    },
                    childCount: filteredFlights.length,
                  ),
                ),

                // Bottom padding for floating navigation bar
                const SliverToBoxAdapter(
                  child: SizedBox(height: 110),
                ),
              ],
            ),
          ),

          // Floating Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FlightBottomNavBar(
              currentIndex: currentNavIndex,
              onTabSelected: (index) {
                setState(() {
                  currentNavIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 44,
            height: 44,
            decoration: ShapeDecoration(
              color: const Color(0xFF141214),
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 15,
                  cornerSmoothing: 0.6,
                ),
                side: const BorderSide(
                  color: Color(0xFF331417),
                  width: 1.0,
                ),
              ),
            ),
            child: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),

        // Trip Type Toggle (One way / Round trip)
        Container(
          height: 42,
          padding: const EdgeInsets.all(3.5),
          decoration: ShapeDecoration(
            color: const Color(0xFF131114),
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 21,
                cornerSmoothing: 0.6,
              ),
              side: const BorderSide(
                color: Color(0xFF331417),
                width: 1.2,
              ),
            ),
          ),
          child: Row(
            children: [
              // One way
              GestureDetector(
                onTap: () {
                  setState(() {
                    isRoundTrip = false;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: !isRoundTrip
                      ? ShapeDecoration(
                          color: AppColors.primaryRed,
                          shadows: [
                            BoxShadow(
                              color:
                                  AppColors.primaryRed.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 18,
                              cornerSmoothing: 0.6,
                            ),
                          ),
                        )
                      : null,
                  child: Text(
                    'One way',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight:
                          !isRoundTrip ? FontWeight.w700 : FontWeight.w500,
                      color: !isRoundTrip
                          ? Colors.white
                          : const Color(0xFF8E8E93),
                    ),
                  ),
                ),
              ),

              // Round trip
              GestureDetector(
                onTap: () {
                  setState(() {
                    isRoundTrip = true;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: isRoundTrip
                      ? ShapeDecoration(
                          color: AppColors.primaryRed,
                          shadows: [
                            BoxShadow(
                              color:
                                  AppColors.primaryRed.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 18,
                              cornerSmoothing: 0.6,
                            ),
                          ),
                        )
                      : null,
                  child: Text(
                    'Round trip',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight:
                          isRoundTrip ? FontWeight.w700 : FontWeight.w500,
                      color: isRoundTrip
                          ? Colors.white
                          : const Color(0xFF8E8E93),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Profile Avatar with Notification Accent
        Stack(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: ShapeDecoration(
                color: const Color(0xFF1E1C24),
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 15,
                    cornerSmoothing: 0.6,
                  ),
                  side: const BorderSide(
                    color: Color(0xFF331417),
                    width: 1.0,
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFE5A988),
                        Color(0xFFB56A49),
                        Color(0xFF4A2B20),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),
            // Tiny vibrant red notification badge
            Positioned(
              top: 1,
              right: 1,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.background,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Arc spanning across between JFK and ZHR
        const Positioned(
          left: 70,
          right: 70,
          top: 6,
          bottom: 12,
          child: CustomPaint(
            painter: HeaderFlightArcPainter(),
          ),
        ),

        // Route row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left: Origin JFK
            SizedBox(
              width: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'JFK',
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'New york',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            ),

            // Center: Flight Arc & Total Duration
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Column(
                children: [
                  Text(
                    'Total duration',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '12h40m',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),

            // Right: Destination ZHR
            SizedBox(
              width: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'ZHR',
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'Zurich',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
