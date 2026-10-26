import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CoverLetterPdfService {
  static Future<Uint8List> generatePdf({
    required String kotaTanggal,
    required String perihal,
    required String namaPerusahaan,
    required String alamatPerusahaan,
    required String posisi,
    required String namaLengkap,
    required String tempatTanggalLahir,
    required String jenisKelamin,
    required String kewarganegaraan,
    required String alamatPelamar,
    required String nomorTelepon,
    required String email,
    required String pendidikan,
    required String ipk,
    required String minatBidang,
    required List<String> lampiran,
  }) async {
    final pdf = pw.Document();

    final fontRegular = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 50, vertical: 40),
        build: (pw.Context context) {
          final regularStyle = pw.TextStyle(font: fontRegular, fontSize: 10.5, lineSpacing: 2);
          final boldStyle = pw.TextStyle(font: fontBold, fontSize: 10.5);

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 1. Kota dan Tanggal (Kanan Atas)
              pw.Align(
                alignment: pw.Alignment.topRight,
                child: pw.Text(kotaTanggal, style: regularStyle),
              ),
              pw.SizedBox(height: 10),

              // 2. Perihal
              pw.Text('Perihal: $perihal', style: regularStyle),
              pw.SizedBox(height: 20),

              // 3. Tujuan Surat
              pw.Text('Kepada Yth.', style: regularStyle),
              pw.Text(
                namaPerusahaan.isNotEmpty ? namaPerusahaan : 'Bapak/Ibu HRD',
                style: boldStyle,
              ),
              if (alamatPerusahaan.isNotEmpty)
                pw.Text(alamatPerusahaan, style: regularStyle),
              pw.Text('Di tempat', style: regularStyle),
              pw.SizedBox(height: 16),

              // 4. Salam Pembuka & Paragraf 1
              pw.Text('Dengan hormat,', style: regularStyle),
              pw.SizedBox(height: 6),
              pw.Text(
                'Berdasarkan informasi lowongan pekerjaan untuk posisi $posisi, saya bermaksud mengajukan lamaran pekerjaan pada perusahaan/instansi yang Bapak/Ibu pimpin. Saya berharap dapat memperoleh kesempatan untuk mengikuti proses seleksi dan menjelaskan kemampuan saya lebih lanjut.',
                textAlign: pw.TextAlign.justify,
                style: regularStyle,
              ),
              pw.SizedBox(height: 14),

              // 5. Data Diri
              pw.Text('Berikut data diri saya:', style: regularStyle),
              pw.SizedBox(height: 6),
              _buildDataRow('Nama', namaLengkap, fontRegular, fontBold),
              _buildDataRow('Tempat, tanggal lahir', tempatTanggalLahir, fontRegular, fontBold),
              _buildDataRow('Jenis kelamin', jenisKelamin, fontRegular, fontBold),
              _buildDataRow('Kewarganegaraan', kewarganegaraan, fontRegular, fontBold),
              _buildDataRow('Alamat', alamatPelamar, fontRegular, fontBold),
              _buildDataRow('Nomor telepon', nomorTelepon, fontRegular, fontBold),
              _buildDataRow('Email', email, fontRegular, fontBold),
              _buildDataRow('Pendidikan', pendidikan, fontRegular, fontBold),
              _buildDataRow('IPK', ipk, fontRegular, fontBold),
              pw.SizedBox(height: 14),

              // 6. Paragraf Keahlian / Kontribusi
              pw.Text(
                minatBidang.isNotEmpty
                    ? minatBidang
                    : 'Saya memiliki minat di bidang teknologi informasi, khususnya pengembangan website dan aplikasi. Saya terbiasa mempelajari teknologi baru, bekerja dengan teliti, dan berusaha menyelesaikan pekerjaan secara bertanggung jawab. Saya berharap kemampuan dan latar belakang pendidikan saya dapat memberikan kontribusi bagi perusahaan/instansi.',
                textAlign: pw.TextAlign.justify,
                style: regularStyle,
              ),
              pw.SizedBox(height: 14),

              // 7. Lampiran
              pw.Text('Sebagai bahan pertimbangan, bersama surat ini saya lampirkan:', style: regularStyle),
              pw.SizedBox(height: 4),
              ...lampiran.asMap().entries.map((entry) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 10, bottom: 2),
                  child: pw.Text('${entry.key + 1}. ${entry.value}', style: regularStyle),
                );
              }),
              pw.SizedBox(height: 14),

              // 8. Paragraf Penutup
              pw.Text(
                'Demikian surat lamaran ini saya sampaikan. Besar harapan saya untuk diberikan kesempatan mengikuti tahap seleksi selanjutnya. Atas perhatian dan kesempatan yang diberikan, saya mengucapkan terima kasih.',
                textAlign: pw.TextAlign.justify,
                style: regularStyle,
              ),
              pw.SizedBox(height: 20),

              // 9. Tanda Tangan (Kiri / Bawah)
              pw.Text('Hormat saya,', style: regularStyle),
              pw.SizedBox(height: 45), // Jarak tanda tangan
              pw.Text(namaLengkap, style: boldStyle),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildDataRow(String label, String value, pw.Font fontRegular, pw.Font fontBold) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2.5),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 145,
            child: pw.Text(label, style: pw.TextStyle(font: fontRegular, fontSize: 10)),
          ),
          pw.Text(': ', style: pw.TextStyle(font: fontRegular, fontSize: 10)),
          pw.Expanded(
            child: pw.Text(value, style: pw.TextStyle(font: fontRegular, fontSize: 10)),
          ),
        ],
      ),
    );
  }
}
