import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../../core/constants/app_colors.dart';
import '../../services/cover_letter_pdf_service.dart';

class CoverLetterGeneratorWidget extends StatefulWidget {
  const CoverLetterGeneratorWidget({super.key});

  @override
  State<CoverLetterGeneratorWidget> createState() => _CoverLetterGeneratorWidgetState();
}

class _CoverLetterGeneratorWidgetState extends State<CoverLetterGeneratorWidget> {
  // Controller Form
  late TextEditingController _kotaTanggalCtrl;
  late TextEditingController _perihalCtrl;
  late TextEditingController _namaPerusahaanCtrl;
  late TextEditingController _alamatPerusahaanCtrl;
  late TextEditingController _posisiCtrl;

  // Data Diri (Default diisi dari dokumen foto user)
  late TextEditingController _namaLengkapCtrl;
  late TextEditingController _ttlCtrl;
  late TextEditingController _jenisKelaminCtrl;
  late TextEditingController _kewarganegaraanCtrl;
  late TextEditingController _alamatPelamarCtrl;
  late TextEditingController _teleponCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _pendidikanCtrl;
  late TextEditingController _ipkCtrl;
  late TextEditingController _minatBidangCtrl;

  // Daftar Lampiran
  final List<TextEditingController> _lampiranCtrls = [];

  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    final todayStr = DateFormat('d MMMM yyyy', 'id_ID').format(DateTime.now());
    _kotaTanggalCtrl = TextEditingController(text: 'Pamekasan, $todayStr');
    _perihalCtrl = TextEditingController(text: 'Lamaran Pekerjaan');
    _namaPerusahaanCtrl = TextEditingController(text: 'Bapak/Ibu HRD PT. ...');
    _alamatPerusahaanCtrl = TextEditingController(text: '');
    _posisiCtrl = TextEditingController(text: 'Mobile Developer / Software Engineer');

    _namaLengkapCtrl = TextEditingController(text: 'Moh. Rafiqi Wahyudi');
    _ttlCtrl = TextEditingController(text: 'Pamekasan, 27 Oktober 2001');
    _jenisKelaminCtrl = TextEditingController(text: 'Laki-laki');
    _kewarganegaraanCtrl = TextEditingController(text: 'Indonesia');
    _alamatPelamarCtrl = TextEditingController(text: 'Pamekasan, Pademawu, Tanjung Utara');
    _teleponCtrl = TextEditingController(text: '+62 87761571291');
    _emailCtrl = TextEditingController(text: 'cakfiqi2@gmail.com');
    _pendidikanCtrl = TextEditingController(text: 'S1 Teknik Informatika, Universitas Islam Madura');
    _ipkCtrl = TextEditingController(text: '3,55 dari 4,00');
    _minatBidangCtrl = TextEditingController(
      text:
          'Saya memiliki minat di bidang teknologi informasi, khususnya pengembangan website dan aplikasi mobile. Saya terbiasa mempelajari teknologi baru, bekerja dengan teliti, dan berusaha menyelesaikan pekerjaan secara bertanggung jawab. Saya berharap kemampuan dan latar belakang pendidikan saya dapat memberikan kontribusi bagi perusahaan/instansi.',
    );

    final defaultLampiran = [
      'Daftar riwayat hidup (CV)',
      'Fotokopi KTP',
      'Fotokopi Kartu Keluarga (KK)',
      'Surat Keterangan Catatan Kepolisian (SKCK)',
      'Dokumen/surat keterangan sipil yang tersedia',
      'Transkrip nilai S1 (ijazah belum diterbitkan)',
      'Dokumen pendukung lainnya sesuai persyaratan',
    ];

