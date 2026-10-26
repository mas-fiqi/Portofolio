import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/models/portfolio_data.dart';
import '../providers/portfolio_provider.dart';
import '../widgets/premium_button.dart';

class HomeSection extends StatelessWidget {
  final VoidCallback? onDownloadCvTap;
  final VoidCallback? onViewPortfolioTap;
  final VoidCallback? onContactTap;
  final bool isMobile;

  const HomeSection({
    super.key,
    this.onDownloadCvTap,
    this.onViewPortfolioTap,
    this.onContactTap,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<PortfolioProvider>().profile;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 36 : 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: isMobile
              ? _buildMobileLayout(context, profile)
              : _buildDesktopLayout(context, profile),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ProfileData profile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.only(right: 60),
            child: _buildLeftContent(context, true, profile),
          ),
        ),
        Expanded(
          flex: 5,
          child: _buildRightContent(context, true, profile),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, ProfileData profile) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildRightContent(context, false, profile),
        const SizedBox(height: 36),
        _buildLeftContent(context, false, profile),
      ],
    );
  }

  Widget _buildLeftContent(BuildContext context, bool isDesktop, ProfileData profile) {
    return Column(
      crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Available for work indicator badge with Aurora Glow
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: profile.isAvailable
                ? const Color(0xFFF0FDF4)
                : const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: profile.isAvailable
                  ? const Color(0xFFBBF7D0)
                  : const Color(0xFFFDE68A),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: (profile.isAvailable ? const Color(0xFF10B981) : const Color(0xFFF59E0B))
                    .withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: profile.isAvailable
                      ? const Color(0xFF10B981)
                      : const Color(0xFFF59E0B),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (profile.isAvailable ? const Color(0xFF10B981) : const Color(0xFFF59E0B))
                          .withValues(alpha: 0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                profile.isAvailable
                    ? 'Tersedia untuk Pekerjaan / Kolaborasi'
                    : 'Sedang Berfokus pada Proyek',
                style: GoogleFonts.plusJakartaSans(
                  color: profile.isAvailable
                      ? const Color(0xFF166534)
                      : const Color(0xFF92400E),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.15),

        const SizedBox(height: 22),

        // Pre-title with Tech Icon
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.primary, size: 16),
            const SizedBox(width: 8),
            Text(
              'Halo, Selamat Datang di Portofolio',
              style: GoogleFonts.plusJakartaSans(
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 100.ms),

        const SizedBox(height: 10),

        // Main Title / Name with Rich Gradient Effect
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF312E81), Color(0xFF4F46E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            profile.name.isNotEmpty ? profile.name : 'Mas Fiqi',
            textAlign: isDesktop ? TextAlign.left : TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: isDesktop ? 56 : 36,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.2,
              height: 1.1,
            ),
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

        const SizedBox(height: 16),

        // Role & Specialization
        Text(
          profile.title.isNotEmpty
              ? profile.title
              : 'Software Engineer  •  AI & IoT Researcher  •  Mobile Specialist',
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isDesktop ? 20 : 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
            letterSpacing: -0.3,
          ),
        ).animate().fadeIn(delay: 300.ms),

        const SizedBox(height: 16),

        // Bio paragraph
        Text(
          profile.bio.isNotEmpty
              ? profile.bio
              : 'Mengembangkan solusi software berkualitas tinggi dengan fokus pada arsitektur scalable, pengalaman pengguna yang intuitif, serta integrasi teknologi modern.',
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isDesktop ? 16 : 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ).animate().fadeIn(delay: 400.ms),

        const SizedBox(height: 24),

        // Location & Email Badges
        Wrap(
          spacing: 12,
          runSpacing: 10,
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          children: [
            if (profile.location.isNotEmpty)
              _buildMetaTag(Icons.location_on_outlined, profile.location),
            if (profile.email.isNotEmpty)
              _buildMetaTag(Icons.mail_outline_rounded, profile.email),
            if (profile.experience.isNotEmpty)
              _buildMetaTag(Icons.workspace_premium_outlined, '${profile.experience}+ Tahun Pengalaman'),
          ],
        ).animate().fadeIn(delay: 500.ms),

        const SizedBox(height: 34),

        // Action Buttons with Aurora Depth
        Wrap(
          spacing: 14,
          runSpacing: 12,
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          children: [
            PremiumButton(
              text: 'Unduh CV / Resume',
              icon: Icons.download_rounded,
              isPrimary: true,
              width: 195,
              onPressed: onDownloadCvTap ?? () {},
            ),
            PremiumButton(
              text: 'Lihat Portofolio',
              icon: Icons.folder_open_rounded,
              isPrimary: false,
              width: 175,
              onPressed: onViewPortfolioTap ?? () {},
            ),
            PremiumButton(
              text: 'Hubungi Saya',
              icon: Icons.chat_bubble_outline_rounded,
              isPrimary: false,
              width: 165,
              onPressed: onContactTap ?? () {},
            ),
          ],
        ).animate().fadeIn(delay: 600.ms),

        const SizedBox(height: 36),

        // Technology pills with Hover State
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          children: [
            _TechChip(label: 'Flutter', icon: Icons.phone_android_rounded),
            _TechChip(label: 'Dart', icon: Icons.code_rounded),
            _TechChip(label: 'Python', icon: Icons.terminal_rounded),
            _TechChip(label: 'Machine Learning', icon: Icons.psychology_rounded),
            _TechChip(label: 'IoT System', icon: Icons.memory_rounded),
            _TechChip(label: 'Firebase Cloud', icon: Icons.cloud_done_rounded),
          ],
        ).animate().fadeIn(delay: 700.ms),
      ],
    );
  }

  Widget _buildRightContent(BuildContext context, bool isDesktop, ProfileData profile) {
    final imageWidth = isDesktop ? 390.0 : 260.0;
    final imageHeight = isDesktop ? 470.0 : 310.0;

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Aurora Glow Backdrop behind portrait
          Positioned(
            top: -20,
            left: -20,
            right: -20,
            bottom: -20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: const RadialGradient(
                  colors: [
                    Color(0x33C7D2FE),
                    Color(0x22DDD6FE),
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Background soft frame decoration with gradient border
          Container(
            width: imageWidth,
            height: imageHeight,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          ),

          // Main Profile Portrait
          Container(
            width: imageWidth,
            height: imageHeight,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.backgroundAlt,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: profile.photoUrl.isNotEmpty
                  ? (profile.photoUrl.startsWith('http')
                      ? Image.network(
                          profile.photoUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildPlaceholderAvatar(isDesktop),
                        )
                      : Image.asset(
                          profile.photoUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildPlaceholderAvatar(isDesktop),
                        ))
                  : _buildPlaceholderAvatar(isDesktop),
            ),
          ),

          // Aurora Glass Floating Metric Card 1 (Bottom Left)
          Positioned(
            bottom: isDesktop ? -20 : -15,
            left: isDesktop ? -30 : -10,
            child: _buildGlassMetricCard(
              title: 'Pengalaman Nyata',
              value: '${profile.experience.isNotEmpty ? profile.experience : '3'}+ Tahun',
              icon: Icons.trending_up_rounded,
              accentColor: AppColors.primary,
            ),
          ),

          // Aurora Glass Floating Metric Card 2 (Top Right)
          Positioned(
            top: isDesktop ? -20 : -15,
            right: isDesktop ? -30 : -10,
            child: _buildGlassMetricCard(
              title: 'Solusi & Riset',
              value: '100% Terverifikasi',
              icon: Icons.verified_rounded,
              accentColor: const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 700.ms).scale(begin: const Offset(0.96, 0.96));
  }

  Widget _buildPlaceholderAvatar(bool isDesktop) {
    return Container(
      color: const Color(0xFFEEF2F6),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          size: isDesktop ? 100 : 70,
          color: AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildGlassMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xF7FFFFFF), // Aurora semi-glass
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: accentColor.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 15),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TechChip extends StatefulWidget {
  final String label;
  final IconData icon;

  const _TechChip({required this.label, required this.icon});

  @override
  State<_TechChip> createState() => _TechChipState();
}

class _TechChipState extends State<_TechChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _isHovered ? const Color(0xFFEEF2FF) : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _isHovered ? AppColors.primary : AppColors.border,
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.14),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              size: 13,
              color: _isHovered ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              widget.label,
              style: GoogleFonts.plusJakartaSans(
                color: _isHovered ? AppColors.primary : AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
