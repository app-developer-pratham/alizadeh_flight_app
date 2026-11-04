import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/bounce_tap.dart';
import 'flight_booking_screen.dart';

class ExploreScreen extends StatefulWidget {
  final ValueChanged<int>? onSwitchTab;

  const ExploreScreen({super.key, this.onSwitchTab});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedCategory = 'Featured';
  bool _isLoadingCategory = false;
  final List<String> _categories = const [
    'Featured',
    'Europe',
    'Asia',
    'Americas',
    'Middle East'
  ];

  void _onCategoryTap(String cat) {
    if (_selectedCategory == cat) return;
    setState(() {
      _selectedCategory = cat;
      _isLoadingCategory = true;
    });
    Future.delayed(const Duration(milliseconds: 280), () {
      if (mounted) {
        setState(() {
          _isLoadingCategory = false;
        });
      }
    });
  }

  final List<Map<String, dynamic>> _exploreItems = const [
    {
      'title': 'Zurich & Swiss Alps',
      'code': 'ZHR',
      'from': 'JFK',
      'fromCity': 'New york',
      'toCity': 'Zurich',
      'subtitle': 'Autumn in Lake Zurich & Matterhorn peak trails',
      'price': 560,
      'duration': '7h 35m',
      'type': 'Direct',
      'badge': 'Top Rated',
      'icon': Icons.landscape_rounded,
      'airlines': 'American • SWISS',
    },
    {
      'title': 'Tokyo Shinjuku & Ginza',
      'code': 'HND',
      'from': 'JFK',
      'fromCity': 'New york',
      'toCity': 'Tokyo',
      'subtitle': 'Vibrant neon cityscapes, culinary Michelin art & sushi',
      'price': 890,
      'duration': '14h 10m',
      'type': '1 Stop',
      'badge': 'Trending',
      'icon': Icons.nightlife_rounded,
      'airlines': 'ANA • Delta',
    },
    {
      'title': 'Parisian River Seine',
      'code': 'CDG',
      'from': 'JFK',
      'fromCity': 'New york',
      'toCity': 'Paris',
      'subtitle': 'Louvre, Eiffel vistas, and luxury fashion avenues',
      'price': 620,
      'duration': '8h 15m',
      'type': 'Direct',
      'badge': 'Curated',
      'icon': Icons.local_cafe_rounded,
      'airlines': 'Air France • Delta',
    },
    {
      'title': 'Dubai Palm Skyline',
      'code': 'DXB',
      'from': 'JFK',
      'fromCity': 'New york',
      'toCity': 'Dubai',
      'subtitle': 'Desert safaris, Burj Khalifa summits, 7-star luxury',
      'price': 750,
      'duration': '12h 45m',
      'type': '1 Stop',
      'badge': 'Luxury',
      'icon': Icons.hotel_rounded,
      'airlines': 'Emirates',
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
                // Header
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
                              'GLOBAL CURATION',
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
                          'Explore Horizons',
                          style: GoogleFonts.outfit(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Curated non-stop flights and signature world routes',
                          style: GoogleFonts.outfit(
                            fontSize: 13.5,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Live Flight Radar Teaser Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildLiveRadarCard(),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                // Category Chips Row
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 40,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _categories.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected = cat == _selectedCategory;

                        return BounceTap(
                          onTap: () => _onCategoryTap(cat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            alignment: Alignment.center,
                            decoration: ShapeDecoration(
                              color: isSelected
                                  ? AppColors.primaryRed
                                  : const Color(0xFF16151B),
                              shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                  cornerRadius: 14,
                                  cornerSmoothing: 0.6,
                                ),
                                side: BorderSide(
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.14)
                                      : const Color(0xFF282732),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(
                              cat,
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color:
                                    isSelected ? Colors.white : Colors.white70,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                // Explore Cards List with Interactive Loading State
                if (_isLoadingCategory) ...[
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildExploreSkeleton(),
                        childCount: 2,
                      ),
                    ),
                  ),
                ] else ...[
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = _exploreItems[index];
                          return _buildExploreCard(item);
                        },
                        childCount: _exploreItems.length,
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

  Widget _buildExploreSkeleton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        height: 175,
        padding: const EdgeInsets.all(18),
        decoration: ShapeDecoration(
          color: const Color(0xFF141318),
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 22,
              cornerSmoothing: 0.6,
            ),
            side: const BorderSide(color: Color(0xFF282732), width: 1.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Container(
                  width: 70,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: 160,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 240,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: 90,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveRadarCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: ShapeDecoration(
        color: const Color(0xFF141318),
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 22,
            cornerSmoothing: 0.6,
          ),
          side: const BorderSide(color: Color(0xFF26252E), width: 1.0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: ShapeDecoration(
              color: AppColors.primaryRed.withValues(alpha: 0.12),
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 14,
                  cornerSmoothing: 0.6,
                ),
              ),
            ),
            child: const Icon(Icons.radar_rounded,
                color: AppColors.primaryRed, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'LIVE AIRSPACE RADAR',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: AppColors.primaryRed,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '12,840 Aircraft In Flight',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Transatlantic corridors operating smoothly',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded,
              color: Colors.white38, size: 14),
        ],
      ),
    );
  }

  Widget _buildExploreCard(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: BounceTap(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FlightBookingScreen(
                fromCode: item['from'] as String,
                fromCity: item['fromCity'] as String,
                toCode: item['code'] as String,
                toCity: item['toCity'] as String,
                isRoundTrip: true,
              ),
            ),
          );
        },
        child: Hero(
          tag: 'explore_dest_${item['code']}',
          child: Material(
            type: MaterialType.transparency,
            child: Container(
          padding: const EdgeInsets.all(18),
          decoration: ShapeDecoration(
            color: const Color(0xFF141318),
            shadows: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 22,
                cornerSmoothing: 0.6,
              ),
              side: const BorderSide(color: Color(0xFF282732), width: 1.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge and Airport Route Pill
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: ShapeDecoration(
                      color: AppColors.primaryRed.withValues(alpha: 0.14),
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 8,
                          cornerSmoothing: 0.6,
                        ),
                      ),
                    ),
                    child: Text(
                      item['badge'] as String,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF1F1E26),
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 8,
                          cornerSmoothing: 0.6,
                        ),
                      ),
                    ),
                    child: Text(
                      '${item['from']} ➔ ${item['code']}',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Title & Icon
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF1F1E26),
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 12,
                          cornerSmoothing: 0.6,
                        ),
                      ),
                    ),
                    child: Icon(item['icon'] as IconData,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          item['subtitle'] as String,
                          style: GoogleFonts.outfit(
                            fontSize: 12.5,
                            color: AppColors.textMuted,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),
              const Divider(color: Color(0xFF222129), height: 1),
              const SizedBox(height: 12),

              // Bottom Stats & Book Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item['duration']} • ${item['type']}',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item['airlines'] as String,
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
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'from ',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        '\$${item['price']}',
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: ShapeDecoration(
                          color: AppColors.primaryRed,
                          shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 11,
                              cornerSmoothing: 0.6,
                            ),
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.12),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Text(
                          'View Flights',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
      ),
    );
  }
}
