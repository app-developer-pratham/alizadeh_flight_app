import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FlightBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const FlightBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 28),
      height: 64,
      decoration: ShapeDecoration(
        color: const Color(0xFF141418),
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 24,
            cornerSmoothing: 0.6,
          ),
          side: const BorderSide(
            color: Color(0xFF26262C),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(
            index: 0,
            icon: Icons.flight_takeoff_rounded,
            activeIcon: Icons.flight_takeoff_rounded,
            label: 'Flights',
          ),
          _navItem(
            index: 1,
            icon: Icons.explore_outlined,
            activeIcon: Icons.explore_rounded,
            label: 'Explore',
          ),
          _navItem(
            index: 2,
            icon: Icons.confirmation_number_outlined,
            activeIcon: Icons.confirmation_number_rounded,
            label: 'Tickets',
          ),
          _navItem(
            index: 3,
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: isSelected
            ? ShapeDecoration(
                color: AppColors.primaryRed,
                shadows: [
                  BoxShadow(
                    color: AppColors.primaryRed.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 16,
                    cornerSmoothing: 0.6,
                  ),
                ),
              )
            : null,
        child: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected ? Colors.white : const Color(0xFF75757F),
          size: 22,
        ),
      ),
    );
  }
}

