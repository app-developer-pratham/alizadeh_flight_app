import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class DateItem {
  final String month;
  final int day;
  final String weekday;

  const DateItem({
    required this.month,
    required this.day,
    required this.weekday,
  });
}

class DateSelectorStrip extends StatelessWidget {
  final int selectedDay;
  final ValueChanged<int> onDaySelected;

  const DateSelectorStrip({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
  });

  static const List<DateItem> dates = [
    DateItem(month: 'Sep', day: 18, weekday: 'Wed'),
    DateItem(month: 'Sep', day: 19, weekday: 'Thu'),
    DateItem(month: 'Sep', day: 20, weekday: 'Fri'),
    DateItem(month: 'Sep', day: 21, weekday: 'Sat'),
    DateItem(month: 'Sep', day: 22, weekday: 'Sun'),
    DateItem(month: 'Sep', day: 23, weekday: 'Mon'),
    DateItem(month: 'Sep', day: 24, weekday: 'Tue'),
    DateItem(month: 'Sep', day: 25, weekday: 'Wed'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: dates.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = dates[index];
          final isSelected = item.day == selectedDay;

          return GestureDetector(
            onTap: () => onDaySelected(item.day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: 52,
              height: 72,
              decoration: ShapeDecoration(
                color: isSelected ? AppColors.primaryRed : AppColors.surfaceDark,
                shadows: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 15,
                    cornerSmoothing: 0.6,
                  ),
                  side: isSelected
                      ? BorderSide(
                          color: Colors.white.withValues(alpha: 0.14),
                          width: 1.0,
                        )
                      : const BorderSide(
                          color: Color(0xFF2E191C),
                          width: 1.0,
                        ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.month,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.9)
                          : const Color(0xFF75757F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.day}',
                    style: GoogleFonts.outfit(
                      fontSize: 17,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFFB0B0B8),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
