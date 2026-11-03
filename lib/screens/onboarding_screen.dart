import 'dart:math' as math;
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/flight.dart';
import '../theme/app_theme.dart';
import 'boarding_pass_screen.dart';
import 'main_navigation_screen.dart';
import '../widgets/bounce_tap.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _animController;
  int _currentPage = 0;

  final List<OnboardingSlideData> _slides = const [
    OnboardingSlideData(
      tag: 'SEAMLESS DISCOVERY',
      title: 'Discover Your\nDream Flight',
      subtitle:
          'Explore hundreds of global routes with transparent fares, real-time schedule tracking, and instant confirmations.',
      accentBadge: 'JFK ➔ ZHR',
      subBadge: '7h 35m • Direct',
    ),
    OnboardingSlideData(
      tag: 'CABIN COMFORT',
      title: 'Choose Your\nPreferred Seat',
      subtitle:
          'Interactive cabin seat maps allow you to select the best seats in First, Business, or Economy class with total ease.',
      accentBadge: 'A 380 Cabin',
      subBadge: 'Window • 04A',
    ),
    OnboardingSlideData(
      tag: 'PAPERLESS TRAVEL',
      title: 'Instant Digital\nBoarding Passes',
      subtitle:
          'Access digital boarding passes with live gate alerts, scannable barcodes, and easy multi-passenger ticket management.',
      accentBadge: 'Gate B22',
      subBadge: 'Boarding 05:40am',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onNextTap() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToBooking();
    }
  }

  void _navigateToBooking() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainNavigationScreen(),
      ),
    );
  }

  void _navigateToBoardingPass() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background ambient lighting gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 480,
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.2),
                  radius: 0.9,
                  colors: [
                    Color(0xFF330E14),
                    Color(0xFF160608),
                    AppColors.background,
                  ],
                  stops: [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top Header Row: Brand & Skip Button
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // App Brand Mark
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: ShapeDecoration(
                              color: AppColors.primaryRed,
                              shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                  cornerRadius: 11,
                                  cornerSmoothing: 0.6,
                                ),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: AppColors.primaryRed
                                      .withValues(alpha: 0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.flight_takeoff_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'AERO',
                            style: GoogleFonts.outfit(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),

                      // Skip Button
                      GestureDetector(
                        onTap: _navigateToBooking,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: ShapeDecoration(
                            color: AppColors.surfaceDark,
                            shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                cornerRadius: 12,
                                cornerSmoothing: 0.6,
                              ),
                              side: const BorderSide(
                                color: AppColors.surfaceDarkBorder,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            'Skip',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Hero Graphic Section with Dynamic Aircraft & Floating Badges
                Expanded(
                  flex: 6,
                  child: AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      final floatOffset =
                          math.sin(_animController.value * 2 * math.pi) * 8.0;
                      final currentSlide = _slides[_currentPage];

                      return Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Orbital Radar / Flight rings in background
                              CustomPaint(
                                painter: _OrbitalRadarPainter(
                                    pulse: _animController.value),
                                size: const Size(320, 320),
                              ),

                              // Stylized Aircraft Illustration
                              Transform.translate(
                                offset: Offset(0, floatOffset),
                                child: SizedBox(
                                  width: 280,
                                  height: 240,
                                  child: CustomPaint(
                                    painter: _AirplaneHeroPainter(),
                                  ),
                                ),
                              ),

                              // Floating Flight Badge 1 (Top Left)
                              Positioned(
                                top: 40 + floatOffset * 0.5,
                                left: 28,
                                child: _floatingBadge(
                                  icon: Icons.flight_takeoff_rounded,
                                  text: currentSlide.accentBadge,
                                  isAccent: true,
                                ),
                              ),

                              // Floating Flight Badge 2 (Bottom Right)
                              Positioned(
                                bottom: 35 - floatOffset * 0.5,
                                right: 28,
                                child: _floatingBadge(
                                  icon: Icons.airline_seat_recline_extra_rounded,
                                  text: currentSlide.subBadge,
                                  isAccent: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Content Slider (Title & Subtitle)
                Expanded(
                  flex: 4,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _slides.length,
                    itemBuilder: (context, index) {
                      final slide = _slides[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Tag
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: ShapeDecoration(
                                color: AppColors.primaryRed
                                    .withValues(alpha: 0.15),
                                shape: SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius(
                                    cornerRadius: 8,
                                    cornerSmoothing: 0.6,
                                  ),
                                ),
                              ),
                              child: Text(
                                slide.tag,
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                  color: AppColors.primaryRed,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Heading
                            Text(
                              slide.title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                height: 1.15,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),

                            // Subtitle
                            Text(
                              slide.subtitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w400,
                                height: 1.45,
                                color: AppColors.textMuted,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Smooth Animated Page Indicator
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (index) {
                      final isSelected = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isSelected ? 32 : 8,
                        height: 8,
                        decoration: ShapeDecoration(
                          color: isSelected
                              ? AppColors.primaryRed
                              : const Color(0xFF282830),
                          shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 4,
                              cornerSmoothing: 0.6,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // Bottom Action Buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: Column(
                    children: [
                      // Primary Button
                      BounceTap(
                        onTap: _onNextTap,
                        child: Container(
                          height: 56,
                          width: double.infinity,
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
                              Text(
                                _currentPage == _slides.length - 1
                                    ? 'Get Started'
                                    : 'Continue',
                                style: GoogleFonts.outfit(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                _currentPage == _slides.length - 1
                                    ? Icons.flight_takeoff_rounded
                                    : Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 19,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Secondary quick link
                      GestureDetector(
                        onTap: _navigateToBoardingPass,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            'Already booked a flight? View Boarding Pass',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatingBadge({
    required IconData icon,
    required String text,
    required bool isAccent,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: ShapeDecoration(
        color: const Color(0xFF16161B).withValues(alpha: 0.85),
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 14,
            cornerSmoothing: 0.6,
          ),
          side: BorderSide(
            color: isAccent
                ? AppColors.primaryRed.withValues(alpha: 0.6)
                : const Color(0xFF2C2C34),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isAccent ? AppColors.primaryRed : Colors.white70,
          ),
          const SizedBox(width: 7),
          Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingSlideData {
  final String tag;
  final String title;
  final String subtitle;
  final String accentBadge;
  final String subBadge;

  const OnboardingSlideData({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.accentBadge,
    required this.subBadge,
  });
}

class _OrbitalRadarPainter extends CustomPainter {
  final double pulse;

  const _OrbitalRadarPainter({required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final linePaint = Paint()
      ..color = const Color(0xFF282830).withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final dashPaint = Paint()
      ..color = AppColors.primaryRed.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Concentric circles
    canvas.drawCircle(center, 70, linePaint);
    canvas.drawCircle(center, 115, linePaint);
    canvas.drawCircle(center, 150 + pulse * 10, dashPaint);

    // Dynamic flight trajectory arc
    final trajectoryPaint = Paint()
      ..color = AppColors.primaryRed.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final arcRect = Rect.fromCircle(center: center, radius: 115);
    canvas.drawArc(arcRect, -0.6 * math.pi, 0.9 * math.pi, false, trajectoryPaint);

    // Glowing waypoint dot
    final dotPaint = Paint()
      ..color = AppColors.primaryRed
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(
        center.dx + 115 * math.cos(-0.6 * math.pi),
        center.dy + 115 * math.sin(-0.6 * math.pi),
      ),
      3.5,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _OrbitalRadarPainter oldDelegate) =>
      oldDelegate.pulse != pulse;
}

class _AirplaneHeroPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(-0.25); // Slight dynamic tilt

    // Red wingtip / jet engine glow trails
    final glowPaint = Paint()
      ..color = AppColors.primaryRed.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);

    canvas.drawOval(
      Rect.fromCenter(center: const Offset(-20, 25), width: 90, height: 24),
      glowPaint,
    );

    // Contrail lines
    final contrailPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppColors.primaryRed.withValues(alpha: 0.7),
          AppColors.primaryRed.withValues(alpha: 0.0),
        ],
      ).createShader(const Rect.fromLTWH(-120, -10, 100, 20))
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final contrailPath = Path()
      ..moveTo(-35, 18)
      ..cubicTo(-70, 22, -100, 35, -130, 48);
    canvas.drawPath(contrailPath, contrailPaint);

    // Airplane Body (Luxury commercial airliner silhouette in 3/4 isometric perspective)
    final fuselagePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFE4E4E8),
          Color(0xFF9E9EA6),
        ],
      ).createShader(const Rect.fromLTWH(-70, -30, 150, 60))
      ..style = PaintingStyle.fill;

    final wingPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFD6D6DC),
          Color(0xFF868690),
        ],
      ).createShader(const Rect.fromLTWH(-40, -60, 100, 120))
      ..style = PaintingStyle.fill;

    final accentPaint = Paint()
      ..color = AppColors.primaryRed
      ..style = PaintingStyle.fill;

    // Far Wing (Left / Top)
    final farWing = Path()
      ..moveTo(-10, -5)
      ..lineTo(25, -60)
      ..lineTo(38, -60)
      ..lineTo(15, -5)
      ..close();
    canvas.drawPath(farWing, wingPaint);

    // Red wingtip on far wing
    final farWingtip = Path()
      ..moveTo(25, -60)
      ..lineTo(38, -60)
      ..lineTo(34, -50)
      ..lineTo(27, -50)
      ..close();
    canvas.drawPath(farWingtip, accentPaint);

    // Main Fuselage (streamlined sleek jet)
    final fuselage = Path()
      ..moveTo(75, 0) // Nose cone
      ..cubicTo(50, -12, 10, -14, -45, -10) // Top deck
      ..lineTo(-75, -25) // Vertical stabilizer base
      ..lineTo(-88, -25) // Tail tip
      ..lineTo(-80, 0)
      ..cubicTo(-60, 12, -20, 15, 20, 12) // Bottom belly
      ..cubicTo(45, 10, 65, 4, 75, 0)
      ..close();
    canvas.drawPath(fuselage, fuselagePaint);

    // Tail fin / Rudder accent in Crimson Red
    final tailFin = Path()
      ..moveTo(-50, -11)
      ..lineTo(-78, -48)
      ..lineTo(-68, -48)
      ..lineTo(-40, -10)
      ..close();
    canvas.drawPath(tailFin, accentPaint);

    // Near Wing (Right / Bottom)
    final nearWing = Path()
      ..moveTo(10, 5)
      ..lineTo(-25, 65)
      ..lineTo(-12, 65)
      ..lineTo(35, 5)
      ..close();
    canvas.drawPath(nearWing, wingPaint);

    // Red winglet on near wing
    final nearWinglet = Path()
      ..moveTo(-25, 65)
      ..lineTo(-12, 65)
      ..lineTo(-8, 55)
      ..lineTo(-22, 55)
      ..close();
    canvas.drawPath(nearWinglet, accentPaint);

    // Cockpit windshield windows
    final windowPaint = Paint()
      ..color = const Color(0xFF141416)
      ..style = PaintingStyle.fill;

    final cockpit = Path()
      ..moveTo(64, -2)
      ..lineTo(54, -6)
      ..lineTo(52, -2)
      ..lineTo(60, 0)
      ..close();
    canvas.drawPath(cockpit, windowPaint);

    // Red turbine ring on jet engine
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(-2, 26), width: 14, height: 8),
      accentPaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

