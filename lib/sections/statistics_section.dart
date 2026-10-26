import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/glass_container.dart';
import '../core/constants/app_colors.dart';

class StatisticsSection extends StatelessWidget {
  const StatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      width: double.infinity,
      alignment: Alignment.center,
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: GlassContainer(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: sizingInformation.isMobile ? 32 : 60,
                runSpacing: 28,
                children: const [
                  _StatItem(title: 'Proyek Selesai', targetValue: 25, suffix: '+'),
                  _StatItem(title: 'Publikasi Riset', targetValue: 12, suffix: '+'),
                  _StatItem(title: 'Sertifikasi Resmi', targetValue: 30, suffix: '+'),
                  _StatItem(title: 'Tahun Pengalaman', targetValue: 3, suffix: '+'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatItem extends StatefulWidget {
  final String title;
  final int targetValue;
  final String suffix;

  const _StatItem({
    required this.title,
    required this.targetValue,
    this.suffix = '',
  });

  @override
  State<_StatItem> createState() => _StatItemState();
}

class _StatItemState extends State<_StatItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = IntTween(begin: 0, end: widget.targetValue).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) _controller.forward();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Text(
              '${_animation.value}${widget.suffix}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 38,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: -1.0,
              ),
            );
          },
        ),
        const SizedBox(height: 6),
        Text(
          widget.title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
