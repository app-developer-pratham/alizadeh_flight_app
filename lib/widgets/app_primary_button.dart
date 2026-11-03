import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'bounce_tap.dart';
export 'bounce_tap.dart';

/// A human-designed, premium primary action button.
/// Replaces artificial neon glow with tactile, crisp edge highlights,
/// realistic ambient shadow, and responsive micro-press physics.
class AppPrimaryButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onTap;
  final double height;
  final double? width;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double radius;
  final bool isLoading;

  const AppPrimaryButton({
    super.key,
    required this.text,
    this.icon,
    this.onTap,
    this.height = 54,
    this.width,
    this.backgroundColor = AppColors.primaryRed,
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.radius = 18,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return BounceTap(
      onTap: isLoading ? null : onTap,
      scaleDown: 0.97,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: backgroundColor,
          shadows: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.32),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: radius,
              cornerSmoothing: 0.6,
            ),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.14),
              width: 1.0,
            ),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: textColor, size: 19),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: GoogleFonts.outfit(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
