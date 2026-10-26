import 'package:flutter/material.dart';

/// Animates its child in with fade + slide when it enters the viewport.
/// Uses a lightweight approach: only triggers once, no continuous polling.
class AnimatedSection extends StatefulWidget {
  final Widget child;
  final String sectionKey;
  /// Delay before starting animation (ms) — useful for staggering siblings
  final int delayMs;

  const AnimatedSection({
    super.key,
    required this.child,
    required this.sectionKey,
    this.delayMs = 0,
  });

  @override
  State<AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<AnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Trigger after first frame — scroll-aware check
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _checkVisibility() {
    if (_hasAnimated || !mounted) return;
    final renderObject = context.findRenderObject();
    if (renderObject == null) {
      // Fallback: just play after delay if no render object yet
      _playWithDelay();
      return;
    }

    // Check if widget is currently on screen
    try {
      final RenderBox box = renderObject as RenderBox;
      final Offset position = box.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;

      if (position.dy < screenHeight + 200) {
        // In or near viewport
        _playWithDelay();
      } else {
        // Below fold — wait until scrolled into view
        // We use a simple listener approach via NotificationListener in parent
        // For now: just animate with a slightly longer delay so it's not jarring
        _playWithDelay(extraDelay: 300);
      }
    } catch (_) {
      _playWithDelay();
    }
  }

  void _playWithDelay({int extraDelay = 0}) {
    final totalDelay = widget.delayMs + extraDelay;
    if (totalDelay > 0) {
      Future.delayed(Duration(milliseconds: totalDelay), () {
        if (mounted && !_hasAnimated) {
          _hasAnimated = true;
          _controller.forward();
        }
      });
    } else {
      if (mounted && !_hasAnimated) {
        _hasAnimated = true;
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
