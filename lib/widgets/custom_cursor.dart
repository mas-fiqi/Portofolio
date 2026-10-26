import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class CustomCursor extends StatefulWidget {
  final Widget child;

  const CustomCursor({super.key, required this.child});

  @override
  State<CustomCursor> createState() => _CustomCursorState();
}

class _CustomCursorState extends State<CustomCursor>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<Offset> _mousePosition =
      ValueNotifier(const Offset(-100, -100));

  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 1.0,
      upperBound: 1.8,
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _mousePosition.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent event) {
    _mousePosition.value = event.position;
  }

  void _onExit(PointerEvent event) {
    _mousePosition.value = const Offset(-100, -100);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    if (!isDesktop) return widget.child;

    return MouseRegion(
      onHover: _onHover,
      onExit: _onExit,
      cursor: SystemMouseCursors.none,
      child: Stack(
        children: [
          widget.child,
          ValueListenableBuilder<Offset>(
            valueListenable: _mousePosition,
            builder: (context, pos, _) {
              return Positioned(
                left: pos.dx - 12,
                top: pos.dy - 12,
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _scaleController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleController.value,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.08),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          width: 1.2,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CursorHoverDetector extends StatelessWidget {
  final Widget child;

  const CursorHoverDetector({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: (_) {
        final state = context.findAncestorStateOfType<_CustomCursorState>();
        state?._scaleController.forward();
      },
      onExit: (_) {
        final state = context.findAncestorStateOfType<_CustomCursorState>();
        state?._scaleController.reverse();
      },
      child: child,
    );
  }
}
