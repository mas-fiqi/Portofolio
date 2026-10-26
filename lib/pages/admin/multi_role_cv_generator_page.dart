import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';
import '../../core/constants/app_colors.dart';
import '../../services/multi_role_cv_pdf_service.dart';

class MultiRoleCvGeneratorWidget extends StatefulWidget {
  const MultiRoleCvGeneratorWidget({super.key});

  @override
  State<MultiRoleCvGeneratorWidget> createState() => _MultiRoleCvGeneratorWidgetState();
}

class _MultiRoleCvGeneratorWidgetState extends State<MultiRoleCvGeneratorWidget> {
  String _selectedRole = 'gudang'; // 'gudang', 'developer', 'admin'
  bool _isGenerating = false;

  late final _fullNameCtrl = TextEditingController(text: 'Moh. Rafiqi Wahyudi');
  late final _phoneCtrl = TextEditingController(text: '+62 87761571291');
  late final _emailCtrl = TextEditingController(text: 'cakfiqi2@gmail.com');
  late final _addressCtrl = TextEditingController(text: 'Pamekasan, Madura, Jawa Timur');
  late final _educationCtrl = TextEditingController(text: 'S1 Teknik Informatika - Universitas Islam Madura (2020 - 2024)');

  late final _titleCtrl = TextEditingController();
  late final _summaryCtrl = TextEditingController();
  late final _skillsCtrl = TextEditingController();

  // Experiences for active role
  final List<Map<String, TextEditingController>> _experienceCtrls = [];

  @override
  void initState() {
    super.initState();
    _applyRoleTemplate('gudang');
  }

  void _applyRoleTemplate(String role) {
    _selectedRole = role;
    _clearExperiences();

    if (role == 'gudang') {
      _titleCtrl.text = 'Staff Gudang / Logistik & Operasional';
      _summaryCtrl.text =
          'Pribadi yang berdedikasi tinggi, cekatan, dan memiliki kondisi fisik prima. Memiliki pengalaman dalam manajemen pergudangan, pencatatan stock opname, penataan tata letak barang secara rapi, serta penerimaan dan pengiriman barang sesuai SOP keselamatan kerja.';
      _skillsCtrl.text =
          'Manajemen Pergudangan (Warehouse), Stock Opname, Packing & Sorting Barang, Pencatatan Inventaris, Microsoft Excel, Disiplin Waktu, Kerja Tim & Stamina Fisik';

      _addExperience(
        title: 'Staff Operasional & Gudang Logistik',
        company: 'Logistik & Distribusi Madura',
        period: '2023 - 2025',
        description:
            'Bertanggung jawab atas penerimaan barang masuk, pemeriksaan kesesuaian surat jalan, penataan inventaris rak gudang, dan pemenuhan order harian dengan akurasi 99%.',
      );
      _addExperience(
        title: 'Koordinator Lapangan & Inventaris',
        company: 'Retail & Logistik Mandiri',
        period: '2022 - 2023',
        description:
            'Mengatur arus barang keluar-masuk, melakukan perhitungan stok berkala (cycle count), dan menjaga area kerja selalu bersih dan aman.',
      );
    } else if (role == 'developer') {
      _titleCtrl.text = 'Mobile Application Engineer & Software Developer';
      _summaryCtrl.text =
          'Software Engineer dengan spesialisasi pengembangan aplikasi mobile menggunakan Flutter & Dart. Berpengalaman dalam arsitektur scalable, state management, integrasi REST API/Firebase, serta riset IoT dan Machine Learning prediktif.';
      _skillsCtrl.text =
          'Flutter & Dart, REST API Integration, Firebase Cloud, Git & GitHub CI/CD, Clean Architecture, Problem Solving, State Management (Provider/Bloc)';

      _addExperience(
        title: 'Mobile Application Developer',
        company: 'Tech Solutions & Freelance',
        period: '2023 - Sekarang',
        description:
            'Merancang dan mengembangkan aplikasi seluler multi-platform dengan Flutter, mengoptimalkan rendering performa, dan mengintegrasikan sistem autentikasi serta basis data real-time.',
      );
      _addExperience(
        title: 'IoT & AI Researcher',
        company: 'Laboratorium Riset Informatika',
        period: '2022 - 2024',
        description:
            'Mengembangkan sistem pemantauan berbasis mikrokontroler ESP32 dan model Machine Learning prediktif untuk analisis data cerdas.',
      );
    } else {
      _titleCtrl.text = 'Staff Administrasi & Operasional Kantor';
      _summaryCtrl.text =
          'Lulusan S1 dengan ketelitian tinggi dan kemampuan komunikasi yang baik. Menguasai pengoperasian komputer, pengolahan data dokumen, surat-menyurat resmi, dan administrasi operasional secara terstruktur.';
      _skillsCtrl.text =
          'Administrasi Kantor, Microsoft Office (Word, Excel, PPT), Pengarsipan Dokumen, Komunikasi Profesional, Manajemen Waktu, Data Entry';

      _addExperience(
        title: 'Staff Administrasi & Data Entry',
        company: 'Kantor Layanan Publik / Swasta',
        period: '2023 - 2024',
        description:
            'Melakukan rekapitulasi data harian, penyusunan laporan operasional bulanan, dan pelayanan administrasi arsip secara rapi.',
      );
    }
    setState(() {});
  }

  void _clearExperiences() {
    for (final exp in _experienceCtrls) {
      exp['title']?.dispose();
      exp['company']?.dispose();
      exp['period']?.dispose();
      exp['description']?.dispose();
    }
    _experienceCtrls.clear();
  }

