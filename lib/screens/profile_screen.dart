import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/bounce_tap.dart';
import 'onboarding_screen.dart';

class ProfileScreen extends StatefulWidget {
  final ValueChanged<int>? onSwitchTab;

  const ProfileScreen({super.key, this.onSwitchTab});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _pushNotifications = true;

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
                // Header & Avatar Row
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                    child: _buildProfileHeader(),
                  ),
                ),

                // Frequent Flyer Tier Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildTierCard(),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                // Travel Stats Row
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildStatsGrid(),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // Settings & Preferences Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildSettingsGroup(),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 110)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        // Avatar with gradient border
        Container(
          width: 64,
          height: 64,
          decoration: ShapeDecoration(
            color: const Color(0xFF1E1C24),
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 20,
                cornerSmoothing: 0.6,
              ),
              side: const BorderSide(color: Color(0xFF381F23), width: 1.5),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
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
                size: 34,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Passenger Name & Status
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'Mohammad Alizadeh',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.verified_rounded,
                      color: AppColors.primaryRed, size: 18),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Member ID #AC-992482 • Platinum',
                style: GoogleFonts.outfit(
                  fontSize: 12.5,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Quick Edit button
        Container(
          width: 38,
          height: 38,
          decoration: ShapeDecoration(
            color: const Color(0xFF18171E),
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 12,
                cornerSmoothing: 0.6,
              ),
              side: const BorderSide(color: Color(0xFF282732), width: 1),
            ),
          ),
          child: const Icon(Icons.edit_outlined,
              color: Colors.white70, size: 18),
        ),
      ],
    );
  }

  Widget _buildTierCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          side: const BorderSide(color: Color(0xFF33161A), width: 1.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: ShapeDecoration(
                        color: AppColors.primaryRed.withValues(alpha: 0.16),
                        shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                            cornerRadius: 8,
                            cornerSmoothing: 0.6,
                          ),
                        ),
                      ),
                      child: Text(
                        'STAR ALLIANCE GOLD',
                        style: GoogleFonts.outfit(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ),
                    Text(
                      'Aero Club Elite',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.star_rounded,
                  color: Color(0xFFFFB800), size: 22),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            '84,250',
            style: GoogleFonts.outfit(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          Text(
            'Available Award Miles',
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              color: AppColors.textMuted,
            ),
          ),

          const SizedBox(height: 16),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.84,
              minHeight: 6,
              backgroundColor: const Color(0xFF222129),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
            ),
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '15,750 miles to Diamond',
                  style: GoogleFonts.outfit(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Resets Dec 2024',
                style: GoogleFonts.outfit(
                  fontSize: 11.5,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        _statBox('42', 'Flights taken', Icons.flight_takeoff_rounded),
        const SizedBox(width: 10),
        _statBox('18', 'Countries', Icons.public_rounded),
        const SizedBox(width: 10),
        _statBox('120k', 'Km traveled', Icons.map_rounded),
      ],
    );
  }

  Widget _statBox(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: ShapeDecoration(
          color: const Color(0xFF141318),
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 16,
              cornerSmoothing: 0.6,
            ),
            side: const BorderSide(color: Color(0xFF25242E), width: 1),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryRed, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              label,
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
    );
  }

  Widget _buildSettingsGroup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account & Preferences',
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: ShapeDecoration(
            color: const Color(0xFF141318),
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 22,
                cornerSmoothing: 0.6,
              ),
              side: const BorderSide(color: Color(0xFF25242E), width: 1),
            ),
          ),
          child: Column(
            children: [
              _settingRow(
                icon: Icons.badge_outlined,
                title: 'Passport & Visas',
                subtitle: 'US Passport verified • Swiss Visa active',
                onTap: () {},
              ),
              const Divider(color: Color(0xFF222129), height: 1),
              _settingRow(
                icon: Icons.credit_card_rounded,
                title: 'Payment Methods',
                subtitle: 'Apple Pay • Visa ending in 4028',
                onTap: () {},
              ),
              const Divider(color: Color(0xFF222129), height: 1),
              _settingRow(
                icon: Icons.airline_seat_recline_extra_rounded,
                title: 'Travel Preferences',
                subtitle: 'Window seat • Business class • Vegan',
                onTap: () {},
              ),
              const Divider(color: Color(0xFF222129), height: 1),
              _settingRow(
                icon: Icons.notifications_none_rounded,
                title: 'Gate & Price Notifications',
                subtitle: 'Real-time push alerts enabled',
                trailing: Switch(
                  value: _pushNotifications,
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppColors.primaryRed,
                  onChanged: (val) =>
                      setState(() => _pushNotifications = val),
                ),
              ),
              const Divider(color: Color(0xFF222129), height: 1),
              _settingRow(
                icon: Icons.explore_outlined,
                title: 'Revisit Onboarding',
                subtitle: 'Watch the app intro animations again',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OnboardingScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _settingRow({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return BounceTap(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: ShapeDecoration(
                color: const Color(0xFF1C1B22),
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 10,
                    cornerSmoothing: 0.6,
                  ),
                ),
              ),
              child: Icon(icon, color: Colors.white70, size: 19),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                const Icon(Icons.chevron_right_rounded,
                    color: Colors.white38, size: 20),
          ],
        ),
      ),
    );
  }
}
