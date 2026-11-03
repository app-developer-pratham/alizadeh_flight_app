import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const AppBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.maybePop(context),
      child: Container(
        width: 44,
        height: 44,
        decoration: ShapeDecoration(
          color: const Color(0xFF141214),
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 15,
              cornerSmoothing: 0.6,
            ),
            side: const BorderSide(
              color: Color(0xFF331417),
              width: 1.0,
            ),
          ),
        ),
        child: const Icon(
          Icons.chevron_left_rounded,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }
}

class AppProfileAvatar extends StatelessWidget {
  final bool hasNotification;

  const AppProfileAvatar({super.key, this.hasNotification = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: ShapeDecoration(
            color: const Color(0xFF1E1C24),
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 15,
                cornerSmoothing: 0.6,
              ),
              side: const BorderSide(
                color: Color(0xFF331417),
                width: 1.0,
              ),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
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
                size: 26,
              ),
            ),
          ),
        ),
        if (hasNotification)
          Positioned(
            top: 2,
            right: 2,
            child: Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: const Color(0xFFE52828),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF09090B),
                  width: 1.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

