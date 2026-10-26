import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../widgets/custom_cursor.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isOutlined;

  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isOutlined = false,
    this.isLoading = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
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
    return CursorHoverDetector(
      child: MouseRegion(
        onEnter: (_) {
          if (widget.isLoading) return;
          setState(() => _isHovered = true);
          _controller.forward();
        },
        onExit: (_) {
          if (widget.isLoading) return;
          setState(() => _isHovered = false);
          _controller.reverse();
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: InkWell(
            onTap: widget.isLoading ? null : widget.onPressed,
            borderRadius: BorderRadius.circular(30),
            splashColor: widget.isOutlined ? AppColors.primary.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.3),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: widget.isOutlined
                    ? Colors.transparent
                    : (_isHovered ? AppColors.accent : AppColors.primary),
                border: Border.all(
                  color: widget.isOutlined
                      ? (_isHovered ? AppColors.accent : AppColors.primary)
                      : Colors.transparent,
                  width: 2,
                ),
                boxShadow: _isHovered && !widget.isOutlined
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        )
                      ]
                    : [],
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: widget.isOutlined
                                ? (_isHovered ? AppColors.accent : AppColors.primary)
                                : Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.text,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: widget.isOutlined
                                    ? (_isHovered ? AppColors.accent : AppColors.primary)
                                    : Colors.white,
                              ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
