import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants/app_colors.dart';
import '../core/models/portfolio_data.dart';
import '../providers/portfolio_provider.dart';

class GallerySection extends StatefulWidget {
  const GallerySection({super.key});

  @override
  State<GallerySection> createState() => _GallerySectionState();
}

class _GallerySectionState extends State<GallerySection> {
  String _selectedCategory = 'Semua';
  String _selectedType = 'Semua'; // 'Semua', 'Foto', 'Video'

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();
    final mediaList = provider.galleryMedia;
    final legacyImages = provider.gallery;

    // Combine legacy images into GalleryMediaData if needed
    List<GalleryMediaData> combinedList = [...mediaList];
    if (combinedList.isEmpty && legacyImages.isNotEmpty) {
      combinedList = legacyImages
          .map((url) => GalleryMediaData(
                id: url,
                title: 'Dokumentasi Visual',
                description: 'Momen berharga kegiatan dan riset.',
                mediaUrl: url,
                mediaType: 'photo',
                category: 'Aktivitas',
                thumbnailUrl: url,
                createdAt: DateTime.now(),
              ))
          .toList();
    }

    // Filter by type & category
    final filteredList = combinedList.where((item) {
      if (_selectedType == 'Foto' && item.isVideo) return false;
      if (_selectedType == 'Video' && !item.isVideo) return false;
      if (_selectedCategory != 'Semua' && item.category != _selectedCategory) {
        return false;
      }
      return true;
    }).toList();

    // Extract unique categories
    final categories = ['Semua', ...{
      for (final item in combinedList)
        if (item.category.trim().isNotEmpty) item.category.trim()
    }];

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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wb_sunny_rounded, color: AppColors.primary, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    'HEALING & MOMEN BERHARGA',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Galeri Liburan, Kuliah & Aktivitas',
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
              constraints: const BoxConstraints(maxWidth: 620),
              child: Text(
                'Kumpulan kenangan visual berupa foto dan video liburan santai, petualangan trip bersama kawan, masa perkuliahan, dan aktivitas seru lainnya.',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 36),

            // Filter Tabs (Type: Semua | Foto | Video) + Categories
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Type Filter: Semua / Foto / Video
                _buildFilterChip(
                  label: 'Semua Media',
                  icon: Icons.grid_view_rounded,
                  isSelected: _selectedType == 'Semua' && _selectedCategory == 'Semua',
                  onTap: () {
                    setState(() {
                      _selectedType = 'Semua';
                      _selectedCategory = 'Semua';
                    });
                  },
                ),
                _buildFilterChip(
                  label: 'Video',
                  icon: Icons.play_circle_fill_rounded,
                  isSelected: _selectedType == 'Video',
                  onTap: () {
                    setState(() {
                      _selectedType = _selectedType == 'Video' ? 'Semua' : 'Video';
                    });
                  },
                ),
                _buildFilterChip(
                  label: 'Foto',
                  icon: Icons.image_rounded,
                  isSelected: _selectedType == 'Foto',
                  onTap: () {
                    setState(() {
                      _selectedType = _selectedType == 'Foto' ? 'Semua' : 'Foto';
                    });
                  },
                ),
                if (categories.length > 1) ...[
                  const SizedBox(width: 8),
                  Container(width: 1, height: 24, color: AppColors.border),
                  const SizedBox(width: 8),
                  ...categories.where((c) => c != 'Semua').map((cat) => _buildFilterChip(
                        label: cat,
                        icon: Icons.tag_rounded,
                        isSelected: _selectedCategory == cat,
                        onTap: () {
                          setState(() {
                            _selectedCategory = _selectedCategory == cat ? 'Semua' : cat;
                          });
                        },
                      )),
                ],
              ],
            ),

            const SizedBox(height: 40),

            if (filteredList.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.perm_media_outlined, size: 64, color: AppColors.textMuted),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada momen untuk filter ini',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tambahkan momen liburan, video Threads / YouTube / direct link melalui Dashboard Admin.',
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

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.88,
                    ),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return _MediaCard(
                        item: item,
                        onTap: () => _openMediaModal(context, item),
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

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openMediaModal(BuildContext context, GalleryMediaData item) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => _MediaViewerDialog(item: item),
    );
  }
}

class _MediaCard extends StatefulWidget {
  final GalleryMediaData item;
  final VoidCallback onTap;

  const _MediaCard({required this.item, required this.onTap});

  @override
  State<_MediaCard> createState() => _MediaCardState();
}

class _MediaCardState extends State<_MediaCard> {
  bool _isHovered = false;

