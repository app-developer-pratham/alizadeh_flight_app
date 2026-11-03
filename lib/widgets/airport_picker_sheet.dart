import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/airport.dart';
import '../theme/app_theme.dart';
import 'bounce_tap.dart';

class AirportPickerSheet extends StatefulWidget {
  final String title;
  final String selectedCode;
  final ValueChanged<Airport> onSelected;

  const AirportPickerSheet({
    super.key,
    required this.title,
    required this.selectedCode,
    required this.onSelected,
  });

  static Future<Airport?> show({
    required BuildContext context,
    required String title,
    required String selectedCode,
    required ValueChanged<Airport> onSelected,
  }) {
    return showModalBottomSheet<Airport>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AirportPickerSheet(
        title: title,
        selectedCode: selectedCode,
        onSelected: onSelected,
      ),
    );
  }

  @override
  State<AirportPickerSheet> createState() => _AirportPickerSheetState();
}

class _AirportPickerSheetState extends State<AirportPickerSheet> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Airport> get _filteredAirports {
    if (_searchQuery.trim().isEmpty) {
      return Airport.popularAirports;
    }
    final q = _searchQuery.toLowerCase();
    return Airport.popularAirports.where((a) {
      return a.code.toLowerCase().contains(q) ||
          a.city.toLowerCase().contains(q) ||
          a.country.toLowerCase().contains(q) ||
          a.airportName.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      decoration: const ShapeDecoration(
        color: Color(0xFF141317),
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.only(
            topLeft: SmoothRadius(cornerRadius: 28, cornerSmoothing: 0.6),
            topRight: SmoothRadius(cornerRadius: 28, cornerSmoothing: 0.6),
          ),
          side: BorderSide(color: Color(0xFF282830), width: 1.0),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Select departure or arrival airport',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                BounceTap(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF1F1E24),
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 12,
                          cornerSmoothing: 0.6,
                        ),
                      ),
                    ),
                    child: const Icon(Icons.close_rounded,
                        color: Colors.white70, size: 20),
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: ShapeDecoration(
                color: const Color(0xFF1B1A20),
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 14,
                    cornerSmoothing: 0.6,
                  ),
                  side: const BorderSide(color: Color(0xFF2E2D36), width: 1),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded,
                      color: AppColors.textMuted, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: GoogleFonts.outfit(
                          color: Colors.white, fontSize: 14.5),
                      cursorColor: AppColors.primaryRed,
                      decoration: InputDecoration(
                        hintText: 'Search city or airport code (e.g. JFK)',
                        hintStyle: GoogleFonts.outfit(
                            color: Colors.white38, fontSize: 14),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      child: const Icon(Icons.clear_rounded,
                          color: Colors.white54, size: 18),
                    ),
                ],
              ),
            ),
          ),

          // Airports List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              itemCount: _filteredAirports.length,
              separatorBuilder: (context, index) =>
                  const Divider(color: Color(0xFF222129), height: 1),
              itemBuilder: (context, index) {
                final airport = _filteredAirports[index];
                final isSelected = airport.code == widget.selectedCode;

                return BounceTap(
                  onTap: () {
                    widget.onSelected(airport);
                    Navigator.pop(context, airport);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 12),
                    decoration: ShapeDecoration(
                      color: isSelected
                          ? AppColors.primaryRed.withValues(alpha: 0.08)
                          : Colors.transparent,
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 12,
                          cornerSmoothing: 0.6,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Airport Code Pill
                        Container(
                          width: 52,
                          height: 38,
                          alignment: Alignment.center,
                          decoration: ShapeDecoration(
                            color: isSelected
                                ? AppColors.primaryRed
                                : const Color(0xFF1E1D24),
                            shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                cornerRadius: 10,
                                cornerSmoothing: 0.6,
                              ),
                              side: BorderSide(
                                color: isSelected
                                    ? Colors.transparent
                                    : const Color(0xFF32313B),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            airport.code,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: isSelected ? Colors.white : Colors.white70,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // City & Airport Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${airport.city}, ${airport.country}',
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                airport.airportName,
                                style: GoogleFonts.outfit(
                                  fontSize: 12.5,
                                  color: AppColors.textMuted,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        if (isSelected)
                          const Icon(Icons.check_circle_rounded,
                              color: AppColors.primaryRed, size: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
