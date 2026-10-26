import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// Aurora Glass Background with dynamic soft gradient blobs, delicate dot matrix,
/// and subtle tech connection lines that create atmospheric depth without overpowering content.
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
        fit: StackFit.expand,
        children: [
          // 1. Soft Aurora Blob Top-Right (Lavender & Indigo glow)
          Positioned(
            top: -140,
            right: -100,
            child: IgnorePointer(
              child: Container(
                width: isMobile ? 380 : 750,
                height: isMobile ? 380 : 750,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFC7D2FE).withValues(alpha: 0.38), // Soft periwinkle/indigo
                      const Color(0xFFDDD6FE).withValues(alpha: 0.22), // Soft lavender
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // 2. Soft Aurora Blob Mid-Left (Pale Sky Blue & Violet glow)
          Positioned(
            top: 480,
            left: -160,
            child: IgnorePointer(
              child: Container(
                width: isMobile ? 320 : 680,
                height: isMobile ? 320 : 680,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFBAE6FD).withValues(alpha: 0.30), // Sky blue tint
                      const Color(0xFFE0E7FF).withValues(alpha: 0.18), // Pale indigo
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // 3. Ambient Aurora Blob Lower-Right (Gentle Violet tone)
          Positioned(
            bottom: 200,
            right: -120,
            child: IgnorePointer(
              child: Container(
                width: isMobile ? 260 : 540,
                height: isMobile ? 260 : 540,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFEDE9FE).withValues(alpha: 0.35),
                      const Color(0xFFF3E8FF).withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // 4. Tech Abstract Grid & Subtle Connection Constellations
          CustomPaint(
            size: Size.infinite,
            painter: _AuroraTechGridPainter(isMobile: isMobile),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for dot-grid with subtle tech constellation accent nodes
class _AuroraTechGridPainter extends CustomPainter {
  final bool isMobile;
  const _AuroraTechGridPainter({required this.isMobile});

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = const Color(0xFF94A3B8).withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;

    final accentDotPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.28)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.10)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final spacing = isMobile ? 40.0 : 48.0;
    const dotRadius = 1.0;

    // Draw regular dot matrix
    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        // Subtle pseudo-random highlight nodes for tech feel (determinate based on coordinates)
        final hash = ((math.sin(x * 12.9898 + y * 78.233) * 43758.5453).abs() % 1.0);
        if (hash > 0.985 && !isMobile) {
          canvas.drawCircle(Offset(x, y), dotRadius * 2.2, accentDotPaint);
          // Draw subtle faint cross or connector
          canvas.drawLine(Offset(x - 6, y), Offset(x + 6, y), linePaint);
          canvas.drawLine(Offset(x, y - 6), Offset(x, y + 6), linePaint);
        } else {
          canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _AuroraTechGridPainter oldDelegate) =>
      oldDelegate.isMobile != isMobile;
}
