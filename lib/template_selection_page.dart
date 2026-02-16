import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'models.dart';
import 'entry_form_page.dart';

class TemplateSelectionPage extends StatelessWidget {
  const TemplateSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Template'),
        backgroundColor: const Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select a style for your professional CV',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A5F),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
                children: [
                  _TemplateCard(
                    title: 'Classic',
                    description: 'Traditional layout, clean and readable.',
                    icon: Icons.article_outlined,
                    color: Colors.blueGrey,
                    template: CVTemplate.classic,
                  ),
                  _TemplateCard(
                    title: 'Modern',
                    description: 'Two-column layout with a stylish sidebar.',
                    icon: Icons.dashboard_customize_outlined,
                    color: Colors.indigo,
                    template: CVTemplate.modern,
                  ),
                  _TemplateCard(
                    title: 'Professional',
                    description: 'Elegant design for senior roles and experts.',
                    icon: Icons.business_center_outlined,
                    color: const Color(0xFF1E3A5F),
                    template: CVTemplate.professional,
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

class _TemplateCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final CVTemplate template;

  const _TemplateCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.template,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          final newCV = CVData.empty(id: const Uuid().v4());
          final updatedCV = CVData(
            id: newCV.id,
            name: newCV.name,
            jobTitle: newCV.jobTitle,
            profileSummary: newCV.profileSummary,
            contact: newCV.contact,
            education: newCV.education,
            skills: newCV.skills,
            languages: newCV.languages,
            hobbies: newCV.hobbies,
            workExperience: newCV.workExperience,
            internshipExperience: newCV.internshipExperience,
            reference: newCV.reference,
            lastModified: newCV.lastModified,
            template: template,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EntryFormPage(initialData: updatedCV),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
