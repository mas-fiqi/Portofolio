import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/anti_gravity_background.dart';
import '../widgets/custom_nav_bar.dart';
import '../sections/home_section.dart';
import '../sections/about_section.dart';
import '../sections/skills_section.dart';
import '../sections/portfolio_section.dart';
import '../sections/research_section.dart';
import '../sections/certificate_section.dart';
import '../sections/experience_section.dart';
import '../sections/gallery_section.dart';
import '../sections/contact_section.dart';
import '../sections/footer_section.dart';
import '../core/constants/app_colors.dart';
import '../providers/portfolio_provider.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final ScrollController _pageScrollController = ScrollController();
  int _activeIndex = 0;

  @override
  void dispose() {
    _pageScrollController.dispose();
    super.dispose();
  }

  void _onMenuTap(int index) {
    setState(() {
      _activeIndex = index;
    });
    // Scroll page view back to top whenever switching pages
    if (_pageScrollController.hasClients) {
      _pageScrollController.jumpTo(0);
    }
  }

  Future<void> _downloadCv() async {
    final provider = context.read<PortfolioProvider>();
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
          content: Text('CV belum dikonfigurasi di dashboard admin.', style: GoogleFonts.plusJakartaSans()),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  Widget _buildCurrentPage(bool isMobile) {
    switch (_activeIndex) {
      case 0:
        return HomeSection(
          isMobile: isMobile,
          onViewPortfolioTap: () => _onMenuTap(3),
          onDownloadCvTap: _downloadCv,
          onContactTap: () => _onMenuTap(8),
        );
      case 1:
        return const AboutSection();
      case 2:
        return const SkillsSection();
      case 3:
        return const PortfolioSection();
      case 4:
        return const ResearchSection();
      case 5:
        return const CertificateSection();
      case 6:
        return const ExperienceSection();
      case 7:
        return const GallerySection();
      case 8:
        return const ContactSection();
      default:
        return HomeSection(
          isMobile: isMobile,
          onViewPortfolioTap: () => _onMenuTap(3),
          onDownloadCvTap: _downloadCv,
          onContactTap: () => _onMenuTap(8),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      breakpoints: const ScreenBreakpoints(
        desktop: 1200,
        tablet: 768,
        watch: 200,
      ),
      builder: (context, sizingInfo) {
        final isDesktop = sizingInfo.isDesktop;

        return Scaffold(
          backgroundColor: AppColors.background,
          endDrawer: isDesktop ? null : _buildMobileDrawer(),
          body: Stack(
            children: [
              // 1. Clean subtle background
              const Positioned.fill(
                child: AntiGravityBackground(),
              ),

              // 2. Tab-Based Page Container
              Positioned.fill(
                child: SingleChildScrollView(
                  controller: _pageScrollController,
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 84),
                      KeyedSubtree(
                        key: ValueKey<int>(_activeIndex),
                        child: _buildCurrentPage(!isDesktop),
                      ),
                      const SizedBox(height: 40),
                      const FooterSection(),
                    ],
                  ),
                ),
              ),

              // 3. Top Header Navigation Bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  bottom: false,
                  child: CustomNavBar(
                    isScrolled: true,
                    activeIndex: _activeIndex,
                    onMenuTap: _onMenuTap,
                    isMobile: !isDesktop,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileDrawer() {
    final menus = [
      'Beranda', 'Tentang', 'Keahlian', 'Portofolio', 'Riset', 'Sertifikat', 'Pengalaman', 'Galeri & Momen', 'Kontak'
    ];
    final profile = context.watch<PortfolioProvider>().profile;
    final displayName = profile.name.isNotEmpty ? profile.name : 'Mas Fiqi';

    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      displayName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.border, height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: menus.length,
                itemBuilder: (context, index) {
                  final isActive = _activeIndex == index;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                    leading: Icon(
                      _getIconForIndex(index),
                      color: isActive ? AppColors.primary : AppColors.textSecondary,
                      size: 20,
                    ),
                    title: Text(
                      menus[index],
                      style: GoogleFonts.plusJakartaSans(
                        color: isActive ? AppColors.primary : AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _onMenuTap(index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0: return Icons.home_outlined;
      case 1: return Icons.person_outline_rounded;
      case 2: return Icons.code_rounded;
      case 3: return Icons.folder_open_rounded;
      case 4: return Icons.menu_book_outlined;
      case 5: return Icons.workspace_premium_outlined;
      case 6: return Icons.work_outline_rounded;
      case 7: return Icons.photo_library_outlined;
      case 8: return Icons.mail_outline_rounded;
      default: return Icons.circle_outlined;
    }
  }
}
