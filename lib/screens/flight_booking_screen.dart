import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flight.dart';
import '../theme/app_theme.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/date_selector.dart';
import '../widgets/filter_chips_row.dart';
import '../widgets/flight_arc_painter.dart';
import '../widgets/ticket_card.dart';
import 'boarding_pass_screen.dart';
import 'main_navigation_screen.dart';
import 'onboarding_screen.dart';
import 'seat_selection_screen.dart';

class FlightBookingScreen extends StatefulWidget {
  final String fromCode;
  final String fromCity;
  final String toCode;
  final String toCity;
  final bool isRoundTrip;

  const FlightBookingScreen({
    super.key,
    this.fromCode = 'JFK',
    this.fromCity = 'New york',
    this.toCode = 'ZHR',
    this.toCity = 'Zurich',
    this.isRoundTrip = true,
  });

  @override
  State<FlightBookingScreen> createState() => _FlightBookingScreenState();
}

class _FlightBookingScreenState extends State<FlightBookingScreen> {
  late bool isRoundTrip;
  int selectedDay = 21;
  String selectedFilter = 'Best deal';
  int currentNavIndex = 0;
  bool _isLoadingFlights = false;

  @override
  void initState() {
    super.initState();
    isRoundTrip = widget.isRoundTrip;
  }

  void _onDateSelected(int day) {
    if (selectedDay == day) return;
    setState(() {
      selectedDay = day;
      _isLoadingFlights = true;
    });
    Future.delayed(const Duration(milliseconds: 380), () {
      if (mounted) {
        setState(() {
          _isLoadingFlights = false;
        });
      }
    });
  }

  void _onFilterSelected(String filter) {
    if (selectedFilter == filter) return;
    setState(() {
      selectedFilter = filter;
      _isLoadingFlights = true;
    });
    Future.delayed(const Duration(milliseconds: 320), () {
      if (mounted) {
        setState(() {
          _isLoadingFlights = false;
        });
      }
    });
  }

  List<Flight> get _baseFlights => Flight.getFlightsForRoute(
        fromCode: widget.fromCode,
        fromCity: widget.fromCity,
        toCode: widget.toCode,
        toCity: widget.toCity,
      );

  List<Flight> get filteredFlights {
    switch (selectedFilter) {
      case 'Cheapest':
        final list = List<Flight>.from(_baseFlights);
        list.sort((a, b) => a.price.compareTo(b.price));
        return list;
      case 'Fastest':
        return [
          _baseFlights[1],
          _baseFlights[0],
          _baseFlights[2],
          _baseFlights[3],
        ];
      case 'Best price':
        return [
          _baseFlights[0],
          _baseFlights[1],
          _baseFlights[2],
          _baseFlights[3],
        ];
      case 'Recommended':
      case 'Best deal':
      default:
        return _baseFlights;
    }
  }

  void _openSeatSelection(Flight flight) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SeatSelectionScreen(flight: flight),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.easeOutCubic;
          final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: curve),
          );
          return FadeTransition(opacity: fadeAnim, child: child);
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
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
                    onDaySelected: _onDateSelected,
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
                    onFilterSelected: _onFilterSelected,
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),

                // Live inventory loading indicator or Flight Ticket Cards List
                if (_isLoadingFlights) ...[
                  SliverToBoxAdapter(
                    child: _buildScanningBanner(),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildSkeletonTicketCard(),
                      childCount: 2,
                    ),
                  ),
                ] else ...[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final flight = filteredFlights[index];
                        return Hero(
                          tag: 'flight_ticket_${flight.id}',
                          child: Material(
                            type: MaterialType.transparency,
                            child: TicketCard(
                              flight: flight,
                              onTap: () => _openSeatSelection(flight),
                            ),
                          ),
                        );
                      },
                      childCount: filteredFlights.length,
                    ),
                  ),
                ],

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
                if (index == 0) {
                  Navigator.maybePop(context);
                  return;
                }
                if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BoardingPassScreen(),
                    ),
                  );
                  return;
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MainNavigationScreen(initialIndex: index),
                  ),
                );
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
        const AppBackButton(),

        // Trip Type Toggle (One way / Round trip)
        Container(
          height: 38,
          padding: const EdgeInsets.all(2.5),
          decoration: ShapeDecoration(
            color: const Color(0xFF131114),
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 19,
                cornerSmoothing: 0.6,
              ),
              side: const BorderSide(
                color: Color(0xFF331417),
                width: 1.2,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
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
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: !isRoundTrip
                      ? ShapeDecoration(
                          color: AppColors.primaryRed,
                          shadows: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 15,
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
                    'One way',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
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
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: isRoundTrip
                      ? ShapeDecoration(
                          color: AppColors.primaryRed,
                          shadows: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 15,
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
                    'Round trip',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
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

        // Profile Avatar with Notification Accent (taps to revisit Onboarding)
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OnboardingScreen(),
              ),
            );
          },
          child: const AppProfileAvatar(),
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
            // Left: Origin
            SizedBox(
              width: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'route_from_${widget.fromCode}',
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        widget.fromCode,
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    widget.fromCity,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8E8E93),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

            // Right: Destination
            SizedBox(
              width: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Hero(
                    tag: 'route_to_${widget.toCode}',
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        widget.toCode,
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    widget.toCity,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8E8E93),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScanningBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: ShapeDecoration(
          color: const Color(0xFF16151B),
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 12,
              cornerSmoothing: 0.6,
            ),
            side: const BorderSide(color: Color(0xFF282732), width: 1),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Searching live airline inventory for Sep $selectedDay...',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonTicketCard() {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: ShapeDecoration(
        color: const Color(0xFF141318),
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 22,
            cornerSmoothing: 0.6,
          ),
          side: const BorderSide(color: Color(0xFF24232C), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 120,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 60,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              Container(
                width: 90,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 60,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}
