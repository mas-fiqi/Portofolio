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
        horizontal: isMobile ? 24 : 80,
        vertical: isMobile ? 40 : 80,
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
        // Available for work indicator badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: profile.isAvailable
                ? const Color(0xFFECFDF5)
                : const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: profile.isAvailable
                  ? const Color(0xFFA7F3D0)
                  : const Color(0xFFFDE68A),
              width: 1,
            ),
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
                ),
              ),
              const SizedBox(width: 8),
              Text(
                profile.isAvailable
                    ? 'Tersedia untuk Pekerjaan / Kolaborasi'
                    : 'Sedang Berfokus pada Proyek',
                style: GoogleFonts.plusJakartaSans(
                  color: profile.isAvailable
                      ? const Color(0xFF065F46)
                      : const Color(0xFF92400E),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.15),

        const SizedBox(height: 24),

        // Pre-title
        Text(
          'Halo, Selamat Datang di Portofolio',
          style: GoogleFonts.plusJakartaSans(
            fontSize: isDesktop ? 18 : 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ).animate().fadeIn(delay: 100.ms),

        const SizedBox(height: 8),

        // Main Title / Name
        Text(
          profile.name.isNotEmpty ? profile.name : 'Mas Fiqi',
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isDesktop ? 56 : 36,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -1.2,
            height: 1.1,
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

        const SizedBox(height: 36),

        // Action Buttons
        Wrap(
          spacing: 14,
          runSpacing: 12,
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          children: [
            PremiumButton(
              text: 'Unduh CV / Resume',
              icon: Icons.download_rounded,
              isPrimary: true,
              width: 190,
              onPressed: onDownloadCvTap ?? () {},
            ),
            PremiumButton(
              text: 'Lihat Portofolio',
              icon: Icons.folder_open_rounded,
              isPrimary: false,
              width: 170,
              onPressed: onViewPortfolioTap ?? () {},
            ),
            PremiumButton(
              text: 'Hubungi Saya',
              icon: Icons.chat_bubble_outline_rounded,
              isPrimary: false,
              width: 160,
              onPressed: onContactTap ?? () {},
            ),
          ],
        ).animate().fadeIn(delay: 600.ms),

        const SizedBox(height: 36),

        // Technology pills
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          children: [
            _buildTechBadge('Flutter'),
            _buildTechBadge('Dart'),
            _buildTechBadge('Python'),
            _buildTechBadge('Machine Learning'),
            _buildTechBadge('IoT System'),
            _buildTechBadge('Firebase Cloud'),
          ],
        ).animate().fadeIn(delay: 700.ms),
      ],
    );
  }

  Widget _buildRightContent(BuildContext context, bool isDesktop, ProfileData profile) {
    final imageWidth = isDesktop ? 380.0 : 250.0;
    final imageHeight = isDesktop ? 460.0 : 300.0;

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Background soft frame decoration
          Container(
            width: imageWidth,
            height: imageHeight,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
          ),

          // Main Profile Portrait
          Container(
            width: imageWidth,
            height: imageHeight,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: AppColors.backgroundAlt,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
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

          // Executive Floating Metric Card 1 (Bottom Left)
          Positioned(
            bottom: isDesktop ? -20 : -15,
            left: isDesktop ? -30 : -10,
            child: _buildMetricCard(
              title: 'Pengalaman',
              value: '${profile.experience.isNotEmpty ? profile.experience : '3'}+ Tahun',
              icon: Icons.trending_up_rounded,
            ),
          ),

          // Executive Floating Metric Card 2 (Top Right)
          Positioned(
            top: isDesktop ? -20 : -15,
            right: isDesktop ? -30 : -10,
            child: _buildMetricCard(
              title: 'Solusi & Riset',
              value: '100% Verified',
              icon: Icons.verified_outlined,
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

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
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
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 15),
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

  Widget _buildTechBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
