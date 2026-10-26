import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/glass_container.dart';
import '../core/constants/app_colors.dart';
import '../providers/portfolio_provider.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      width: double.infinity,
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: ResponsiveBuilder(
          builder: (context, sizingInformation) {
            final isDesktop = sizingInformation.deviceScreenType == DeviceScreenType.desktop;
            return isDesktop ? _buildDesktop(context) : _buildMobile(context);
          },
        ),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 340,
          child: _buildProfileCard(context),
        ),
        const SizedBox(width: 50),
        Expanded(
          child: _buildRightContent(context),
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildProfileCard(context),
        const SizedBox(height: 40),
        _buildRightContent(context),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    final profile = context.watch<PortfolioProvider>().profile;
    return GlassContainer(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          // Profile Photo
          Container(
            width: double.infinity,
            height: 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.backgroundAlt,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: profile.photoUrl.isNotEmpty
                  ? (profile.photoUrl.startsWith('http')
                      ? Image.network(
                          profile.photoUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(Icons.person, size: 80, color: AppColors.textMuted),
                          ),
                        )
                      : Image.asset(
                          profile.photoUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(Icons.person, size: 80, color: AppColors.textMuted),
                          ),
                        ))
                  : const Center(
                      child: Icon(Icons.person, size: 80, color: AppColors.textMuted),
                    ),
            ),
          ).animate().fadeIn(duration: 500.ms),

          const SizedBox(height: 24),

          // Name
          Text(
            profile.name.isNotEmpty ? profile.name : 'Mas Fiqi',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 6),

          // Title
          Text(
            profile.title.isNotEmpty ? profile.title : 'Software Engineer & Researcher',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 20),

          // Core expertise tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: ['Flutter Architecture', 'Cloud & IoT', 'Machine Learning', 'API Systems']
                .map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundAlt,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRightContent(BuildContext context) {
    final profile = context.watch<PortfolioProvider>().profile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'TENTANG SAYA',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),

        const SizedBox(height: 12),

        Text(
          'Menciptakan Solusi Digital yang Elegan dan Skalabel',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.8,
            height: 1.25,
          ),
        ),

        const SizedBox(height: 16),

        Text(
          profile.bio.isNotEmpty
              ? profile.bio
              : 'Saya mendedikasikan keahlian dalam merancang dan mengembangkan aplikasi modern dengan standar industri tinggi. Berpengalaman dalam ekosistem Flutter, arsitektur backend, model kecerdasan buatan terapan, serta perangkat IoT untuk mendukung transformasi digital yang nyata.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.7,
          ),
        ),

        const SizedBox(height: 32),

        // Personal Information Card
        GlassContainer(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informasi Profesional',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 16),
              _infoRow('Email Kontak', profile.email.isNotEmpty ? profile.email : 'Belum diatur'),
              const SizedBox(height: 12),
              _infoRow('Domisili / Lokasi', profile.location.isNotEmpty ? profile.location : 'Indonesia'),
              const SizedBox(height: 12),
              _infoRow('Pengalaman Kerja', '${profile.experience.isNotEmpty ? profile.experience : '3'}+ Tahun'),
              const SizedBox(height: 12),
              _infoRow('Status Ketersediaan', profile.isAvailable ? 'Aktif — Terbuka untuk Kolaborasi' : 'Sedang Fokus pada Proyek'),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Vision & Mission Card
        GlassContainer(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Komitmen & Pendekatan Kerja',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _visionMissionRow(
                Icons.lightbulb_outline_rounded,
                'Visi Inovasi',
                'Menciptakan teknologi yang berpusat pada nilai guna, performa tinggi, dan kemudahan bagi pengguna akhir.',
              ),
              const SizedBox(height: 16),
              _visionMissionRow(
                Icons.task_alt_rounded,
                'Disiplin Eksekusi',
                'Menerapkan clean code, arsitektur teruji, integrasi berkesinambungan, dan estetika visual yang konsisten.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        const Text(': ', style: TextStyle(color: AppColors.textMuted)),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _visionMissionRow(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