  void _addExperience({
    required String title,
    required String company,
    required String period,
    required String description,
  }) {
    _experienceCtrls.add({
      'title': TextEditingController(text: title),
      'company': TextEditingController(text: company),
      'period': TextEditingController(text: period),
      'description': TextEditingController(text: description),
    });
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _educationCtrl.dispose();
    _titleCtrl.dispose();
    _summaryCtrl.dispose();
    _skillsCtrl.dispose();
    _clearExperiences();
    super.dispose();
  }

  Future<void> _exportPdf({bool preview = false}) async {
    setState(() => _isGenerating = true);
    try {
      final skillList = _skillsCtrl.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final expList = _experienceCtrls.map((exp) {
        return {
          'title': exp['title']?.text.trim() ?? '',
          'company': exp['company']?.text.trim() ?? '',
          'period': exp['period']?.text.trim() ?? '',
          'description': exp['description']?.text.trim() ?? '',
        };
      }).toList();

      final pdfBytes = await MultiRoleCvPdfService.generateCvPdf(
        targetRole: _selectedRole,
        fullName: _fullNameCtrl.text.trim(),
        title: _titleCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        summary: _summaryCtrl.text.trim(),
        education: _educationCtrl.text.trim(),
        skills: skillList,
        experiences: expList,
      );

      final filename = 'CV_${_fullNameCtrl.text.trim().replaceAll(' ', '_')}_${_selectedRole.toUpperCase()}.pdf';

      if (preview) {
        await Printing.layoutPdf(
          onLayout: (_) async => pdfBytes,
          name: filename,
        );
      } else {
        await Printing.sharePdf(
          bytes: pdfBytes,
          filename: filename,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat CV PDF: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 900),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Role Selector
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.badge_outlined, color: Color(0xFF818CF8), size: 24),
                    const SizedBox(width: 10),
                    Text(
                      'Pilih Template CV Berdasarkan Posisi / Lowongan:',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    _buildRoleChip('gudang', '📦 Staff Gudang & Logistik', Icons.inventory_2_outlined),
                    _buildRoleChip('developer', '💻 Software / Mobile Developer', Icons.code_rounded),
                    _buildRoleChip('admin', '📑 Administrasi & Umum', Icons.description_outlined),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _isGenerating ? null : () => _exportPdf(preview: false),
                icon: const Icon(Icons.download_rounded, size: 18),
                label: Text(
                  _isGenerating ? 'Membuat PDF...' : 'Download CV Resmi (PDF)',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _isGenerating ? null : () => _exportPdf(preview: true),
                icon: const Icon(Icons.visibility_outlined, size: 18),
                label: Text(
                  'Pratinjau / Cetak',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Detail Section
          _buildCard(
            title: '1. Informasi Pribadi & Target Posisi',
            icon: Icons.person_outline,
            children: [
              _buildInput('Nama Lengkap', _fullNameCtrl),
              const SizedBox(height: 12),
              _buildInput('Judul Profesi pada CV', _titleCtrl),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildInput('Nomor Telepon / WhatsApp', _phoneCtrl)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildInput('Email Kontak', _emailCtrl)),
                ],
              ),
              const SizedBox(height: 12),
              _buildInput('Alamat Domisili', _addressCtrl),
              const SizedBox(height: 12),
              _buildInput('Pendidikan Terakhir', _educationCtrl),
            ],
          ),

          const SizedBox(height: 20),

          _buildCard(
            title: '2. Ringkasan Profil Profesional (Deskripsi Diri)',
            icon: Icons.article_outlined,
            children: [
              _buildInput('Ringkasan', _summaryCtrl, maxLines: 4),
            ],
          ),

          const SizedBox(height: 20),

          _buildCard(
            title: '3. Keahlian Khusus (Pisahkan dengan tanda koma)',
            icon: Icons.star_outline_rounded,
            children: [
              _buildInput('Daftar Keahlian', _skillsCtrl, maxLines: 2),
            ],
          ),

          const SizedBox(height: 20),

          _buildCard(
            title: '4. Riwayat Pengalaman Kerja yang Relevan',
            icon: Icons.work_outline_rounded,
            children: [
              ..._experienceCtrls.map((exp) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildInput('Jabatan / Posisi', exp['title']!)),
                          const SizedBox(width: 10),
                          Expanded(child: _buildInput('Periode (cth: 2023 - 2024)', exp['period']!)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildInput('Perusahaan / Instansi', exp['company']!),
                      const SizedBox(height: 10),
                      _buildInput('Tanggung Jawab & Prestasi', exp['description']!, maxLines: 2),
                    ],
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildRoleChip(String role, String label, IconData icon) {
    final isSelected = _selectedRole == role;
    return ChoiceChip(
      selected: isSelected,
      onSelected: (_) => _applyRoleTemplate(role),
      label: Text(label),
      avatar: Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.white70),
      labelStyle: GoogleFonts.plusJakartaSans(
        color: isSelected ? Colors.white : Colors.white70,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        fontSize: 13,
      ),
      backgroundColor: const Color(0xFF0F172A),
      selectedColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: isSelected ? AppColors.primary : Colors.white24),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF0F081C).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF58DBFF), size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController ctrl, {int maxLines = 1, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(color: Colors.white60, fontSize: 12),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 13.5),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.04),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white12)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white12)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF58DBFF))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          ),
        ),
      ],
    );
  }
}
