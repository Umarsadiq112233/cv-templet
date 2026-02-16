import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'models.dart';
import 'storage_service.dart';
import 'entry_form_page.dart';
import 'template_selection_page.dart';
import 'pdf_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CVData> _savedCvs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCvs();
  }

  Future<void> _loadCvs() async {
    setState(() => _isLoading = true);
    List<CVData> cvs = await StorageService.getAllCVs();

    if (cvs.isEmpty) {
      await StorageService.saveCV(sampleCVData);
      cvs = await StorageService.getAllCVs();
    }

    setState(() {
      _savedCvs = cvs;
      _isLoading = false;
    });
  }

  Future<void> _deleteCv(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Delete CV'),
            content: const Text('Are you sure you want to delete this CV?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                    'DELETE', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await StorageService.deleteCV(id);
      _loadCvs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildHero(),
            _buildChooseTemplate(),
            _buildSavedCvs(),
            _buildWhyChoose(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.white,
      child: Row(
        children: [
          Row(
            children: [
              const Icon(Icons.description, color: Color(0xFF1E3A5F), size: 32),
              const SizedBox(width: 8),
              Text(
                'CV Builder',
                style: GoogleFonts.oswald(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E3A5F),
                ),
              ),
            ],
          ),
          const Spacer(),
          if (MediaQuery
              .of(context)
              .size
              .width > 600)
            Row(
              children: [
                _buildNavLink('Home', true),
                _buildNavLink('Templates', false),
                _buildNavLink('My CVs', false),
                _buildNavLink('Login', false),
              ],
            ),
          const SizedBox(width: 24),
          ElevatedButton(
            onPressed: () => _navigateToTemplateSelection(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A5F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Create CV'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavLink(String title, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: GoogleFonts.lato(
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? const Color(0xFF1E3A5F) : Colors.black54,
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 800;
          return Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Professional\nCVs in Minutes',
                      style: GoogleFonts.oswald(
                        fontSize: isWide ? 48 : 36,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E3A5F),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Build, customize, and download your resume easily\nwith modern templates.',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => _navigateToTemplateSelection(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A5F),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('Create CV'),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1E3A5F),
                            side: const BorderSide(color: Color(0xFF1E3A5F)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('View Templates'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isWide)
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 30,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF1E3A5F),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 10,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      width: 120,
                                      height: 6,
                                      color: Colors.grey[200],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Container(
                              width: double.infinity,
                              height: 2,
                              color: Colors.grey[100],
                            ),
                            const SizedBox(height: 24),
                            Container(
                              width: 60,
                              height: 8,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              height: 60,
                              color: Colors.grey[50],
                            ),
                            const SizedBox(height: 24),
                            Container(
                              width: 60,
                              height: 8,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              height: 40,
                              color: Colors.grey[50],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              height: 40,
                              color: Colors.grey[50],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChooseTemplate() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          _buildSectionTitle('Choose Your Template'),
          const SizedBox(height: 32),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _buildTemplateCard(
                'Modern',
                'assets/images/template_modern.png',
                CVTemplate.modern,
              ),
              _buildTemplateCard(
                'Simple',
                'assets/images/template_classic.png',
                CVTemplate.classic,
              ),
              _buildTemplateCard(
                'Creative',
                'assets/images/template_professional.png',
                CVTemplate.professional,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(String name,
      String imagePath,
      CVTemplate template,) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Icon(
              Icons.description,
              size: 80,
              color: Colors.grey[300],
            ), // Placeholder for actual template screenshot
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  name,
                  style: GoogleFonts.oswald(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _createCvWithTemplate(template),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A5F),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Use Template'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedCvs() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          _buildSectionTitle('Your Saved CVs'),
          const SizedBox(height: 32),
          if (_savedCvs.isEmpty)
            _buildEmptyState()
          else
            Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.start,
              children: _savedCvs.map((cv) => _buildCvCard(cv)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildCvCard(CVData cv) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cv.name.isEmpty ? 'My Resume' : cv.name,
            style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Last Updated: ${DateFormat('MMM d, yyyy').format(
                cv.lastModified)}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildActionButton(
                Icons.edit,
                'Edit',
                Colors.blue,
                    () => _editCv(cv),
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                Icons.download,
                'PDF',
                Colors.green,
                    () => PDFService.generateAndDownload(cv),
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                Icons.delete,
                'Delete',
                Colors.red,
                    () => _deleteCv(cv.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon,
      String label,
      Color color,
      VoidCallback onPressed,) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 14),
        label: Text(label, style: const TextStyle(fontSize: 10)),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withAlpha(51)),
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  Widget _buildWhyChoose() {
    return Padding(
      padding: const EdgeInsets.all(60),
      child: Column(
        children: [
          _buildSectionTitle('Why Choose CV Builder?'),
          const SizedBox(height: 40),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _buildFeatureCard(Icons.edit_note, 'Easy Data Entry', ''),
              _buildFeatureCard(Icons.style, 'Multiple Templates', ''),
              _buildFeatureCard(Icons.save, 'Save & Edit Anytime', ''),
              _buildFeatureCard(Icons.picture_as_pdf, 'Download as PDF', ''),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String subtitle) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blue[700], size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            title,
            style: GoogleFonts.oswald(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E3A5F),
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Text(
          '© 2026 CV Builder. All rights reserved.',
          style: GoogleFonts.lato(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Icon(Icons.description_outlined, size: 64, color: Colors.grey[200]),
        const SizedBox(height: 16),
        const Text('No CVs saved yet. Create your first one above!'),
      ],
    );
  }

  void _navigateToTemplateSelection() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TemplateSelectionPage()),
    );
    _loadCvs();
  }

  void _createCvWithTemplate(CVTemplate template) async {
    final newId = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    final newData = CVData.empty(id: newId).copyWith(template: template);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntryFormPage(initialData: newData),
      ),
    );
    _loadCvs();
  }

  void _editCv(CVData cv) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EntryFormPage(initialData: cv)),
    );
    _loadCvs();
  }
}
