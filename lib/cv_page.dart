import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models.dart';
import 'pdf_service.dart';

class CVPage extends StatelessWidget {
  final CVData data;

  const CVPage({super.key, required this.data});

  // Fixed A4 dimensions in pixels (at 96 DPI)
  static const double a4Width = 794.0;
  static const double a4Height = 1123.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => PDFService.generateAndDownload(data),
        label: const Text('Download PDF'),
        icon: const Icon(Icons.download),
        backgroundColor: const Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          width: a4Width,
          height: a4Height,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sidebar - 35% width
              SizedBox(
                width: a4Width * 0.35,
                child: Container(
                  color: const Color(0xFF1E3A5F),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfilePhoto(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildSidebarSection(
                                title: 'CONTACT',
                                content: Column(
                                  children: [
                                    _buildContactItem(
                                      Icons.phone,
                                      data.contact.phone,
                                    ),
                                    _buildContactItem(
                                      Icons.email,
                                      data.contact.email,
                                    ),
                                    _buildContactItem(
                                      Icons.location_on,
                                      data.contact.location,
                                    ),
                                  ],
                                ),
                              ),
                              _buildSidebarSection(
                                title: 'EDUCATION',
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: data.education
                                      .map((e) => _buildEducationItem(e))
                                      .toList(),
                                ),
                              ),
                              _buildSidebarSection(
                                title: 'SKILLS',
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: data.skills
                                      .map((s) => _buildBulletItem(s))
                                      .toList(),
                                ),
                              ),
                              _buildSidebarSection(
                                title: 'LANGUAGES',
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: data.languages
                                      .map((l) => _buildBulletItem(l))
                                      .toList(),
                                ),
                              ),
                              _buildSidebarSection(
                                title: 'HOBBIES',
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: data.hobbies
                                      .map((h) => _buildBulletItem(h))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Main Content - 65% width
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildMainSection(
                                title: 'PROFILE',
                                content: Text(
                                  data.profileSummary,
                                  style: GoogleFonts.lato(
                                    fontSize: 10,
                                    height: 1.4,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              _buildMainSection(
                                title: 'Work Experience',
                                content: Column(
                                  children: data.workExperience
                                      .map((e) => _buildExperienceItem(e))
                                      .toList(),
                                ),
                              ),
                              _buildMainSection(
                                title: 'Internship Experience',
                                content: Column(
                                  children: data.internshipExperience
                                      .map((e) => _buildExperienceItem(e))
                                      .toList(),
                                ),
                              ),
                              _buildMainSection(
                                title: 'REFERENCE',
                                content: Text(
                                  data.reference,
                                  style: GoogleFonts.lato(
                                    fontSize: 10,
                                    color: Colors.black54,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildProfilePhoto() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 15),
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          color: Colors.white,
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/images/profile.jpg',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.person, size: 80, color: Colors.grey);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarSection({
    required String title,
    required Widget content,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.oswald(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const Divider(color: Colors.white54, thickness: 1, height: 8),
          const SizedBox(height: 6),
          content,
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.lato(color: Colors.white, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationItem(Education e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            e.period,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            e.institution,
            softWrap: true,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '• ',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              Expanded(
                child: Text(
                  e.degree,
                  style: GoogleFonts.lato(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
          ),
          if (e.score != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '• ',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                Expanded(
                  child: Text(
                    e.score!,
                    style: GoogleFonts.lato(color: Colors.white, fontSize: 10),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.white, fontSize: 12)),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.lato(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'UMAR ',
                style: GoogleFonts.oswald(
                  color: const Color(0xFF2C3E50),
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'SADIQ',
                style: GoogleFonts.oswald(
                  color: const Color(0xFF2C3E50),
                  fontSize: 36,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
        Text(
          data.jobTitle,
          style: GoogleFonts.lato(
            color: const Color(0xFF34495E),
            fontSize: 18,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(height: 3, width: 60, color: const Color(0xFF1E3A5F)),
      ],
    );
  }

  Widget _buildMainSection({required String title, required Widget content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: GoogleFonts.oswald(
              color: const Color(0xFF1E3A5F),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const Divider(color: Color(0xFF1E3A5F), thickness: 1.5, height: 6),
          const SizedBox(height: 6),
          content,
        ],
      ),
    );
  }

  Widget _buildExperienceItem(Experience e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Timeline decoration column
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A5F),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
                Expanded(
                  child: Container(width: 2, color: const Color(0xFF1E3A5F)),
                ),
              ],
            ),
            const SizedBox(width: 8),
            // Content column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.title,
                    style: GoogleFonts.lato(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '${e.company}${e.location != null ? ' — ${e.location}' : ''}',
                    style: GoogleFonts.lato(
                      fontSize: 10,
                      color: const Color(0xFF1E3A5F),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (e.period.isNotEmpty)
                    Text(
                      e.period,
                      style: GoogleFonts.lato(
                        fontSize: 10,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 4),
                  ...e.points.map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: 3, left: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 4, right: 6),
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(
                              color: Color(0xFF1E3A5F),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              p,
                              style: GoogleFonts.lato(
                                fontSize: 10,
                                color: Colors.black87,
                                height: 1.3,
                              ),
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
      ),
    );
  }
}
