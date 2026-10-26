import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/glass_container.dart';
import '../widgets/premium_button.dart';
import '../core/constants/app_colors.dart';
import '../providers/portfolio_provider.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      width: double.infinity,
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          children: [
            // Section Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'HUBUNGI KAMI',
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
              'Mari Memulai Percakapan',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.8,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 550),
              child: Text(
                'Punya ide proyek, tawaran kerja sama, atau ingin berkonsultasi? Kirim pesan langsung atau hubungi melalui kontak di bawah ini.',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 50),

            ResponsiveBuilder(
              builder: (context, sizingInformation) {
                final isDesktop = sizingInformation.isDesktop || sizingInformation.isTablet;
                if (isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: _buildContactInfo(context)),
                      const SizedBox(width: 32),
                      const Expanded(flex: 6, child: _ContactForm()),
                    ],
                  );
                }
                return Column(
                  children: [
                    _buildContactInfo(context),
                    const SizedBox(height: 32),
                    const _ContactForm(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    final profile = context.read<PortfolioProvider>().profile;
    final provider = context.watch<PortfolioProvider>();
    final latestCv = provider.latestCv;
    final otherDocs = provider.publicDocuments
        .where((d) => d.category != 'cv')
        .toList();

    return GlassContainer(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Kontak',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Respon cepat melalui email atau pesan langsung via WhatsApp.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 24),

          _InfoItem(
            icon: Icons.mail_outline_rounded,
            label: 'Email',
            text: profile.email.isNotEmpty ? profile.email : 'email@domain.com',
          ),
          if (profile.whatsapp.isNotEmpty) ...[
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                final wa = profile.whatsapp.replaceAll('+', '').replaceAll(' ', '').replaceAll('-', '');
                _launchUrl(wa.startsWith('http') ? wa : 'https://wa.me/$wa');
              },
              child: _InfoItem(
                icon: FontAwesomeIcons.whatsapp,
                label: 'WhatsApp',
                text: profile.whatsapp,
              ),
            ),
          ],
          if (profile.phone.isNotEmpty) ...[
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _launchUrl('tel:${profile.phone}'),
              child: _InfoItem(
                icon: Icons.phone_android_rounded,
                label: 'Telepon Seluler',
                text: profile.phone,
              ),
            ),
          ],
          const SizedBox(height: 16),
          _InfoItem(
            icon: Icons.location_on_outlined,
            label: 'Lokasi',
            text: profile.location.isNotEmpty ? profile.location : 'Indonesia',
          ),
          const SizedBox(height: 28),

          // Download CV Document
          if (latestCv != null) ...[
            SizedBox(
              width: double.infinity,
              child: _DownloadButton(
                label: 'Unduh CV Lengkap',
                icon: Icons.download_rounded,
                url: latestCv.downloadUrl,
              ),
            ),
            const SizedBox(height: 10),
          ],

          if (otherDocs.isNotEmpty) ...[
            ...otherDocs.map((doc) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: double.infinity,
                child: _DownloadButton(
                  label: doc.description.isNotEmpty ? doc.description : doc.categoryLabel,
                  icon: Icons.picture_as_pdf_outlined,
                  url: doc.downloadUrl,
                ),
              ),
            )),
            const SizedBox(height: 10),
          ],

          const SizedBox(height: 16),
          Text(
            'JARINGAN & SOSIAL MEDIA',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              if (profile.whatsapp.isNotEmpty)
                _SocialIcon(
                  icon: FontAwesomeIcons.whatsapp,
                  onTap: () {
                    final wa = profile.whatsapp.replaceAll('+', '').replaceAll(' ', '').replaceAll('-', '');
                    _launchUrl(wa.startsWith('http') ? wa : 'https://wa.me/$wa');
                  },
                ),
              if (profile.instagramUrl.isNotEmpty)
                _SocialIcon(icon: FontAwesomeIcons.instagram, onTap: () => _launchUrl(profile.instagramUrl)),
              if (profile.tiktokUrl.isNotEmpty)
                _SocialIcon(icon: FontAwesomeIcons.tiktok, onTap: () => _launchUrl(profile.tiktokUrl)),
              if (profile.twitterUrl.isNotEmpty)
                _SocialIcon(icon: FontAwesomeIcons.xTwitter, onTap: () => _launchUrl(profile.twitterUrl)),
              if (profile.githubUrl.isNotEmpty)
                _SocialIcon(icon: FontAwesomeIcons.github, onTap: () => _launchUrl(profile.githubUrl)),
              if (profile.linkedinUrl.isNotEmpty)
                _SocialIcon(icon: FontAwesomeIcons.linkedinIn, onTap: () => _launchUrl(profile.linkedinUrl)),
              if (profile.whatsapp.isEmpty && profile.instagramUrl.isEmpty && profile.tiktokUrl.isEmpty && profile.githubUrl.isEmpty) ...[
                _SocialIcon(icon: FontAwesomeIcons.whatsapp, onTap: () {}),
                _SocialIcon(icon: FontAwesomeIcons.instagram, onTap: () {}),
                _SocialIcon(icon: FontAwesomeIcons.github, onTap: () {}),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _ContactForm extends StatefulWidget {
  const _ContactForm();

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isSuccess = false;

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isLoading = false;
        _isSuccess = true;
      });
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) setState(() => _isSuccess = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(36),
      child: _isSuccess
          ? _buildSuccessState()
          : Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Kirimkan Pesan Anda',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Formulir ini terkirim langsung ke pesan masuk admin.',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _buildTextField(
                    label: 'Nama Lengkap',
                    hint: 'Masukkan nama Anda',
                    icon: Icons.person_outline_rounded,
                    validator: (v) => v!.isEmpty ? 'Nama wajib diisi' : null,
                  ),
                  const SizedBox(height: 18),
                  _buildTextField(
                    label: 'Alamat Email',
                    hint: 'nama@domain.com',
                    icon: Icons.mail_outline_rounded,
                    validator: (v) => !v!.contains('@') ? 'Email tidak valid' : null,
                  ),
                  const SizedBox(height: 18),
                  _buildTextField(
                    label: 'Pesan / Pertanyaan',
                    hint: 'Tuliskan kebutuhan atau pertanyaan Anda di sini...',
                    icon: Icons.chat_bubble_outline_rounded,
                    maxLines: 4,
                    validator: (v) => v!.isEmpty ? 'Pesan wajib diisi' : null,
                  ),
                  const SizedBox(height: 28),
                  PremiumButton(
                    text: 'Kirim Pesan Sekarang',
                    icon: Icons.send_rounded,
                    isLoading: _isLoading,
                    onPressed: _submitForm,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSuccessState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: const Icon(Icons.check_rounded, color: Color(0xFF10B981), size: 48),
          ),
          const SizedBox(height: 20),
          Text(
            'Pesan Berhasil Terkirim!',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Terima kasih telah menghubungi. Saya akan merespon pesan Anda secepatnya.',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          maxLines: maxLines,
          style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontSize: 14),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(color: AppColors.textMuted, fontSize: 13),
            prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
            filled: true,
            fillColor: AppColors.backgroundAlt,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final dynamic icon;
  final String label;
  final String text;

  const _InfoItem({required this.icon, required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.backgroundAlt,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: icon is IconData
              ? Icon(icon as IconData, color: AppColors.primary, size: 20)
              : FaIcon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                text,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final dynamic icon;
  final VoidCallback onTap;

  const _SocialIcon({required this.icon, required this.onTap});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.primary : AppColors.backgroundAlt,
            shape: BoxShape.circle,
            border: Border.all(
              color: _isHovered ? AppColors.primary : AppColors.border,
            ),
          ),
          child: FaIcon(
            widget.icon,
            color: _isHovered ? Colors.white : AppColors.textSecondary,
            size: 16,
          ),
        ),
      ),
    );
  }
}

class _DownloadButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final String url;

  const _DownloadButton({
    required this.label,
    required this.icon,
    required this.url,
  });

  @override
  State<_DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<_DownloadButton> {
  bool _isHovered = false;

  Future<void> _launch() async {
    if (widget.url.isEmpty) return;
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _launch,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.primary.withValues(alpha: 0.08) : AppColors.backgroundAlt,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isHovered ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: AppColors.primary, size: 18),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
