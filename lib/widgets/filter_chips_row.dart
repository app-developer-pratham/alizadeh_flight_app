import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class FilterChipsRow extends StatelessWidget {
  final int activeFlightsCount;
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  const FilterChipsRow({
    super.key,
    required this.activeFlightsCount,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  static const List<String> filters = [
    'Best deal',
    'Recommended',
    'Best price',
    'Cheapest',
    'Fastest',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '$activeFlightsCount active flights',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: filters.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final filter = filters[index];
              final isSelected = filter == selectedFilter;

              return GestureDetector(
                onTap: () => onFilterSelected(filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    color: isSelected
                        ? AppColors.primaryRed
                        : AppColors.surfaceDark,
                    shadows: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                        cornerRadius: 17,
                        cornerSmoothing: 0.6,
                      ),
                      side: isSelected
                          ? BorderSide(
                              color: Colors.white.withValues(alpha: 0.12),
                              width: 1.0,
                            )
                          : const BorderSide(
                              color: Color(0xFF28282D),
                              width: 1.0,
                            ),
                    ),
                  ),
                  child: Text(
                    filter,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF8E8E93),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
