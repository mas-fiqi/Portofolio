import 'package:flutter/material.dart';

class Tilt3DCard extends StatefulWidget {
  final Widget child;
  final double maxTiltAngle;
  final double depth;

  const Tilt3DCard({
    super.key,
    required this.child,
    this.maxTiltAngle = 0.1,
    this.depth = 20.0,
  });

  @override
  State<Tilt3DCard> createState() => _Tilt3DCardState();
}

class _Tilt3DCardState extends State<Tilt3DCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tiltAnimation;
  
  Offset _localMousePos = Offset.zero;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _tiltAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
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
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
          _localMousePos = Offset.zero;
        });
        _controller.reverse();
      },
      onHover: (details) {
        if (mounted) {
          setState(() {
            _localMousePos = details.localPosition;
          });
        }
      },
      child: Builder(
        builder: (context) {
          return AnimatedBuilder(
            animation: _tiltAnimation,
            builder: (context, child) {
              final val = _tiltAnimation.value;
              
              double rotateX = 0.0;
              double rotateY = 0.0;
              
              if (_isHovered) {
                final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
                if (renderBox != null && renderBox.hasSize) {
                  final size = renderBox.size;
                  final center = Offset(size.width / 2, size.height / 2);
                  final dx = _localMousePos.dx - center.dx;
                  final dy = _localMousePos.dy - center.dy;
                  
                  // Avoid division by zero
                  if (center.dy != 0) rotateX = (dy / center.dy) * widget.maxTiltAngle;
                  if (center.dx != 0) rotateY = -(dx / center.dx) * widget.maxTiltAngle;
                }
              }

              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateX(rotateX * val)
                  ..rotateY(rotateY * val)
                  ..multiply(Matrix4.translationValues(
                    -rotateY * widget.depth * val,
                    rotateX * widget.depth * val,
                    _isHovered ? widget.depth * val : 0.0,
                  )),
                alignment: Alignment.center,
                child: widget.child,
              );
            },
          );
        },
      ),
    );
  }
}