  String _getImagePreview() {
    if (widget.item.thumbnailUrl.isNotEmpty) return widget.item.thumbnailUrl;
    if (!widget.item.isVideo && widget.item.mediaUrl.isNotEmpty) return widget.item.mediaUrl;
    
    // YouTube thumbnail generator
    final url = widget.item.mediaUrl;
    if (url.contains('youtube.com/watch?v=')) {
      final id = url.split('v=')[1].split('&')[0];
      return 'https://img.youtube.com/vi/$id/hqdefault.jpg';
    } else if (url.contains('youtu.be/')) {
      final id = url.split('youtu.be/')[1].split('?')[0];
      return 'https://img.youtube.com/vi/$id/hqdefault.jpg';
    }
    
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final preview = _getImagePreview();
    final isVideo = widget.item.isVideo;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? AppColors.primary : AppColors.border,
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: _isHovered ? AppColors.cardShadowHover : AppColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Media Preview Stack
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (preview.isNotEmpty && preview.startsWith('http'))
                        Image.network(
                          preview,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildFallbackBackground(),
                        )
                      else
                        _buildFallbackBackground(),

                      // Subtle Dark Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: isVideo ? 0.65 : 0.4),
                            ],
                          ),
                        ),
                      ),

                      // Platform Badge (Top Left)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isVideo ? Icons.play_arrow_rounded : Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.item.platform,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Category Tag (Top Right)
                      if (widget.item.category.isNotEmpty)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              widget.item.category,
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),

                      // Video Play Triangle Button (Center)
                      if (isVideo)
                        Center(
                          child: AnimatedScale(
                            scale: _isHovered ? 1.15 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFEF4444).withValues(alpha: 0.92),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                  BoxShadow(
                                    color: const Color(0xFFEF4444).withValues(alpha: 0.4),
                                    blurRadius: 18,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ),
                        )
                      else if (_isHovered)
                        Center(
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            child: const Icon(
                              Icons.zoom_in_rounded,
                              color: AppColors.primary,
                              size: 26,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Info Content
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.item.description.isNotEmpty
                                ? widget.item.description
                                : (isVideo ? 'Klik untuk memutar video.' : 'Klik untuk melihat foto.'),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isVideo ? 'Tonton Video' : 'Lihat Foto Penuh',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          Icon(
                            isVideo ? Icons.play_circle_outline_rounded : Icons.arrow_outward_rounded,
                            size: 16,
                            color: AppColors.primary,
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
      ),
    );
  }

  Widget _buildFallbackBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          widget.item.isVideo ? Icons.videocam_rounded : Icons.photo_library_rounded,
          color: Colors.white30,
          size: 48,
        ),
      ),
    );
  }
}

class _MediaViewerDialog extends StatelessWidget {
  final GalleryMediaData item;

  const _MediaViewerDialog({required this.item});

  Future<void> _launchExternalUrl(BuildContext context) async {
    final uri = Uri.tryParse(item.mediaUrl);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka link media')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVideo = item.isVideo;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 32,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Modal
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isVideo ? const Color(0xFFEF4444) : AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(isVideo ? Icons.play_arrow_rounded : Icons.image_rounded, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            item.platform,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.title,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: Colors.white12),

              // Content Media Display
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 500, minHeight: 280),
                child: Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: isVideo ? _buildVideoViewer(context) : _buildPhotoViewer(),
                ),
              ),

              const Divider(height: 1, color: Colors.white12),

              // Footer Description & External Open Button
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.category.isNotEmpty)
                            Text(
                              'Kategori: ${item.category}',
                              style: GoogleFonts.plusJakartaSans(color: const Color(0xFF58DBFF), fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          if (item.description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              item.description,
                              style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 13, height: 1.4),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isVideo ? const Color(0xFFEF4444) : AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => _launchExternalUrl(context),
                      icon: Icon(isVideo ? Icons.smart_display_rounded : Icons.open_in_new_rounded, size: 16),
                      label: Text(
                        isVideo ? 'Buka di ${item.platform}' : 'Buka Asli',
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoViewer() {
    return Image.network(
      item.mediaUrl,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.broken_image_rounded, color: Colors.white30, size: 54),
            SizedBox(height: 10),
            Text('Gagal memuat foto', style: TextStyle(color: Colors.white54)),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoViewer(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (item.thumbnailUrl.isNotEmpty)
          Image.network(
            item.thumbnailUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        Container(
          color: Colors.black54,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.5),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 44),
                  onPressed: () => _launchExternalUrl(context),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Klik tombol Play untuk membuka video',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Mendukung link Threads, YouTube, TikTok, Instagram & Direct Video.',
                style: GoogleFonts.plusJakartaSans(color: Colors.white54, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
