import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MultiRoleCvPdfService {
  static Future<Uint8List> generateCvPdf({
    required String targetRole, // 'Gudang & Logistik', 'Software Developer', 'Administrasi / Umum'
    required String fullName,
    required String title,
    required String email,
    required String phone,
    required String address,
    required String summary,
    required String education,
    required List<String> skills,
    required List<Map<String, String>> experiences,
  }) async {
    final pdf = pw.Document();

    final fontRegular = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();

    final primaryColor = PdfColor.fromHex('#1E293B'); // Slate Dark
    final accentColor = PdfColor.fromHex('#4F46E5'); // Indigo

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Name & Target Role
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        fullName.toUpperCase(),
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 20,
                          color: primaryColor,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        title.toUpperCase(),
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 11,
                          color: accentColor,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(phone, style: pw.TextStyle(font: fontRegular, fontSize: 9)),
                      pw.Text(email, style: pw.TextStyle(font: fontRegular, fontSize: 9)),
                      pw.Text(address, style: pw.TextStyle(font: fontRegular, fontSize: 9)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Divider(color: PdfColors.grey300, thickness: 1),
              pw.SizedBox(height: 10),

              // Ringkasan Profesional
              _buildSectionHeader('RINGKASAN PROFESIONAL', fontBold, accentColor),
              pw.SizedBox(height: 6),
              pw.Text(
                summary,
                style: pw.TextStyle(font: fontRegular, fontSize: 9.5, lineSpacing: 2),
                textAlign: pw.TextAlign.justify,
              ),
              pw.SizedBox(height: 14),

              // Keahlian & Keterampilan Utama
              _buildSectionHeader('KEAHLIAN & KETERAMPILAN UTAMA', fontBold, accentColor),
              pw.SizedBox(height: 6),
              pw.Wrap(
                spacing: 8,
                runSpacing: 4,
                children: skills.map((s) => pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#F1F5F9'),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    '• $s',
                    style: pw.TextStyle(font: fontRegular, fontSize: 9, color: primaryColor),
                  ),
                )).toList(),
              ),
              pw.SizedBox(height: 14),

              // Pengalaman Kerja
              _buildSectionHeader('PENGALAMAN KERJA & RIWAYAT', fontBold, accentColor),
              pw.SizedBox(height: 8),
              ...experiences.map((exp) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          exp['title'] ?? '',
                          style: pw.TextStyle(font: fontBold, fontSize: 10.5, color: primaryColor),
                        ),
                        pw.Text(
                          exp['period'] ?? '',
                          style: pw.TextStyle(font: fontRegular, fontSize: 9, color: PdfColors.grey700),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      exp['company'] ?? '',
                      style: pw.TextStyle(font: fontBold, fontSize: 9.5, color: accentColor),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      exp['description'] ?? '',
                      style: pw.TextStyle(font: fontRegular, fontSize: 9, lineSpacing: 1.5),
                    ),
                  ],
                ),
              )),

              pw.SizedBox(height: 10),

              // Pendidikan
              _buildSectionHeader('PENDIDIKAN TERAKHIR', fontBold, accentColor),
              pw.SizedBox(height: 6),
              pw.Text(
                education,
                style: pw.TextStyle(font: fontRegular, fontSize: 9.5),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildSectionHeader(String title, pw.Font font, PdfColor color) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.8)),
      ),
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          font: font,
          fontSize: 10.5,
          color: color,
        ),
      ),
    );
  }
}
