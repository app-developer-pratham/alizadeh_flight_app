import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'bounce_tap.dart';

class ScoopedTopCardClipper extends CustomClipper<Path> {
  final double cornerRadius;
  final double scoopWidth;
  final double scoopDepth;

  const ScoopedTopCardClipper({
    this.cornerRadius = 28.0,
    this.scoopWidth = 96.0,
    this.scoopDepth = 9.0,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double halfScoop = scoopWidth / 2;

    path.moveTo(0, h);
    path.lineTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    path.lineTo(cx - halfScoop, 0);
    path.cubicTo(
      cx - halfScoop * 0.55,
      0,
      cx - halfScoop * 0.38,
      scoopDepth,
      cx - halfScoop * 0.22,
      scoopDepth,
    );
    path.lineTo(cx + halfScoop * 0.22, scoopDepth);
    path.cubicTo(
      cx + halfScoop * 0.38,
      scoopDepth,
      cx + halfScoop * 0.55,
      0,
      cx + halfScoop,
      0,
    );

    path.lineTo(w - cornerRadius, 0);
    path.quadraticBezierTo(w, 0, w, cornerRadius);
    path.lineTo(w, h);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant ScoopedTopCardClipper oldDelegate) =>
      cornerRadius != oldDelegate.cornerRadius ||
      scoopWidth != oldDelegate.scoopWidth ||
      scoopDepth != oldDelegate.scoopDepth;
}

class SeatBottomSummarySheet extends StatefulWidget {
  final String cabinClass;
  final int passengerCount;
  final List<String> selectedSeats;
  final int basePrice;
  final VoidCallback onPaymentTap;

  const SeatBottomSummarySheet({
    super.key,
    required this.cabinClass,
    required this.passengerCount,
    required this.selectedSeats,
    required this.basePrice,
    required this.onPaymentTap,
  });

  @override
  State<SeatBottomSummarySheet> createState() => _SeatBottomSummarySheetState();
}

class _SeatBottomSummarySheetState extends State<SeatBottomSummarySheet> {
  late final TextEditingController _promoController;
  bool _promoApplied = false;
  double _discountRate = 0.0;

  @override
  void initState() {
    super.initState();
    _promoController = TextEditingController();
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final code = _promoController.text.trim().toUpperCase();
    if (code == 'ALIZADEH' || code == 'FLY20') {
      setState(() {
        _promoApplied = true;
        _discountRate = 0.20; // 20% off
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Promo code applied: 20% discount!',
              style: GoogleFonts.outfit()),
          backgroundColor: AppColors.primaryRed,
          duration: const Duration(seconds: 2),
        ),
      );
    } else if (code.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Try code: ALIZADEH', style: GoogleFonts.outfit()),
          backgroundColor: AppColors.surfaceDark,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final int rawTotal = widget.basePrice * widget.passengerCount;
    final int finalTotal = _promoApplied
        ? (rawTotal * (1.0 - _discountRate)).round()
        : rawTotal;

    final formattedPrice = finalTotal
        .toString()
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

    final String seatsText = widget.selectedSeats.isEmpty
        ? 'None'
        : widget.selectedSeats.join(',');

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 28,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: ClipPath(
        clipper: const ScoopedTopCardClipper(
          cornerRadius: 28.0,
          scoopWidth: 96.0,
          scoopDepth: 9.0,
        ),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dark Drag Handle sitting inside the scooped recess
              Padding(
                padding: const EdgeInsets.only(top: 13, bottom: 8),
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF2C2C30),
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                        cornerRadius: 2,
                        cornerSmoothing: 0.6,
                      ),
                    ),
                  ),
                ),
              ),

              // Summary 3-Columns Row: Class | Passengers | Seats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _infoColumn('Class', widget.cabinClass, CrossAxisAlignment.start),
                    ),
                    Expanded(
                      child: _infoColumn(
                        'Passengers',
                        '${widget.passengerCount} Adult${widget.passengerCount > 1 ? 's' : ''}',
                        CrossAxisAlignment.center,
                      ),
                    ),
                    Expanded(
                      child: _infoColumn('Seats', seatsText, CrossAxisAlignment.end),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Total Payment Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total payment',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8E8E93),
                      ),
                    ),
                    Row(
                      children: [
                        if (_promoApplied) ...[
                          Text(
                            '\$$rawTotal',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.lineThrough,
                              color: const Color(0xFFA0A0A8),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          '\$$formattedPrice',
                          style: GoogleFonts.outfit(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Promocode Input Box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF1F2F6),
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                        cornerRadius: 12,
                        cornerSmoothing: 0.6,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.confirmation_number_outlined,
                        color: Color(0xFF9E9EA4),
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _promoController,
                          onSubmitted: (_) => _applyPromo(),
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter promocode',
                            hintStyle: GoogleFonts.outfit(
                              fontSize: 13,
                              color: const Color(0xFFA0A0A8),
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      if (_promoApplied)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primaryRed.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '-20%',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryRed,
                            ),
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: _applyPromo,
                          child: Text(
                            'Apply',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryRed,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Go to Payment Button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: SafeArea(
                  top: false,
                  child: BounceTap(
                    onTap: widget.onPaymentTap,
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        color: AppColors.primaryRed,
                        shadows: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.28),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                            cornerRadius: 16,
                            cornerSmoothing: 0.6,
                          ),
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.14),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Text(
                        'Go to payment',
                        style: GoogleFonts.outfit(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoColumn(
      String title, String value, CrossAxisAlignment alignment) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 11.5,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF8E8E93),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
