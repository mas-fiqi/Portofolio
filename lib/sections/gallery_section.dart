import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../providers/portfolio_provider.dart';

class GallerySection extends StatelessWidget {
  const GallerySection({super.key});

  @override
  Widget build(BuildContext context) {
    final images = context.watch<PortfolioProvider>().gallery;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      width: double.infinity,
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
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
                'DOKUMENTASI VISUAL',
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
              'Galeri Kegiatan & Aktivitas',
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
              constraints: const BoxConstraints(maxWidth: 600),
              child: Text(
                'Momen berharga saat riset, hackathon, konferensi teknologi, dan workshop pengembangan.',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 50),

            if (images.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.photo_library_outlined, size: 64, color: AppColors.textMuted),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada foto yang ditambahkan',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Anda dapat mengunggah atau menambahkan tautan foto melalui Dashboard Admin.',
                      style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ResponsiveBuilder(
                builder: (context, sizingInformation) {
                  int crossAxisCount = 3;
                  if (sizingInformation.isMobile) {
                    crossAxisCount = 1;
                  } else if (sizingInformation.isTablet) {
                    crossAxisCount = 2;
                  }

                  return MasonryGridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return _GalleryItem(
                        imagePath: images[index],
                        onTap: () => _showFullscreen(context, images, index),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showFullscreen(BuildContext context, List<String> images, int initialIndex) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => _FullscreenGalleryDialog(images: images, initialIndex: initialIndex),
    );
  }
}

class _GalleryItem extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;

  const _GalleryItem({required this.imagePath, required this.onTap});

  @override
  State<_GalleryItem> createState() => _GalleryItemState();
}

class _GalleryItemState extends State<_GalleryItem> {
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
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? AppColors.primary : AppColors.border,
              width: 1.2,
            ),
            boxShadow: _isHovered ? AppColors.cardShadowHover : AppColors.cardShadow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                widget.imagePath.startsWith('http')
                    ? Image.network(
                        widget.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 220,
                          color: AppColors.backgroundAlt,
                          child: const Center(
                            child: Icon(Icons.broken_image_outlined, color: AppColors.textMuted, size: 40),
                          ),
                        ),
                      )
                    : Container(
                        height: 220,
                        color: AppColors.backgroundAlt,
                        child: const Center(
                          child: Icon(Icons.image_outlined, color: AppColors.textMuted, size: 40),
                        ),
                      ),
                if (_isHovered)
                  Positioned.fill(
                    child: Container(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      child: const Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          child: Icon(Icons.zoom_in_rounded, color: AppColors.primary, size: 20),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FullscreenGalleryDialog extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const _FullscreenGalleryDialog({required this.images, required this.initialIndex});

  @override
  State<_FullscreenGalleryDialog> createState() => _FullscreenGalleryDialogState();
}

class _FullscreenGalleryDialogState extends State<_FullscreenGalleryDialog> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.images[index],
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 80, color: Colors.white54),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
