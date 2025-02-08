import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import '../models/experience.dart';

class PdfService {
  Future<void> exportExperiences({
    required String title,
    required List<Experience> experiences,
    required String languageCode,
  }) async {
    final pdf = pw.Document();
    
    // Roboto fontunu yükle (UTF-8 desteği için)
    final font = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(font);

    // Önce tüm resimleri yükle
    final images = await Future.wait(
      experiences.map((experience) async {
        if (experience.imagePath != null) {
          return _getImage(experience.imagePath!);
        }
        return null;
      }),
    );

    // PDF sayfasını oluştur
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: ttf,
        ),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          ...List.generate(experiences.length, (index) {
            final experience = experiences[index];
            final image = images[index];

            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  experience.title,
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  experience.description,
                  style: const pw.TextStyle(
                    fontSize: 14,
                  ),
                ),
                pw.SizedBox(height: 8),
                if (image != null) ...[
                  pw.Container(
                    width: 200,
                    height: 200,
                    child: image,
                  ),
                  pw.SizedBox(height: 8),
                ],
                pw.Row(
                  children: [
                    pw.Text(
                      experience.formattedDate,
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.SizedBox(width: 8),
                    if (experience.location != null)
                      pw.Text(
                        experience.location!,
                        style: const pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.grey700,
                        ),
                      ),
                  ],
                ),
                if (experience.tags.isNotEmpty)
                  pw.Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: experience.tags.map((tag) {
                      return pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey200,
                          borderRadius: pw.BorderRadius.circular(12),
                        ),
                        child: pw.Text(
                          tag,
                          style: const pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey700,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                pw.SizedBox(height: 16),
                pw.Divider(),
                pw.SizedBox(height: 16),
              ],
            );
          }),
        ],
      ),
    );

    // PDF'i kaydet ve paylaş
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/experiences.pdf');
    await file.writeAsBytes(await pdf.save());

    // PDF'i paylaş
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: title,
    );
  }

  Future<pw.Image?> _getImage(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        return pw.Image(pw.MemoryImage(bytes));
      }
    } catch (e) {
      print('Error loading image: $e');
    }
    return null;
  }
} 