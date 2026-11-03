import 'dart:math' as math;
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/airport.dart';
import '../models/flight.dart';
import '../theme/app_theme.dart';
import '../widgets/airport_picker_sheet.dart';
import '../widgets/app_primary_button.dart';
import 'boarding_pass_screen.dart';
import 'flight_booking_screen.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onSwitchTab;

  const HomeScreen({super.key, this.onSwitchTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Airport _fromAirport = Airport.popularAirports[0]; // JFK
  Airport _toAirport = Airport.popularAirports[1]; // ZHR

  bool _isRoundTrip = true;
  final int _passengerCount = 1;
  String _cabinClass = 'Business';
  DateTime _departureDate = DateTime(2024, 9, 21);
  DateTime _returnDate = DateTime(2024, 9, 28);

  late final AnimationController _swapAnimController;
  late final Animation<double> _swapRotation;

  @override
  void initState() {
    super.initState();
    _swapAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );
    _swapRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _swapAnimController,
        curve: Curves.easeInOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _swapAnimController.dispose();
    super.dispose();
  }

  void _swapAirports() {
    if (_swapAnimController.isAnimating) return;
    _swapAnimController.forward(from: 0.0);
    setState(() {
      final temp = _fromAirport;
      _fromAirport = _toAirport;
      _toAirport = temp;
    });
  }

  void _pickFromAirport() {
    AirportPickerSheet.show(
      context: context,
      title: 'Departure Airport',
      selectedCode: _fromAirport.code,
      onSelected: (airport) {
        setState(() {
          _fromAirport = airport;
        });
      },
    );
  }

  void _pickToAirport() {
    AirportPickerSheet.show(
      context: context,
      title: 'Destination Airport',
      selectedCode: _toAirport.code,
      onSelected: (airport) {
        setState(() {
          _toAirport = airport;
        });
      },
    );
  }

  void _navigateToFlightBooking() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            FlightBookingScreen(
          fromCode: _fromAirport.code,
          fromCity: _fromAirport.city,
          toCode: _toAirport.code,
          toCity: _toAirport.city,
          isRoundTrip: _isRoundTrip,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.06);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final fadeTween = Tween<double>(begin: 0.0, end: 1.0);
          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(
              opacity: animation.drive(fadeTween),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 320),
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

          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top App Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                    child: _buildHeader(),
                  ),
                ),

                // Flight Search Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildSearchCard(),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 22)),

                // Recent Searches Quick Chips
                SliverToBoxAdapter(
                  child: _buildRecentRoutesSection(),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 22)),

                // Trending Destinations Section
                SliverToBoxAdapter(
                  child: _buildTrendingDestinations(),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 22)),

                // Live Upcoming Flight Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildUpcomingFlightBanner(),
                  ),
                ),

                // Bottom padding for bottom navigation bar
                const SliverToBoxAdapter(child: SizedBox(height: 110)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Greeting & Brand
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    'AERO CONCIERGE',
                    style: GoogleFonts.outfit(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                'Where to next, Alex?',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.4,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Notification & Avatar Row
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BounceTap(
              onTap: () {
                widget.onSwitchTab?.call(2); // Go to tickets
              },
              child: Container(
                width: 42,
                height: 42,
                decoration: ShapeDecoration(
                  color: const Color(0xFF16151B),
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                      cornerRadius: 13,
                      cornerSmoothing: 0.6,
                    ),
                    side: const BorderSide(color: Color(0xFF282732), width: 1),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.notifications_none_rounded,
                        color: Colors.white70, size: 21),
                    Positioned(
                      top: 10,
                      right: 11,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryRed,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            BounceTap(
              onTap: () {
                widget.onSwitchTab?.call(3); // Go to profile
              },
              child: Container(
                width: 42,
                height: 42,
                decoration: ShapeDecoration(
                  color: const Color(0xFF1E1C24),
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                      cornerRadius: 13,
                      cornerSmoothing: 0.6,
                    ),
                    side: const BorderSide(color: Color(0xFF331417), width: 1),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
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
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 23,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: ShapeDecoration(
        color: const Color(0xFF141318),
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
          side: const BorderSide(color: Color(0xFF26252E), width: 1.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trip Type Selector
          Container(
            height: 38,
            padding: const EdgeInsets.all(3),
            decoration: ShapeDecoration(
              color: const Color(0xFF0F0E13),
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 19,
                  cornerSmoothing: 0.6,
                ),
                side: const BorderSide(color: Color(0xFF24232C), width: 1.0),
              ),
            ),
            child: Row(
              children: [
                _tripTypeTab(
                  title: 'Round trip',
                  isSelected: _isRoundTrip,
                  onTap: () => setState(() => _isRoundTrip = true),
                ),
                _tripTypeTab(
                  title: 'One way',
                  isSelected: !_isRoundTrip,
                  onTap: () => setState(() => _isRoundTrip = false),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Origin and Destination Interactive Box with Swap
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Column(
                children: [
                  // From Box
                  BounceTap(
                    onTap: _pickFromAirport,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(14, 11, 52, 11),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1B1A20),
                        shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                            cornerRadius: 15,
                            cornerSmoothing: 0.6,
                          ),
                          side: const BorderSide(
                              color: Color(0xFF2B2A34), width: 1.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: ShapeDecoration(
                              color:
                                  AppColors.primaryRed.withValues(alpha: 0.12),
                              shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                  cornerRadius: 9,
                                  cornerSmoothing: 0.6,
                                ),
                              ),
                            ),
                            child: const Icon(Icons.flight_takeoff_rounded,
                                color: AppColors.primaryRed, size: 17),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'FROM',
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textMuted,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Row(
                                  children: [
                                    Text(
                                      _fromAirport.code,
                                      style: GoogleFonts.outfit(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _fromAirport.city,
                                        style: GoogleFonts.outfit(
                                          fontSize: 13.5,
                                          color: AppColors.textSecondary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // To Box
                  BounceTap(
                    onTap: _pickToAirport,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(14, 11, 52, 11),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1B1A20),
                        shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                            cornerRadius: 15,
                            cornerSmoothing: 0.6,
                          ),
                          side: const BorderSide(
                              color: Color(0xFF2B2A34), width: 1.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: ShapeDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                  cornerRadius: 9,
                                  cornerSmoothing: 0.6,
                                ),
                              ),
                            ),
                            child: const Icon(Icons.flight_land_rounded,
                                color: Colors.white70, size: 17),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TO',
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textMuted,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Row(
                                  children: [
                                    Text(
                                      _toAirport.code,
                                      style: GoogleFonts.outfit(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _toAirport.city,
                                        style: GoogleFonts.outfit(
                                          fontSize: 13.5,
                                          color: AppColors.textSecondary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Swap Button
              Positioned(
                right: 12,
                child: BounceTap(
                  onTap: _swapAirports,
                  child: AnimatedBuilder(
                    animation: _swapRotation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _swapRotation.value * math.pi,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF26242F),
                        shadows: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                            cornerRadius: 12,
                            cornerSmoothing: 0.6,
                          ),
                          side: const BorderSide(
                              color: Color(0xFF383644), width: 1.0),
                        ),
                      ),
                      child: const Icon(
                        Icons.swap_vert_rounded,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Date & Passenger Options Row
          Row(
            children: [
              // Dates Pill
              Expanded(
                child: BounceTap(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _departureDate,
                      firstDate: DateTime(2024, 1, 1),
                      lastDate: DateTime(2026, 12, 31),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: AppColors.primaryRed,
                              onPrimary: Colors.white,
                              surface: Color(0xFF1B1A20),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() {
                        _departureDate = picked;
                        _returnDate = picked.add(const Duration(days: 7));
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 11),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF1B1A20),
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 13,
                          cornerSmoothing: 0.6,
                        ),
                        side: const BorderSide(
                            color: Color(0xFF2B2A34), width: 1.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isRoundTrip ? 'DATES' : 'DEPARTURE',
                          style: GoogleFonts.outfit(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMuted,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded,
                                color: Colors.white70, size: 13),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                _isRoundTrip
                                    ? 'Sep ${_departureDate.day} - ${_returnDate.day}'
                                    : 'Sep ${_departureDate.day}, 2024',
                                style: GoogleFonts.outfit(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Passengers & Class Pill
              Expanded(
                child: BounceTap(
                  onTap: () {
                    setState(() {
                      _cabinClass =
                          _cabinClass == 'Business' ? 'Economy' : 'Business';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 11),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF1B1A20),
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 13,
                          cornerSmoothing: 0.6,
                        ),
                        side: const BorderSide(
                            color: Color(0xFF2B2A34), width: 1.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TRAVELLERS & CLASS',
                          style: GoogleFonts.outfit(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMuted,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                                Icons.airline_seat_recline_normal_rounded,
                                color: Colors.white70,
                                size: 14),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                '$_passengerCount Adult, $_cabinClass',
                                style: GoogleFonts.outfit(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Search Flights Primary Button (Tactile, human-designed, no neon glow)
          AppPrimaryButton(
            text: 'Search Flights',
            icon: Icons.flight_takeoff_rounded,
            height: 52,
            onTap: _navigateToFlightBooking,
          ),
        ],
      ),
    );
  }

  Widget _tripTypeTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: BounceTap(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: isSelected
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
                      cornerRadius: 16,
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

  Widget _buildRecentRoutesSection() {
    final recentRoutes = [
      {'from': 'JFK', 'to': 'ZHR', 'price': '\$560'},
      {'from': 'LHR', 'to': 'HND', 'price': '\$890'},
      {'from': 'SFO', 'to': 'CDG', 'price': '\$620'},
      {'from': 'DXB', 'to': 'SIN', 'price': '\$470'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Recent Searches',
                  style: GoogleFonts.outfit(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'Clear',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 42,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: recentRoutes.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final r = recentRoutes[index];
              final isCurrent =
                  _fromAirport.code == r['from'] && _toAirport.code == r['to'];

              return BounceTap(
                onTap: () {
                  final from = Airport.popularAirports.firstWhere(
                    (a) => a.code == r['from'],
                    orElse: () => _fromAirport,
                  );
                  final to = Airport.popularAirports.firstWhere(
                    (a) => a.code == r['to'],
                    orElse: () => _toAirport,
                  );
                  setState(() {
                    _fromAirport = from;
                    _toAirport = to;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                  decoration: ShapeDecoration(
                    color: isCurrent
                        ? AppColors.primaryRed.withValues(alpha: 0.15)
                        : const Color(0xFF16151B),
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                        cornerRadius: 13,
                        cornerSmoothing: 0.6,
                      ),
                      side: BorderSide(
                        color: isCurrent
                            ? AppColors.primaryRed
                            : const Color(0xFF282732),
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${r['from']} ➔ ${r['to']}',
                        style: GoogleFonts.outfit(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: isCurrent ? Colors.white : Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        r['price']!,
                        style: GoogleFonts.outfit(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: isCurrent
                              ? AppColors.primaryRed
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingDestinations() {
    final destinations = [
      {
        'city': 'Zurich',
        'country': 'Switzerland',
        'code': 'ZHR',
        'price': 560,
        'tag': 'Best Value',
        'duration': '7h 35m • Direct',
        'symbol': Icons.landscape_rounded,
      },
      {
        'city': 'Tokyo',
        'country': 'Japan',
        'code': 'HND',
        'price': 890,
        'tag': 'Trending',
        'duration': '14h 10m • 1 Stop',
        'symbol': Icons.temple_buddhist_rounded,
      },
      {
        'city': 'Paris',
        'country': 'France',
        'code': 'CDG',
        'price': 620,
        'tag': 'Popular',
        'duration': '8h 15m • Direct',
        'symbol': Icons.attractions_rounded,
      },
      {
        'city': 'Dubai',
        'country': 'UAE',
        'code': 'DXB',
        'price': 750,
        'tag': 'Luxury',
        'duration': '12h 45m • 1 Stop',
        'symbol': Icons.apartment_rounded,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Trending Destinations',
                  style: GoogleFonts.outfit(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              BounceTap(
                onTap: () => widget.onSwitchTab?.call(1), // Go to Explore
                child: Text(
                  'Explore All',
                  style: GoogleFonts.outfit(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryRed,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 170,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: destinations.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final d = destinations[index];
              return BounceTap(
                onTap: () {
                  final target = Airport.popularAirports.firstWhere(
                    (a) => a.code == d['code'],
                    orElse: () => _toAirport,
                  );
                  setState(() {
                    _toAirport = target;
                  });
                  _navigateToFlightBooking();
                },
                child: Container(
                  width: 180,
                  padding: const EdgeInsets.all(14),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF16151B),
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                        cornerRadius: 18,
                        cornerSmoothing: 0.6,
                      ),
                      side: const BorderSide(
                          color: Color(0xFF282734), width: 1.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3.5),
                            decoration: ShapeDecoration(
                              color: AppColors.primaryRed.withValues(alpha: 0.16),
                              shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                  cornerRadius: 7,
                                  cornerSmoothing: 0.6,
                                ),
                              ),
                            ),
                            child: Text(
                              d['tag'] as String,
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryRed,
                              ),
                            ),
                          ),
                          Icon(
                            d['symbol'] as IconData,
                            color: Colors.white54,
                            size: 19,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d['city'] as String,
                            style: GoogleFonts.outfit(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            d['duration'] as String,
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'from',
                                style: GoogleFonts.outfit(
                                  fontSize: 9.5,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              Text(
                                '\$${d['price']}',
                                style: GoogleFonts.outfit(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 26,
                            height: 26,
                            decoration: ShapeDecoration(
                              color: AppColors.primaryRed,
                              shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                  cornerRadius: 8,
                                  cornerSmoothing: 0.6,
                                ),
                              ),
                            ),
                            child: const Icon(Icons.arrow_forward_rounded,
                                color: Colors.white, size: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingFlightBanner() {
    return BounceTap(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BoardingPassScreen(
              flight: Flight.sampleFlights.first,
              selectedSeats: const ['04A'],
              isBookingConfirmed: true,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: const Color(0xFF151419),
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 18,
              cornerSmoothing: 0.6,
            ),
            side: const BorderSide(color: Color(0xFF2B2A36), width: 1.0),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: ShapeDecoration(
                color: AppColors.primaryRed.withValues(alpha: 0.12),
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 11,
                    cornerSmoothing: 0.6,
                  ),
                ),
              ),
              child: const Icon(Icons.confirmation_number_rounded,
                  color: AppColors.primaryRed, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'UPCOMING FLIGHT',
                        style: GoogleFonts.outfit(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppColors.primaryRed,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'On time',
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'AA-2849 • JFK ➔ ZHR',
                    style: GoogleFonts.outfit(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Departs Sep 21 at 06:20am • Gate B22',
                    style: GoogleFonts.outfit(
                      fontSize: 11.5,
                      color: AppColors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: Colors.white54, size: 20),
          ],
        ),
      ),
    );
  }
}
