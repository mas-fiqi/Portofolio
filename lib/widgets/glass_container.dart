import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'tilt_3d_card.dart';

/// Premium Card Component with Aurora Glass elevation, crisp border, and refined hover physics.
class GlassContainer extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? color;
  final Color? borderColor;
  final bool animateBorder;
  final bool enableTilt;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.color,
    this.borderColor,
    this.animateBorder = false,
    this.enableTilt = false,
  });

  @override
  State<GlassContainer> createState() => _GlassContainerState();
}

class _GlassContainerState extends State<GlassContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(16);

    Widget container = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        margin: widget.margin,
        width: widget.width,
        height: widget.height,
        padding: widget.padding ?? const EdgeInsets.all(24),
        transform: Matrix4.translationValues(0.0, _isHovered ? -3.0 : 0.0, 0.0),
        decoration: BoxDecoration(
          color: widget.color ?? (_isHovered ? const Color(0xFFFFFFFF) : const Color(0xF7FFFFFF)),
          borderRadius: radius,
          border: Border.all(
            color: _isHovered
                ? (widget.borderColor ?? AppColors.primary.withValues(alpha: 0.45))
                : (widget.borderColor ?? const Color(0xFFE2E8F0)),
            width: _isHovered ? 1.3 : 1.0,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.035),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: widget.child,
      ),
    );

    if (widget.enableTilt) {
      return Tilt3DCard(
        maxTiltAngle: 0.03,
        depth: 10,
        child: container,
      );
    }
    return container;
  }
}
