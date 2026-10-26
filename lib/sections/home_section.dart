import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/models/portfolio_data.dart';
import '../providers/portfolio_provider.dart';

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
    final provider = context.watch<PortfolioProvider>();
    final profile = provider.profile;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 60,
        vertical: isMobile ? 24 : 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              // 1. Two-Column Hero Core
              if (isMobile)
                _buildMobileLayout(context, profile)
              else
                _buildDesktopLayout(context, profile),

              SizedBox(height: isMobile ? 36 : 60),

              // 2. Horizontal Stats Panel (Matching Reference)
              _buildStatsPanel(context, provider, isMobile),

              const SizedBox(height: 32),

              // 3. Scroll Indicator (Matching Reference)
              _buildScrollIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ProfileData profile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Column: Typography, Bio, CTA Buttons, Tech Badges
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.only(right: 40),
            child: _buildLeftContent(context, true, profile),
          ),
        ),

        // Right Column: Portrait, Aurora Circles, Glow, Floating Glass Cards
        Expanded(
          flex: 6,
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
    // Split name into first part and highlighted gradient last part (e.g. "Moh. Rafiqi" + " Wahyudi")
    final nameParts = profile.name.trim().split(' ');
    String firstName = '';
    String lastName = '';
    if (nameParts.length > 1) {
      firstName = nameParts.sublist(0, nameParts.length - 1).join(' ');
      lastName = nameParts.last;
    } else {
      firstName = profile.name.isNotEmpty ? profile.name : 'Mas';
      lastName = 'Fiqi';
    }

    return Column(
      crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 1. Availability Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: profile.isAvailable
                ? const Color(0xFFE8FDF2)
                : const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: profile.isAvailable
                  ? const Color(0xFF86EFAC)
                  : const Color(0xFFFDE68A),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: (profile.isAvailable ? const Color(0xFF10B981) : const Color(0xFFF59E0B))
                    .withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
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
                      ? const Color(0xFF166534)
                      : const Color(0xFF92400E),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.15),

        const SizedBox(height: 20),

        // 2. Pre-title Text
        Text(
          'Halo, Selamat Datang di Portofolio',
          style: GoogleFonts.plusJakartaSans(
            fontSize: isDesktop ? 16 : 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF64748B),
            letterSpacing: 0.2,
          ),
        ).animate().fadeIn(delay: 100.ms),

        const SizedBox(height: 8),

        // 3. Dominant Name Headline with Exact Gradient on Last Name
        RichText(
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: '$firstName ',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isDesktop ? 48 : 34,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -1.0,
                  height: 1.15,
                ),
              ),
              WidgetSpan(
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    lastName,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isDesktop ? 48 : 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.0,
                      height: 1.15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

        const SizedBox(height: 12),

        // 4. Role & Specialization
        Text(
          profile.title.isNotEmpty
              ? profile.title
              : 'Software Engineer  •  AI & IoT Researcher  •  Mobile Specialist',
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isDesktop ? 18 : 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF4F46E5),
            letterSpacing: -0.2,
          ),
        ).animate().fadeIn(delay: 300.ms),

        const SizedBox(height: 14),

        // 5. Bio Description
        Text(
          profile.bio.isNotEmpty
              ? profile.bio
              : 'Saya membangun pengalaman digital yang indah, cerdas, dan berdampak dengan teknologi Flutter, Machine Learning, dan IoT.',
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: isDesktop ? 15 : 13.5,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF64748B),
            height: 1.6,
          ),
        ).animate().fadeIn(delay: 400.ms),

        const SizedBox(height: 20),

        // 6. Meta Tags: Location, Email, Experience
        Wrap(
          spacing: 12,
          runSpacing: 10,
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          children: [
            if (profile.location.isNotEmpty)
              _buildMetaTag(Icons.location_on_outlined, profile.location),
            if (profile.email.isNotEmpty)
              _buildMetaTag(Icons.mail_outline_rounded, profile.email),
          ],
        ).animate().fadeIn(delay: 500.ms),

        const SizedBox(height: 10),

        // Secondary meta row (Experience)
        if (profile.experience.isNotEmpty)
          _buildMetaTag(Icons.workspace_premium_outlined, '${profile.experience}++ Tahun Pengalaman')
              .animate().fadeIn(delay: 550.ms),

        const SizedBox(height: 28),

        // 7. CTA Buttons (Unduh CV, Lihat Portofolio, Hubungi Saya)
        Wrap(
          spacing: 14,
          runSpacing: 12,
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          children: [
            // Unduh CV / Resume (Filled Purple Gradient)
            ElevatedButton.icon(
              onPressed: onDownloadCvTap ?? () {},
              icon: const Icon(Icons.download_rounded, color: Colors.white, size: 18),
              label: Text(
                'Unduh CV / Resume',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                shadowColor: const Color(0xFF4F46E5).withValues(alpha: 0.35),
              ),
            ),

            // Lihat Portofolio (Outlined White)
            OutlinedButton.icon(
              onPressed: onViewPortfolioTap ?? () {},
              icon: const Icon(Icons.folder_open_rounded, color: Color(0xFF0F172A), size: 18),
              label: Text(
                'Lihat Portofolio',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: const Color(0xFF0F172A),
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            // Hubungi Saya (Outlined White)
            OutlinedButton.icon(
              onPressed: onContactTap ?? () {},
              icon: const Icon(Icons.send_rounded, color: Color(0xFF0F172A), size: 16),
              label: Text(
                'Hubungi Saya',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: const Color(0xFF0F172A),
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 600.ms),

        const SizedBox(height: 32),

        // 8. Tech Badges Section Label
        Align(
          alignment: isDesktop ? Alignment.centerLeft : Alignment.center,
          child: Text(
            'Teknologi yang saya gunakan',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Technology Badges (Flutter, Dart, Python, Machine Learning, IoT, Firebase)
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          children: const [
            _TechPill(label: 'Flutter', icon: Icons.flutter_dash_rounded, iconColor: Color(0xFF02569B)),
            _TechPill(label: 'Dart', icon: Icons.code_rounded, iconColor: Color(0xFF0175C2)),
            _TechPill(label: 'Python', icon: Icons.terminal_rounded, iconColor: Color(0xFF3776AB)),
            _TechPill(label: 'Machine Learning', icon: Icons.psychology_rounded, iconColor: Color(0xFF8B5CF6)),
            _TechPill(label: 'IoT System', icon: Icons.memory_rounded, iconColor: Color(0xFF0284C7)),
            _TechPill(label: 'Firebase', icon: Icons.local_fire_department_rounded, iconColor: Color(0xFFF5820D)),
          ],
        ).animate().fadeIn(delay: 700.ms),
      ],
    );
  }

  Widget _buildRightContent(BuildContext context, bool isDesktop, ProfileData profile) {
    final photoWidth = isDesktop ? 360.0 : 260.0;
    final photoHeight = isDesktop ? 500.0 : 360.0;

    return Center(
      child: SizedBox(
        width: isDesktop ? 580 : 340,
        height: isDesktop ? 540 : 420,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // 1. Abstract Background Layer: Large Aurora Circle Gradient
            Positioned(
              top: isDesktop ? 30 : 20,
              right: isDesktop ? 30 : 10,
              child: Container(
                width: isDesktop ? 380 : 280,
                height: isDesktop ? 380 : 280,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0x55C7D2FE), // Soft periwinkle
                      Color(0x44DDD6FE), // Soft lavender
                      Color(0x22BAE6FD), // Soft sky blue
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

            // 2. Abstract Geometric Lines & Technology Nodes (Tech Constellation)
            Positioned.fill(
              child: CustomPaint(
                painter: _HeroConstellationPainter(),
              ),
            ),

            // 3. Ambient Blue/Purple Laptop / Tech Screen Graphic in Background Left
            Positioned(
              left: isDesktop ? 10 : -10,
              bottom: isDesktop ? 70 : 40,
              child: Opacity(
                opacity: 0.75,
                child: Container(
                  width: isDesktop ? 150 : 100,
                  height: isDesktop ? 130 : 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF38BDF8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.terminal_rounded,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: isDesktop ? 48 : 32,
                    ),
                  ),
                ),
              ),
            ),

            // 4. Main Portrait Photo (Seamless Cutout integrating directly with template)
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: photoWidth,
                height: photoHeight,
                child: Image.asset(
                  'assets/images/profile_suit_cutout.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                  errorBuilder: (_, __, ___) {
                    if (profile.photoUrl.isNotEmpty && profile.photoUrl.startsWith('http')) {
                      return Image.network(
                        profile.photoUrl,
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                      );
                    }
                    return _buildPlaceholderPhoto();
                  },
                ),
              ),
            ),

            // ── Floating Glass Cards Matching Reference ──

            // Top-Left Floating Card: Clean Code / Better Solution
            Positioned(
              top: isDesktop ? 30 : 10,
              left: isDesktop ? -20 : -10,
              child: const _FloatingGlassCard(
                icon: Icons.code_rounded,
                iconColor: Color(0xFF6366F1),
                title: 'Clean Code',
                subtitle: 'Better Solution  ↗',
              ),
            ),

            // Mid-Left Floating Card: Pengalaman / 3++ Tahun
            Positioned(
              top: isDesktop ? 160 : 130,
              left: isDesktop ? -30 : -20,
              child: _FloatingGlassCard(
                icon: Icons.layers_rounded,
                iconColor: const Color(0xFF6366F1),
                title: 'Pengalaman',
                subtitle: '${profile.experience.isNotEmpty ? profile.experience : '3'}++ Tahun',
                extraWidget: Row(
                  children: const [
                    Icon(Icons.bar_chart_rounded, color: Color(0xFF8B5CF6), size: 16),
                  ],
                ),
              ),
            ),

            // Top-Right Floating Card: Solusi & Riset / 100% Verified
            Positioned(
              top: isDesktop ? 40 : 20,
              right: isDesktop ? -40 : -15,
              child: const _FloatingGlassCard(
                icon: Icons.psychology_rounded,
                iconColor: Color(0xFF8B5CF6),
                title: 'Solusi & Riset',
                subtitle: '100% Verified',
              ),
            ),

            // Mid-Right Floating Card: Idea to Impact / Digital Solution
            Positioned(
              top: isDesktop ? 170 : 140,
              right: isDesktop ? -30 : -10,
              child: const _FloatingGlassCard(
                icon: Icons.lightbulb_outline_rounded,
                iconColor: Color(0xFF0F172A),
                title: 'Idea to Impact',
                subtitle: 'Digital Solution',
              ),
            ),

            // Lower-Right Floating Card: Always Learning / Better Tomorrow
            Positioned(
              bottom: isDesktop ? 60 : 30,
              right: isDesktop ? -35 : -15,
              child: const _FloatingGlassCard(
                icon: Icons.rocket_launch_rounded,
                iconColor: Color(0xFF6366F1),
                title: 'Always Learning',
                subtitle: 'Better Tomorrow',
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 700.ms).scale(begin: const Offset(0.96, 0.96));
  }

  Widget _buildPlaceholderPhoto() {
    return Container(
      color: const Color(0xFFEEF2F6),
      child: const Center(
        child: Icon(Icons.person_rounded, size: 90, color: Color(0xFF94A3B8)),
      ),
    );
  }

  Widget _buildMetaTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF64748B), size: 15),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF0F172A),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── Horizontal Stats Panel (Matching Reference) ──
  Widget _buildStatsPanel(BuildContext context, PortfolioProvider provider, bool isMobile) {
    // Dynamic counts from real database data
    final projectsCount = provider.projects.length;
    final certificatesCount = provider.certificates.length;
    final researchCount = provider.research.length;
    final experienceCount = provider.experience.length;

    // Formatting with '+' suffix (or fallback to reference default minimums if empty)
    final projectStr = projectsCount > 0 ? '$projectsCount+' : '20+';
    final colabStr = experienceCount > 0 ? '$experienceCount+' : '10+';
    final certStr = certificatesCount > 0 ? '$certificatesCount+' : '15+';
    final researchStr = researchCount > 0 ? '$researchCount+' : '5+';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 18 : 36,
        vertical: isMobile ? 22 : 24,
      ),
      decoration: BoxDecoration(
        color: const Color(0xF7FFFFFF), // White semi-translucent glass
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 28,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildStatItem(Icons.folder_outlined, projectStr, 'Proyek Selesai', 'Website, Mobile App, IoT')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatItem(Icons.groups_outlined, colabStr, 'Kolaborasi', 'Tim & Organisasi')),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: Color(0xFFE2E8F0)),
                ),
                Row(
                  children: [
                    Expanded(child: _buildStatItem(Icons.workspace_premium_outlined, certStr, 'Sertifikat', 'Pelatihan & Kompetensi')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatItem(Icons.article_outlined, researchStr, 'Riset / Publikasi', 'Artikel & Karya Ilmiah')),
                  ],
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _buildStatItem(Icons.folder_outlined, projectStr, 'Proyek Selesai', 'Website, Mobile App, IoT')),
                _buildStatDivider(),
                Expanded(child: _buildStatItem(Icons.groups_outlined, colabStr, 'Kolaborasi', 'Tim & Organisasi')),
                _buildStatDivider(),
                Expanded(child: _buildStatItem(Icons.workspace_premium_outlined, certStr, 'Sertifikat', 'Pelatihan & Kompetensi')),
                _buildStatDivider(),
                Expanded(child: _buildStatItem(Icons.article_outlined, researchStr, 'Riset / Publikasi', 'Artikel & Karya Ilmiah')),
              ],
            ),
    ).animate().fadeIn(delay: 750.ms).slideY(begin: 0.1);
  }

  Widget _buildStatItem(IconData icon, String count, String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Lavender circle with purple icon
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFC7D2FE), width: 1.0),
          ),
          child: Icon(icon, color: const Color(0xFF4F46E5), size: 22),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count,
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF0F172A),
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF0F172A),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF64748B),
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFFE2E8F0),
    );
  }

  Widget _buildScrollIndicator() {
    return Column(
      children: [
        Container(
          width: 20,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF94A3B8), width: 1.5),
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF64748B),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Scroll untuk menjelajah',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF64748B),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B), size: 16),
      ],
    );
  }
}

