import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'models.dart';

class PDFService {
  static Future<void> generateAndDownload(CVData data) async {
    final pdf = pw.Document();

    final fontRegular = await PdfGoogleFonts.latoRegular();
    final fontBold = await PdfGoogleFonts.latoBold();
    final fontOswald = await PdfGoogleFonts.oswaldBold();

    // Load profile photo
    pw.ImageProvider? profileImage;
    try {
      final imagePath = data.imagePath.startsWith('assets/')
          ? data.imagePath
          : 'assets/images/profile.jpg';
      final imageBytes = await rootBundle.load(imagePath);
      profileImage = pw.MemoryImage(imageBytes.buffer.asUint8List());
    } catch (e) {
      debugPrint('Error loading profile image for PDF: $e');
    }

    // Use Page instead of MultiPage to ensure single-page output
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return pw.Stack(
            children: [
              // Background
              pw.Row(
                children: [
                  pw.Container(
                    width: 210, // 35% of A4 width (595 points)
                    color: PdfColor.fromInt(0xFF1E3A5F),
                  ),
                  pw.Expanded(child: pw.Container(color: PdfColors.white)),
                ],
              ),
              // Content
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Sidebar - 35% width
                  pw.SizedBox(
                    width: 210,
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // Profile Photo
                          pw.Center(
                            child: pw.Container(
                              width: 150,
                              height: 150,
                              decoration: pw.BoxDecoration(
                                shape: pw.BoxShape.circle,
                                border: pw.Border.all(
                                  color: PdfColors.white,
                                  width: 3,
                                ),
                                color: PdfColors.white,
                              ),
                              child: pw.ClipOval(
                                child: pw.SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: profileImage != null
                                      ? pw.Center(
                                          child: pw.Image(
                                            profileImage,
                                            fit: pw.BoxFit.contain,
                                          ),
                                        )
                                      : pw.Center(
                                          child: pw.Container(
                                            color: PdfColors.grey300,
                                            child: pw.Text(
                                              'Photo',
                                              style: pw.TextStyle(
                                                color: PdfColors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 10),
                          _buildSidebarSection(
                            'CONTACT',
                            [
                              _buildContactItem(data.contact.phone),
                              _buildContactItem(data.contact.email),
                              _buildContactItem(data.contact.location),
                            ],
                            fontOswald,
                            fontRegular,
                          ),
                          _buildSidebarSection(
                            'EDUCATION',
                            data.education
                                .map(
                                  (e) => pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        e.period,
                                        style: pw.TextStyle(
                                          color: PdfColors.white,
                                          fontSize: 12,
                                          font: fontBold,
                                        ),
                                      ),
                                      pw.Text(
                                        e.institution,
                                        style: pw.TextStyle(
                                          color: PdfColors.white,
                                          fontSize: 12,
                                          font: fontBold,
                                        ),
                                      ),
                                      pw.Text(
                                        '• ${e.degree}',
                                        style: pw.TextStyle(
                                          color: PdfColors.white,
                                          fontSize: 10,
                                          font: fontRegular,
                                        ),
                                      ),
                                      if (e.score != null)
                                        pw.Text(
                                          '• ${e.score}',
                                          style: pw.TextStyle(
                                            color: PdfColors.white,
                                            fontSize: 10,
                                            font: fontRegular,
                                          ),
                                        ),
                                      pw.SizedBox(height: 4),
                                    ],
                                  ),
                                )
                                .toList(),
                            fontOswald,
                            fontRegular,
                          ),
                          _buildSidebarSection(
                            'SKILLS',
                            data.skills
                                .map(
                                  (s) => pw.Padding(
                                    padding: const pw.EdgeInsets.only(
                                      bottom: 2,
                                    ),
                                    child: pw.Text(
                                      '• $s',
                                      style: pw.TextStyle(
                                        color: PdfColors.white,
                                        fontSize: 12,
                                        font: fontRegular,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            fontOswald,
                            fontRegular,
                          ),
                          _buildSidebarSection(
                            'LANGUAGES',
                            data.languages
                                .map(
                                  (l) => pw.Padding(
                                    padding: const pw.EdgeInsets.only(
                                      bottom: 2,
                                    ),
                                    child: pw.Text(
                                      '• $l',
                                      style: pw.TextStyle(
                                        color: PdfColors.white,
                                        fontSize: 12,
                                        font: fontRegular,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            fontOswald,
                            fontRegular,
                          ),
                          _buildSidebarSection(
                            'HOBBIES',
                            data.hobbies
                                .map(
                                  (h) => pw.Padding(
                                    padding: const pw.EdgeInsets.only(
                                      bottom: 2,
                                    ),
                                    child: pw.Text(
                                      '• $h',
                                      style: pw.TextStyle(
                                        color: PdfColors.white,
                                        fontSize: 12,
                                        font: fontRegular,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            fontOswald,
                            fontRegular,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Main Content - 65% width
                  pw.Expanded(
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(24),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // Header
                          pw.RichText(
                            text: pw.TextSpan(
                              children: [
                                () {
                                  final names = data.name.trim().split(' ');
                                  if (names.isEmpty)
                                    return pw.TextSpan(text: '');
                                  final firstName = names.first;
                                  final lastName = names.length > 1
                                      ? names.sublist(1).join(' ')
                                      : '';

                                  return pw.TextSpan(
                                    children: [
                                      pw.TextSpan(
                                        text: '$firstName ',
                                        style: pw.TextStyle(
                                          font: fontOswald,
                                          fontSize: 36,
                                          color: PdfColor.fromInt(0xFF2C3E50),
                                        ),
                                      ),
                                      if (lastName.isNotEmpty)
                                        pw.TextSpan(
                                          text: lastName,
                                          style: pw.TextStyle(
                                            font: fontOswald,
                                            fontSize: 36,
                                            fontWeight: pw.FontWeight.normal,
                                            color: PdfColor.fromInt(0xFF2C3E50),
                                          ),
                                        ),
                                    ],
                                  );
                                }(),
                              ],
                            ),
                          ),
                          pw.Text(
                            data.jobTitle,
                            style: pw.TextStyle(
                              font: fontRegular,
                              fontSize: 18,
                              color: PdfColor.fromInt(0xFF34495E),
                              letterSpacing: 1.2,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Container(
                            height: 3,
                            width: 60,
                            color: PdfColor.fromInt(0xFF1E3A5F),
                          ),
                          pw.SizedBox(height: 8),
                          _buildMainSection(
                            'PROFILE',
                            pw.Text(
                              data.profileSummary,
                              style: pw.TextStyle(
                                font: fontRegular,
                                fontSize: 10,
                                color: PdfColors.black,
                                lineSpacing: 1.5,
                              ),
                              textAlign: pw.TextAlign.justify,
                            ),
                            fontOswald,
                          ),
                          _buildMainSection(
                            'WORK EXPERIENCE',
                            pw.Column(
                              children: data.workExperience
                                  .map(
                                    (e) => _buildExperienceItem(
                                      e,
                                      fontBold,
                                      fontRegular,
                                    ),
                                  )
                                  .toList(),
                            ),
                            fontOswald,
                          ),
                          _buildMainSection(
                            'INTERNSHIP EXPERIENCE',
                            pw.Column(
                              children: data.internshipExperience
                                  .map(
                                    (e) => _buildExperienceItem(
                                      e,
                                      fontBold,
                                      fontRegular,
                                    ),
                                  )
                                  .toList(),
                            ),
                            fontOswald,
                          ),
                          _buildMainSection(
                            'REFERENCE',
                            pw.Text(
                              data.reference,
                              style: pw.TextStyle(
                                font: fontRegular,
                                fontSize: 10,
                                fontStyle: pw.FontStyle.italic,
                                color: PdfColors.grey700,
                              ),
                            ),
                            fontOswald,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static pw.Widget _buildSidebarSection(
    String title,
    List<pw.Widget> children,
    pw.Font titleFont,
    pw.Font bodyFont,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              font: titleFont,
              fontSize: 14,
              color: PdfColors.white,
              letterSpacing: 1.2,
            ),
          ),
          pw.Divider(
            color: const PdfColor(1, 1, 1, 0.5),
            thickness: 0.5,
            height: 4,
          ),
          pw.SizedBox(height: 2),
          ...children,
        ],
      ),
    );
  }

  static pw.Widget _buildContactItem(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Text(
        text,
        style: const pw.TextStyle(color: PdfColors.white, fontSize: 10),
      ),
    );
  }

  static pw.Widget _buildMainSection(
    String title,
    pw.Widget content,
    pw.Font titleFont,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              font: titleFont,
              fontSize: 16,
              color: PdfColor.fromInt(0xFF1E3A5F),
              letterSpacing: 1.5,
            ),
          ),
          pw.Divider(
            color: PdfColor.fromInt(0xFF1E3A5F),
            thickness: 1.5,
            height: 6,
          ),
          pw.SizedBox(height: 2),
          content,
        ],
      ),
    );
  }

  static pw.Widget _buildExperienceItem(
    Experience e,
    pw.Font boldFont,
    pw.Font regFont,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Stack(
        children: [
          // Background vertical line that spans full height of the stack
          pw.Positioned(
            top: 0,
            bottom: 0,
            left: 5.25,
            child: pw.Container(
              width: 1.5,
              color: PdfColor.fromInt(0xFF1E3A5F),
            ),
          ),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Milestone Dot
              pw.Container(
                width: 12,
                height: 12,
                margin: const pw.EdgeInsets.only(top: 3),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFF1E3A5F),
                  shape: pw.BoxShape.circle,
                  border: pw.Border.all(color: PdfColors.white, width: 2),
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      e.title,
                      style: pw.TextStyle(font: boldFont, fontSize: 10),
                    ),
                    pw.Text(
                      '${e.company}${e.location != null ? ' — ${e.location}' : ''}',
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 10,
                        color: PdfColor.fromInt(0xFF1E3A5F),
                      ),
                    ),
                    if (e.period.isNotEmpty)
                      pw.Text(
                        e.period,
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 10,
                          color: PdfColors.grey700,
                        ),
                      ),
                    pw.SizedBox(height: 3),
                    ...e.points.map(
                      (p) => pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 2),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(
                              margin: const pw.EdgeInsets.only(
                                top: 3,
                                right: 6,
                              ),
                              width: 2.5,
                              height: 2.5,
                              decoration: const pw.BoxDecoration(
                                color: PdfColors.black,
                                shape: pw.BoxShape.circle,
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                p,
                                style: pw.TextStyle(
                                  font: regFont,
                                  fontSize: 10,
                                ),
                                textAlign: pw.TextAlign.justify,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
