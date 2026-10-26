import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants/app_colors.dart';
import '../providers/portfolio_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<PortfolioProvider>().profile;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.navy, // Premium deep navy background
        border: Border(
          top: BorderSide(color: Color(0xFF1E293B)),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (profile.whatsapp.isNotEmpty)
                    _buildSocialIcon(FontAwesomeIcons.whatsapp, () {
                      final wa = profile.whatsapp.replaceAll('+', '').replaceAll(' ', '').replaceAll('-', '');
                      _launchUrl(wa.startsWith('http') ? wa : 'https://wa.me/$wa');
                    }),
                  if (profile.instagramUrl.isNotEmpty)
                    _buildSocialIcon(FontAwesomeIcons.instagram, () => _launchUrl(profile.instagramUrl)),
                  if (profile.tiktokUrl.isNotEmpty)
                    _buildSocialIcon(FontAwesomeIcons.tiktok, () => _launchUrl(profile.tiktokUrl)),
                  if (profile.twitterUrl.isNotEmpty)
                    _buildSocialIcon(FontAwesomeIcons.xTwitter, () => _launchUrl(profile.twitterUrl)),
                  if (profile.githubUrl.isNotEmpty)
                    _buildSocialIcon(FontAwesomeIcons.github, () => _launchUrl(profile.githubUrl)),
                  if (profile.linkedinUrl.isNotEmpty)
                    _buildSocialIcon(FontAwesomeIcons.linkedinIn, () => _launchUrl(profile.linkedinUrl)),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Built with Flutter Web & Firebase Cloud',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF94A3B8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '© ${DateTime.now().year} ${profile.name.isNotEmpty ? profile.name : 'Mas Fiqi'}. All rights reserved.',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF64748B),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(dynamic icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: FaIcon(icon, color: const Color(0xFF94A3B8), size: 16),
      ),
    );
  }
}
