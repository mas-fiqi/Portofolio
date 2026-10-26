import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants/app_colors.dart';
import '../core/models/portfolio_data.dart';
import '../providers/portfolio_provider.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  bool _copiedEmail = false;

  void _copyEmail(String email) {
    if (email.isEmpty) return;
    Clipboard.setData(ClipboardData(text: email));
    setState(() => _copiedEmail = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Email $email berhasil disalin ke clipboard!'),
        backgroundColor: const Color(0xFF6366F1),
        duration: const Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _copiedEmail = false);
    });
  }

  Future<void> _downloadCv(PortfolioProvider provider) async {
    final latestCv = provider.latestCv;
    if (latestCv != null && latestCv.downloadUrl.isNotEmpty) {
      final uri = Uri.parse(latestCv.downloadUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    }
    final profile = provider.profile;
    if (profile.githubUrl.isNotEmpty) {
      final uri = Uri.parse(profile.githubUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'CV belum dikonfigurasi di dashboard admin.',
            style: GoogleFonts.plusJakartaSans(),
          ),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();
    final profile = provider.profile;

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240),
        child: ResponsiveBuilder(
          builder: (context, sizingInfo) {
            final isDesktop = sizingInfo.isDesktop;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Two-Column Main Content (Left: Profile Card, Right: Details)
                if (isDesktop)
                  _buildDesktopLayout(context, provider, profile)
                else
                  _buildMobileLayout(context, provider, profile),

                const SizedBox(height: 36),

                // 2. Horizontal Stats Panel
                _buildStatsPanel(context, provider, !isDesktop),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, PortfolioProvider provider, ProfileData profile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: Profile Card (Fixed Width ~ 350px)
        SizedBox(
          width: 350,
          child: _buildProfileCard(context, provider, profile, isDesktop: true),
        ),
        const SizedBox(width: 32),
        // Right Column: Headline, Bio Card, Info & Commitment Cards
        Expanded(
          child: _buildRightContent(context, profile, isDesktop: true),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, PortfolioProvider provider, ProfileData profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildProfileCard(context, provider, profile, isDesktop: false),
        const SizedBox(height: 32),
        _buildRightContent(context, profile, isDesktop: false),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // LEFT: PROFILE CARD
  // ─────────────────────────────────────────────────────────────────────────────

  Widget _buildProfileCard(BuildContext context, PortfolioProvider provider, ProfileData profile, {required bool isDesktop}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Portrait Photo in Studio Rounded Container with Ambient Aurora Circle
          Container(
            width: double.infinity,
            height: 340,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFEEF2FF), // Soft indigo tint
                  Color(0xFFF5F3FF), // Soft lavender tint
                  Color(0xFFE0F2FE), // Pale sky
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.center,
              children: [
                // Soft background radial aura
                Positioned(
                  top: 20,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFFC7D2FE).withValues(alpha: 0.5),
                          const Color(0xFFDDD6FE).withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Main Photo
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: _buildPhotoWidget(profile.photoUrl),
                  ),
                ),

                // Floating Mini Badge bottom-left: Flutter Developer
                if (profile.miniRoleBadge.isNotEmpty)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.bolt_rounded,
                              color: Color(0xFF6366F1),
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                profile.miniRoleBadge,
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF0F172A),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Full Name
          Text(
            profile.name.isNotEmpty ? profile.name : 'Moh. Rafiqi Wahyudi',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 6),

          // Role / Title
          Text(
            profile.title.isNotEmpty
                ? profile.title
                : 'Software Engineer  •  AI & IoT Researcher  •  Mobile Specialist',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6366F1),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 18),

          // Skill Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: (profile.profileSkillTags.isNotEmpty
                    ? profile.profileSkillTags
                    : ['Flutter', 'Machine Learning', 'IoT System', 'Cloud & Firebase'])
                .map((tag) => _buildProfileSkillChip(tag))
                .toList(),
          ),

          const SizedBox(height: 22),

          // Unduh CV / Resume Button
          SizedBox(
            width: double.infinity,
            height: 46,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => _downloadCv(provider),
                icon: const Icon(Icons.download_rounded, color: Colors.white, size: 18),
                label: Text(
                  'Unduh CV / Resume',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoWidget(String photoUrl) {
    if (photoUrl.isNotEmpty) {
      if (photoUrl.startsWith('http')) {
        return Image.network(
          photoUrl,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => _buildFallbackPhoto(),
        );
      }
      return Image.asset(
        photoUrl,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, __, ___) => _buildFallbackPhoto(),
      );
    }
    return _buildFallbackPhoto();
  }

  Widget _buildFallbackPhoto() {
    return Container(
      color: const Color(0xFFEEF2FF),
      child: const Center(
        child: Icon(Icons.person_rounded, size: 90, color: Color(0xFF818CF8)),
      ),
    );
  }

  Widget _buildProfileSkillChip(String tag) {
    IconData icon = Icons.code_rounded;
    Color iconColor = const Color(0xFF6366F1);

    final lower = tag.toLowerCase();
    if (lower.contains('flutter')) {
      icon = Icons.flutter_dash_rounded;
      iconColor = const Color(0xFF02569B);
    } else if (lower.contains('machine') || lower.contains('ai') || lower.contains('learning')) {
      icon = Icons.psychology_rounded;
      iconColor = const Color(0xFF8B5CF6);
    } else if (lower.contains('iot') || lower.contains('esp')) {
      icon = Icons.memory_rounded;
      iconColor = const Color(0xFF0284C7);
    } else if (lower.contains('cloud') || lower.contains('firebase')) {
      icon = Icons.cloud_done_rounded;
      iconColor = const Color(0xFF4F46E5);
    } else if (lower.contains('python')) {
      icon = Icons.terminal_rounded;
      iconColor = const Color(0xFF3776AB);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 14),
          const SizedBox(width: 6),
          Text(
            tag,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF1E293B),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // RIGHT: HEADLINE, BIO, INFO & COMMITMENTS
  // ─────────────────────────────────────────────────────────────────────────────

  Widget _buildRightContent(BuildContext context, ProfileData profile, {required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Badge "TENTANG SAYA"
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFC7D2FE), width: 1.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_outline_rounded, color: Color(0xFF6366F1), size: 14),
              const SizedBox(width: 6),
              Text(
                profile.aboutBadge.isNotEmpty ? profile.aboutBadge : 'TENTANG SAYA',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF4F46E5),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 2. Main Title with Gradient Highlight
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${profile.aboutHeadline.isNotEmpty ? profile.aboutHeadline : 'Menciptakan Solusi Digital yang'} ',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isDesktop ? 32 : 24,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.8,
                  height: 1.25,
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
                    profile.aboutHeadlineGradient.isNotEmpty
                        ? profile.aboutHeadlineGradient
                        : 'Elegan dan Skalabel',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: isDesktop ? 32 : 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                      height: 1.25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // 3. Subheadline / Lead Paragraph
        Text(
          profile.aboutSubheadline.isNotEmpty
              ? profile.aboutSubheadline
              : 'Saya membangun pengalaman digital yang indah, cerdas, dan berdampak dengan teknologi Flutter, Machine Learning, dan IoT.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: isDesktop ? 14.5 : 13.5,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF64748B),
            height: 1.6,
          ),
        ),

        const SizedBox(height: 24),

        // 4. Bio Card with Availability Status Badge
        _buildBioCard(profile),

        const SizedBox(height: 24),

        // 5. Professional Info & Work Commitment Cards (Side by Side on Desktop)
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildInfoCard(profile)),
              const SizedBox(width: 20),
              Expanded(child: _buildCommitmentCard(profile)),
            ],
          )
        else
          Column(
            children: [
              _buildInfoCard(profile),
              const SizedBox(height: 20),
              _buildCommitmentCard(profile),
            ],
          ),
      ],
    );
  }

  // ── Card Biografi / Tentang Saya ──
  Widget _buildBioCard(ProfileData profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title with icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.person_pin_rounded,
                      color: Color(0xFF6366F1),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    profile.aboutCardTitle.isNotEmpty ? profile.aboutCardTitle : 'Tentang Saya',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),

              // Availability Badge on the right
              if (profile.showAvailabilityBadge)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8FDF2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF86EFAC), width: 1.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        profile.aboutStatusText.isNotEmpty
                            ? profile.aboutStatusText
                            : 'Tersedia untuk Pekerjaan / Kolaborasi',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF15803D),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 18),

          // Paragraph 1
          Text(
            profile.aboutBioParagraph1.isNotEmpty
                ? profile.aboutBioParagraph1
                : 'Saya adalah seorang Software Engineer yang berfokus pada pengembangan aplikasi berbasis Flutter, serta memiliki minat pada bidang Machine Learning dan Internet of Things (IoT). Saya senang membangun solusi digital yang tidak hanya fungsional, tetapi juga memiliki desain yang elegan, scalable, dan memberikan dampak nyata.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF475569),
              height: 1.65,
            ),
          ),

          if (profile.aboutBioParagraph2.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              profile.aboutBioParagraph2,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF475569),
                height: 1.65,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Card Informasi Profesional ──
  Widget _buildInfoCard(ProfileData profile) {
    final email = profile.email.isNotEmpty ? profile.email : 'cakfiqi2@gmail.com';
    final location = profile.location.isNotEmpty ? profile.location : 'Pamekasan, Madura, Indonesia';
    final exp = '${profile.experience.isNotEmpty ? profile.experience : '3'}+ Tahun';
    final status = profile.isAvailable ? 'Aktif — Terbuka untuk Kolaborasi' : 'Sedang Fokus pada Proyek';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.business_center_rounded,
                  color: Color(0xFF6366F1),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Informasi Profesional',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Email Row with Copy Button
          _buildInfoItem(
            icon: Icons.mail_outline_rounded,
            label: 'Email',
            value: email,
            action: InkWell(
              onTap: () => _copyEmail(email),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  _copiedEmail ? Icons.check_rounded : Icons.copy_rounded,
                  size: 15,
                  color: _copiedEmail ? const Color(0xFF10B981) : const Color(0xFF64748B),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Lokasi
          _buildInfoItem(
            icon: Icons.location_on_outlined,
            label: 'Lokasi',
            value: location,
          ),
          const SizedBox(height: 14),

          // Pengalaman
          _buildInfoItem(
            icon: Icons.calendar_today_outlined,
            label: 'Pengalaman',
            value: exp,
          ),
          const SizedBox(height: 14),

          // Status
          _buildInfoItem(
            icon: Icons.person_outline_rounded,
            label: 'Status',
            value: status,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    Widget? action,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFF6366F1), size: 17),
        const SizedBox(width: 10),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF64748B),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF0F172A),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (action != null) action,
      ],
    );
  }

  // ── Card Komitmen & Pendekatan Kerja ──
  Widget _buildCommitmentCard(ProfileData profile) {
    final items = profile.commitments.isNotEmpty
        ? profile.commitments
        : const [
            CommitmentItem(
              iconName: 'rocket_launch_rounded',
              title: 'Inovatif',
              description: 'Menciptakan solusi yang berpusat pada pengguna dan bernilai nyata.',
            ),
            CommitmentItem(
              iconName: 'code_rounded',
              title: 'Disiplin & Terstruktur',
              description: 'Menulis kode yang bersih, terstruktur, dan mudah dikembangkan.',
            ),
            CommitmentItem(
              iconName: 'groups_rounded',
              title: 'Kolaboratif',
              description: 'Terbuka terhadap ide baru dan senang bekerja dalam tim lintas disiplin.',
            ),
          ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.track_changes_rounded,
                  color: Color(0xFF6366F1),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Komitmen & Pendekatan Kerja',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ...items.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: idx == items.length - 1 ? 0 : 16),
              child: _buildCommitmentRow(item),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCommitmentRow(CommitmentItem item) {
    IconData icon = Icons.rocket_launch_rounded;
    if (item.iconName.contains('code')) {
      icon = Icons.code_rounded;
    } else if (item.iconName.contains('group') || item.iconName.contains('people')) {
      icon = Icons.groups_rounded;
    } else if (item.iconName.contains('lightbulb')) {
      icon = Icons.lightbulb_outline_rounded;
    } else if (item.iconName.contains('check') || item.iconName.contains('task')) {
      icon = Icons.task_alt_rounded;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF6366F1), size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF0F172A),
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.description,
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF64748B),
                  fontSize: 12.5,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // BOTTOM: PANEL STATISTIK PENCAPAIAN
  // ─────────────────────────────────────────────────────────────────────────────

  Widget _buildStatsPanel(BuildContext context, PortfolioProvider provider, bool isMobile) {
    final projectsCount = provider.projects.length;
    final certificatesCount = provider.certificates.length;
    final researchCount = provider.research.length;
    final experienceCount = provider.experience.length;

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.folder_open_rounded,
                        number: projectStr,
                        title: 'Proyek Selesai',
                        subtitle: 'Website, Mobile App, IoT',
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.people_outline_rounded,
                        number: colabStr,
                        title: 'Kolaborasi',
                        subtitle: 'Tim & Organisasi',
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: Color(0xFFF1F5F9), height: 1),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.workspace_premium_outlined,
                        number: certStr,
                        title: 'Sertifikat',
                        subtitle: 'Pelatihan & Kompetensi',
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.article_outlined,
                        number: researchStr,
                        title: 'Riset / Publikasi',
                        subtitle: 'Artikel & Karya Ilmiah',
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.folder_open_rounded,
                    number: projectStr,
                    title: 'Proyek Selesai',
                    subtitle: 'Website, Mobile App, IoT',
                  ),
                ),
                _buildStatDivider(),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.people_outline_rounded,
                    number: colabStr,
                    title: 'Kolaborasi',
                    subtitle: 'Tim & Organisasi',
                  ),
                ),
                _buildStatDivider(),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.workspace_premium_outlined,
                    number: certStr,
                    title: 'Sertifikat',
                    subtitle: 'Pelatihan & Kompetensi',
                  ),
                ),
                _buildStatDivider(),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.article_outlined,
                    number: researchStr,
                    title: 'Riset / Publikasi',
                    subtitle: 'Artikel & Karya Ilmiah',
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String number,
    required String title,
    required String subtitle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Icon(icon, color: const Color(0xFF6366F1), size: 24),
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              number,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
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
      height: 44,
      color: const Color(0xFFE2E8F0),
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