    for (final item in defaultLampiran) {
      _lampiranCtrls.add(TextEditingController(text: item));
    }
  }

  @override
  void dispose() {
    _kotaTanggalCtrl.dispose();
    _perihalCtrl.dispose();
    _namaPerusahaanCtrl.dispose();
    _alamatPerusahaanCtrl.dispose();
    _posisiCtrl.dispose();
    _namaLengkapCtrl.dispose();
    _ttlCtrl.dispose();
    _jenisKelaminCtrl.dispose();
    _kewarganegaraanCtrl.dispose();
    _alamatPelamarCtrl.dispose();
    _teleponCtrl.dispose();
    _emailCtrl.dispose();
    _pendidikanCtrl.dispose();
    _ipkCtrl.dispose();
    _minatBidangCtrl.dispose();
    for (final c in _lampiranCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _exportPdf({bool preview = false}) async {
    setState(() => _isGenerating = true);
    try {
      final lampiranList = _lampiranCtrls.map((c) => c.text.trim()).where((t) => t.isNotEmpty).toList();

      final pdfBytes = await CoverLetterPdfService.generatePdf(
        kotaTanggal: _kotaTanggalCtrl.text.trim(),
        perihal: _perihalCtrl.text.trim(),
        namaPerusahaan: _namaPerusahaanCtrl.text.trim(),
        alamatPerusahaan: _alamatPerusahaanCtrl.text.trim(),
        posisi: _posisiCtrl.text.trim(),
        namaLengkap: _namaLengkapCtrl.text.trim(),
        tempatTanggalLahir: _ttlCtrl.text.trim(),
        jenisKelamin: _jenisKelaminCtrl.text.trim(),
        kewarganegaraan: _kewarganegaraanCtrl.text.trim(),
        alamatPelamar: _alamatPelamarCtrl.text.trim(),
        nomorTelepon: _teleponCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        pendidikan: _pendidikanCtrl.text.trim(),
        ipk: _ipkCtrl.text.trim(),
        minatBidang: _minatBidangCtrl.text.trim(),
        lampiran: lampiranList,
      );

      final filename = 'Surat_Lamaran_${_namaLengkapCtrl.text.trim().replaceAll(' ', '_')}.pdf';

      if (preview) {
        await Printing.layoutPdf(
          onLayout: (format) async => pdfBytes,
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
          SnackBar(content: Text('Gagal membuat PDF: $e'), backgroundColor: Colors.red),
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
          // Banner Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_stories_outlined, color: AppColors.primary, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Generator Surat Lamaran Instan (Format Resmi)',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Cukup ubah nama perusahaan, posisi, atau tanggal saat di jalan, lalu klik "Download PDF". Format langsung rapi dan siap dikirim!',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white70,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Action Buttons Top
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _isGenerating ? null : () => _exportPdf(preview: false),
                icon: const Icon(Icons.download_rounded, size: 18),
                label: Text(
                  _isGenerating ? 'Memproses PDF...' : 'Download PDF Resmi',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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

          // Section 1: Detail Tujuan Lowongan
          _buildCard(
            title: '1. Detail Perusahaan & Posisi',
            icon: Icons.business_outlined,
            children: [
              _buildInput('Kota & Tanggal Surat', _kotaTanggalCtrl, hint: 'Contoh: Pamekasan, 25 Oktober 2026'),
              const SizedBox(height: 12),
              _buildInput('Nama Perusahaan / Ditujukan Kepada', _namaPerusahaanCtrl,
                  hint: 'Contoh: Bapak/Ibu HRD PT. Teknologi Maju Bersama'),
              const SizedBox(height: 12),
              _buildInput('Alamat Perusahaan (Opsional)', _alamatPerusahaanCtrl,
                  hint: 'Kosongkan jika tidak tahu alamat lengkapnya'),
              const SizedBox(height: 12),
              _buildInput('Posisi yang Dilamar', _posisiCtrl,
                  hint: 'Contoh: Mobile Developer / Web Developer'),
            ],
          ),

          const SizedBox(height: 20),

          // Section 2: Data Diri Pelamar
          _buildCard(
            title: '2. Data Diri Pelamar',
            icon: Icons.person_outline_rounded,
            children: [
              _buildInput('Nama Lengkap', _namaLengkapCtrl),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildInput('Tempat, Tanggal Lahir', _ttlCtrl)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildInput('Jenis Kelamin', _jenisKelaminCtrl)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildInput('Kewarganegaraan', _kewarganegaraanCtrl)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildInput('Nomor Telepon / WhatsApp', _teleponCtrl)),
                ],
              ),
              const SizedBox(height: 12),
              _buildInput('Email', _emailCtrl),
              const SizedBox(height: 12),
              _buildInput('Alamat Lengkap', _alamatPelamarCtrl),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(flex: 3, child: _buildInput('Pendidikan Terakhir', _pendidikanCtrl)),
                  const SizedBox(width: 12),
                  Expanded(flex: 2, child: _buildInput('IPK', _ipkCtrl)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Section 3: Paragraf Minat / Deskripsi Diri
          _buildCard(
            title: '3. Paragraf Deskripsi & Kontribusi',
            icon: Icons.edit_note_rounded,
            children: [
              _buildInput(
                'Isi Paragraf Kemampuan & Minat',
                _minatBidangCtrl,
                maxLines: 4,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Section 4: Lampiran
          _buildCard(
            title: '4. Daftar Lampiran Berkas',
            icon: Icons.attach_file_rounded,
            children: [
              ..._lampiranCtrls.asMap().entries.map((entry) {
                final idx = entry.key;
                final ctrl = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Text('${idx + 1}. ', style: const TextStyle(color: Colors.white70)),
                      Expanded(
                        child: TextFormField(
                          controller: ctrl,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: _inputDecoration(''),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 20),
                        onPressed: () {
                          setState(() {
                            _lampiranCtrls.removeAt(idx);
                          });
                        },
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _lampiranCtrls.add(TextEditingController(text: 'Berkas tambahan'));
                  });
                },
                icon: const Icon(Icons.add, size: 18, color: AppColors.primary),
                label: const Text('Tambah Lampiran Lain', style: TextStyle(color: AppColors.primary)),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Action Buttons Bottom
          ElevatedButton.icon(
            onPressed: _isGenerating ? null : () => _exportPdf(preview: false),
            icon: const Icon(Icons.download_rounded, size: 20),
            label: Text(
              _isGenerating ? 'Sedang Memproses...' : 'Simpan & Download Surat Lamaran (PDF)',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
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
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController ctrl, {String? hint, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: _inputDecoration(hint ?? ''),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white30, fontSize: 12),
      filled: true,
      fillColor: const Color(0xFF0F172A),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}
