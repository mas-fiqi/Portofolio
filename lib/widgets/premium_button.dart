import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';

/// Premium CTA Button designed for luxury, executive, and tech-forward portfolios.
/// Supports Primary (filled indigo gradient), Secondary (clean white outlined card), and Ghost modes.
class PremiumButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isPrimary;
  final double width;
  final bool isLoading;

  const PremiumButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isPrimary = true,
    this.width = 180,
    this.isLoading = false,
  });

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onPressed();
        },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: widget.width,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: widget.isPrimary
                      ? LinearGradient(
                          colors: _isHovered
                              ? [const Color(0xFF4338CA), const Color(0xFF4F46E5)]
                              : [AppColors.primary, const Color(0xFF6366F1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: widget.isPrimary
                      ? null
                      : (_isHovered ? AppColors.backgroundAlt : AppColors.surface),
                  border: Border.all(
                    color: widget.isPrimary
                        ? Colors.transparent
                        : (_isHovered ? AppColors.primary : AppColors.border),
                    width: 1.2,
                  ),
                  boxShadow: widget.isPrimary
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: _isHovered ? 0.35 : 0.22),
                            blurRadius: _isHovered ? 20 : 12,
                            offset: Offset(0, _isHovered ? 6 : 3),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: const Color(0xFF64748B).withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.isLoading
                      ? [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                widget.isPrimary ? Colors.white : AppColors.primary,
                              ),
                            ),
                          ),
                        ]
                      : [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: widget.isPrimary
                                  ? Colors.white
                                  : (_isHovered ? AppColors.primary : AppColors.textPrimary),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            widget.text,
                            style: GoogleFonts.plusJakartaSans(
                              color: widget.isPrimary
                                  ? Colors.white
                                  : (_isHovered ? AppColors.primary : AppColors.textPrimary),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