// ── Floating Glass Card Component ──
class _FloatingGlassCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? extraWidget;

  const _FloatingGlassCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.extraWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xF5FFFFFF), // Ultra-clean glassmorphic white
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0F172A),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
          BoxShadow(
            color: Color(0x086366F1),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF64748B),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF0F172A),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (extraWidget != null) ...[
            const SizedBox(width: 8),
            extraWidget!,
          ],
        ],
      ),
    );
  }
}

// ── Technology Pill Badge Component ──
class _TechPill extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color iconColor;

  const _TechPill({
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  @override
  State<_TechPill> createState() => _TechPillState();
}

class _TechPillState extends State<_TechPill> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _isHovered ? const Color(0xFFEEF2FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
            width: 1.0,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x080F172A),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, color: widget.iconColor, size: 16),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: GoogleFonts.plusJakartaSans(
                color: _isHovered ? const Color(0xFF4F46E5) : const Color(0xFF0F172A),
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

// ── Custom Painter for Abstract Technology Constellation ──
class _HeroConstellationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF818CF8).withValues(alpha: 0.25)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = const Color(0xFF6366F1)
      ..style = PaintingStyle.fill;

    // Node coordinates relative to size
    final p1 = Offset(size.width * 0.20, size.height * 0.25);
    final p2 = Offset(size.width * 0.35, size.height * 0.15);
    final p3 = Offset(size.width * 0.70, size.height * 0.20);
    final p4 = Offset(size.width * 0.85, size.height * 0.40);
    final p5 = Offset(size.width * 0.25, size.height * 0.60);

    // Draw connecting lines
    canvas.drawLine(p1, p2, linePaint);
    canvas.drawLine(p2, p3, linePaint);
    canvas.drawLine(p3, p4, linePaint);
    canvas.drawLine(p1, p5, linePaint);

    // Draw small node dots
    for (final p in [p1, p2, p3, p4, p5]) {
      canvas.drawCircle(p, 2.5, dotPaint);
      canvas.drawCircle(
        p,
        6.0,
        Paint()
          ..color = const Color(0xFF6366F1).withValues(alpha: 0.15)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
