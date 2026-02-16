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
      appBar: AppBar(
        title: const Text('CV Draft'),
        backgroundColor: const Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => PDFService.generateAndDownload(data),
        label: const Text('Download PDF'),
        icon: const Icon(Icons.download),
        backgroundColor: const Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Container(
            width: a4Width,
            height: a4Height,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(51),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: _buildLayoutByTemplate(),
          ),
        ),
      ),
    );
  }

  Widget _buildLayoutByTemplate() {
    switch (data.template) {
      case CVTemplate.classic:
        return _buildClassicLayout();
      case CVTemplate.professional:
        return _buildProfessionalLayout();
      case CVTemplate.modern:
      default:
        return _buildModernLayout();
    }
  }

  Widget _buildClassicLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                _buildProfilePhotoClassic(),
                const SizedBox(height: 16),
                Text(
                  data.name.toUpperCase(),
                  style: GoogleFonts.oswald(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  data.jobTitle.toUpperCase(),
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    letterSpacing: 2,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIconText(
                      Icons.phone,
                      data.contact.phone,
                      Colors.black87,
                    ),
                    const SizedBox(width: 16),
                    _buildIconText(
                      Icons.email,
                      data.contact.email,
                      Colors.black87,
                    ),
                    const SizedBox(width: 16),
                    _buildIconText(
                      Icons.location_on,
                      data.contact.location,
                      Colors.black87,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 40, thickness: 2, color: Colors.black12),
          _buildClassicSection(
            'PROFILE',
            Text(data.profileSummary, style: GoogleFonts.lato(fontSize: 10)),
          ),
          if (data.workExperience.isNotEmpty)
            _buildClassicSection(
              'EXPERIENCE',
              Column(
                children: data.workExperience
                    .map((e) => _buildExperienceItem(e))
                    .toList(),
              ),
            ),
          if (data.internshipExperience.isNotEmpty)
            _buildClassicSection(
              'INTERNSHIPS',
              Column(
                children: data.internshipExperience
                    .map((e) => _buildExperienceItem(e))
                    .toList(),
              ),
            ),
          if (data.education.isNotEmpty)
            _buildClassicSection(
              'EDUCATION',
              Column(
                children: data.education
                    .map((e) => _buildEducationItemClassic(e))
                    .toList(),
              ),
            ),
          if (data.skills.isNotEmpty)
            _buildClassicSection(
              'SKILLS',
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: data.skills.map((s) => _buildChip(s)).toList(),
              ),
            ),
          if (data.languages.isNotEmpty)
            _buildClassicSection(
              'LANGUAGES',
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: data.languages
                    .map((s) => _buildChip(s, color: Colors.blue[50]))
                    .toList(),
              ),
            ),
          if (data.hobbies.isNotEmpty)
            _buildClassicSection(
              'HOBBIES',
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: data.hobbies
                    .map((s) => _buildChip(s, color: Colors.green[50]))
                    .toList(),
              ),
            ),
          if (data.reference.isNotEmpty)
            _buildClassicSection(
              'REFERENCES',
              Text(
                data.reference,
                style: GoogleFonts.lato(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfessionalLayout() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: const Color(0xFF1E3A5F),
          padding: const EdgeInsets.all(32),
          child: Row(
            children: [
              _buildProfilePhotoProfessional(),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: GoogleFonts.oswald(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      data.jobTitle,
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 20,
                      runSpacing: 8,
                      children: [
                        _buildIconText(
                          Icons.phone,
                          data.contact.phone,
                          Colors.white,
                        ),
                        _buildIconText(
                          Icons.email,
                          data.contact.email,
                          Colors.white,
                        ),
                        _buildIconText(
                          Icons.location_on,
                          data.contact.location,
                          Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildMainSection(
                        title: 'SUMMARY',
                        content: Text(
                          data.profileSummary,
                          style: GoogleFonts.lato(fontSize: 10),
                        ),
                      ),
                      if (data.workExperience.isNotEmpty)
                        _buildMainSection(
                          title: 'EXPERIENCE',
                          content: Column(
                            children: data.workExperience
                                .map((e) => _buildExperienceItem(e))
                                .toList(),
                          ),
                        ),
                      if (data.internshipExperience.isNotEmpty)
                        _buildMainSection(
                          title: 'INTERNSHIPS',
                          content: Column(
                            children: data.internshipExperience
                                .map((e) => _buildExperienceItem(e))
                                .toList(),
                          ),
                        ),
                      if (data.reference.isNotEmpty)
                        _buildMainSection(
                          title: 'REFERENCES',
                          content: Text(
                            data.reference,
                            style: GoogleFonts.lato(
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Container(width: 1, color: Colors.grey[200]),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.grey[50],
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        if (data.skills.isNotEmpty)
                          _buildSidebarSection(
                            title: 'SKILLS',
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: data.skills
                                  .map(_buildBulletItemBlack)
                                  .toList(),
                            ),
                          ),
                        if (data.languages.isNotEmpty)
                          _buildSidebarSection(
                            title: 'LANGUAGES',
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: data.languages
                                  .map(_buildBulletItemBlack)
                                  .toList(),
                            ),
                          ),
                        if (data.hobbies.isNotEmpty)
                          _buildSidebarSection(
                            title: 'HOBBIES',
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: data.hobbies
                                  .map(_buildBulletItemBlack)
                                  .toList(),
                            ),
                          ),
                        if (data.education.isNotEmpty)
                          _buildSidebarSection(
                            title: 'EDUCATION',
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: data.education
                                  .map(_buildEducationItemBlack)
                                  .toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModernLayout() {
    return Row(
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
                        if (data.education.isNotEmpty)
                          _buildSidebarSection(
                            title: 'EDUCATION',
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: data.education
                                  .map((e) => _buildEducationItem(e))
                                  .toList(),
                            ),
                          ),
                        if (data.skills.isNotEmpty)
                          _buildSidebarSection(
                            title: 'SKILLS',
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: data.skills
                                  .map((s) => _buildBulletItem(s))
                                  .toList(),
                            ),
                          ),
                        if (data.languages.isNotEmpty)
                          _buildSidebarSection(
                            title: 'LANGUAGES',
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: data.languages
                                  .map((l) => _buildBulletItem(l))
                                  .toList(),
                            ),
                          ),
                        if (data.hobbies.isNotEmpty)
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
                        if (data.workExperience.isNotEmpty)
                          _buildMainSection(
                            title: 'Work Experience',
                            content: Column(
                              children: data.workExperience
                                  .map((e) => _buildExperienceItem(e))
                                  .toList(),
                            ),
                          ),
                        if (data.internshipExperience.isNotEmpty)
                          _buildMainSection(
                            title: 'Internship Experience',
                            content: Column(
                              children: data.internshipExperience
                                  .map((e) => _buildExperienceItem(e))
                                  .toList(),
                            ),
                          ),
                        if (data.reference.isNotEmpty)
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
    );
  }

  Widget _buildIconText(IconData icon, String text, Color color) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(text, style: GoogleFonts.lato(fontSize: 10, color: color)),
      ],
    );
  }

  Widget _buildClassicSection(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.oswald(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Container(height: 1, width: double.infinity, color: Colors.black12),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildChip(String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(text, style: GoogleFonts.lato(fontSize: 10)),
    );
  }

  Widget _buildEducationItemClassic(Education e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                e.institution,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              Text(
                e.period,
                style: GoogleFonts.lato(fontSize: 10, color: Colors.black54),
              ),
            ],
          ),
          Text(
            e.degree,
            style: GoogleFonts.lato(fontSize: 10, fontStyle: FontStyle.italic),
          ),
          if (e.score != null)
            Text(
              e.score!,
              style: GoogleFonts.lato(fontSize: 9, color: Colors.blueGrey),
            ),
        ],
      ),
    );
  }

  Widget _buildBulletItemBlack(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 10)),
          Expanded(child: Text(text, style: GoogleFonts.lato(fontSize: 10))),
        ],
      ),
    );
  }

  Widget _buildEducationItemBlack(Education e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            e.institution,
            style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 10),
          ),
          Text(e.degree, style: GoogleFonts.lato(fontSize: 9)),
          Text(
            e.period,
            style: GoogleFonts.lato(fontSize: 9, color: Colors.grey),
          ),
          if (e.score != null)
            Text(
              e.score!,
              style: GoogleFonts.lato(fontSize: 8, color: Colors.blueGrey),
            ),
        ],
      ),
    );
  }

  Widget _buildProfilePhoto() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 15),
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          color: Colors.white,
        ),
        child: ClipOval(child: _buildImageWidget(data.imagePath)),
      ),
    );
  }

  Widget _buildProfilePhotoProfessional() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(51), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: _buildImageWidget(data.imagePath),
      ),
    );
  }

  Widget _buildProfilePhotoClassic() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: ClipOval(child: _buildImageWidget(data.imagePath)),
    );
  }

  Widget _buildImageWidget(String path) {
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.person, size: 60, color: Colors.grey),
      );
    } else {
      // For potential future file picker support
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.person, size: 60, color: Colors.grey),
      );
    }
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
              color:
                  (data.template == CVTemplate.professional ||
                      data.template == CVTemplate.classic)
                  ? const Color(0xFF1E3A5F)
                  : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          Divider(
            color:
                (data.template == CVTemplate.professional ||
                    data.template == CVTemplate.classic)
                ? const Color(0xFF1E3A5F).withAlpha(51)
                : Colors.white54,
            thickness: 1,
            height: 8,
          ),
          const SizedBox(height: 6),
          content,
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    if (text.isEmpty) return const SizedBox.shrink();
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
    final names = data.name.trim().split(' ');
    final firstName = names.isNotEmpty ? names.first : '';
    final lastName = names.length > 1 ? names.sublist(1).join(' ') : '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$firstName ',
                style: GoogleFonts.oswald(
                  color: const Color(0xFF2C3E50),
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (lastName.isNotEmpty)
                TextSpan(
                  text: lastName,
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
