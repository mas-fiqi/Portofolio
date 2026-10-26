import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// Clean, subtle, modern architectural background for premium corporate & tech portfolio.
/// Features a pure light canvas (#F8FAFC) with soft ambient mesh glow and delicate grid points.
class AntiGravityBackground extends StatelessWidget {
  final ScrollController? scrollController;
  final bool isMobile;

  const AntiGravityBackground({
    super.key,
    this.scrollController,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.background,
      child: Stack(
        children: [
          // 1. Ultra-subtle ambient gradient mesh at top right (Primary/Indigo aura)
          Positioned(
            top: -120,
            right: -100,
            child: Container(
              width: isMobile ? 320 : 650,
              height: isMobile ? 320 : 650,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.07),
                    AppColors.accent.withValues(alpha: 0.03),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),

          // 2. Ultra-subtle ambient gradient mesh at mid left (Violet/Secondary aura)
          Positioned(
            top: 600,
            left: -150,
            child: Container(
              width: isMobile ? 280 : 550,
              height: isMobile ? 280 : 550,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
          ),

          // 3. Subtle dot matrix grid pattern
          CustomPaint(
            size: Size.infinite,
            painter: _DotGridPainter(),
          ),
        ],
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1).withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    const spacing = 36.0;
    const radius = 1.0;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
