import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';

class CustomNavBar extends StatelessWidget {
  final bool isScrolled;
  final Function(int) onMenuTap;
  final int activeIndex;
  final bool isMobile;

  const CustomNavBar({
    super.key,
    required this.isScrolled,
    required this.onMenuTap,
    required this.activeIndex,
    this.isMobile = false,
  });

  final List<String> menus = const [
    'Beranda', 'Tentang', 'Keahlian', 'Portofolio',
    'Riset', 'Sertifikat', 'Pengalaman', 'Galeri & Momen', 'Kontak',
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: 12),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 28,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: isScrolled
            ? AppColors.surface.withValues(alpha: 0.97)
            : AppColors.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isScrolled ? AppColors.border : AppColors.borderLight,
          width: 1,
        ),
        boxShadow: isScrolled
            ? [
                BoxShadow(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: isMobile ? _buildMobileBar(context) : _buildDesktopBar(context),
    );
  }

  Widget _buildDesktopBar(BuildContext context) {
    return Row(
      children: [
        // Logo / Brand
        _Brand(),
        const SizedBox(width: 40),

        // Nav Items
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              menus.length,
              (i) => _NavItem(
                label: menus[i],
                isActive: activeIndex == i,
                onTap: () => onMenuTap(i),
              ),
            ),
          ),
        ),

        // CTA
        _ContactCTA(onTap: () => onMenuTap(8)),
      ],
    );
  }

  Widget _buildMobileBar(BuildContext context) {
    return Row(
      children: [
        _Brand(),
        const Spacer(),
        Builder(
          builder: (ctx) => GestureDetector(
            onTap: () => Scaffold.of(ctx).openEndDrawer(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.backgroundAlt,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.menu_rounded, color: AppColors.textPrimary, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Center(
            child: Text(
              'F',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Fiqi',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        Text(
          '.dev',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.primary.withValues(alpha: 0.08)
                : (_hovered ? AppColors.backgroundAlt : Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
              color: widget.isActive
                  ? AppColors.primary
                  : (_hovered ? AppColors.textPrimary : AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactCTA extends StatefulWidget {
  final VoidCallback onTap;
  const _ContactCTA({required this.onTap});

  @override
  State<_ContactCTA> createState() => _ContactCTAState();
}

class _ContactCTAState extends State<_ContactCTA> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: _hovered
                ? const LinearGradient(
                    colors: [Color(0xFF4338CA), Color(0xFF6366F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(10),
            boxShadow: _hovered
                ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 4))]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.send_rounded, color: Colors.white, size: 14),
              const SizedBox(width: 7),
              Text(
                'Hubungi Saya',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
