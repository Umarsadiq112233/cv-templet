import 'package:flutter/material.dart';
import 'models.dart';
import 'cv_page.dart';
import 'pdf_service.dart';
import 'storage_service.dart';

class EntryFormPage extends StatefulWidget {
  final CVData? initialData;
  const EntryFormPage({super.key, this.initialData});

  @override
  State<EntryFormPage> createState() => _EntryFormPageState();
}

class _EntryFormPageState extends State<EntryFormPage> {
  final _formKey = GlobalKey<FormState>();
  late CVData _data;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _data = widget.initialData ?? sampleCVData;
  }

  Future<void> _saveCV() async {
    await StorageService.saveCV(_data);
  }

  InputDecoration _getInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF1E3A5F)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1E3A5F), width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Professional CV Builder'),
        backgroundColor: const Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => PDFService.generateAndDownload(_data),
            tooltip: 'Generate PDF',
          ),
        ],
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF1E3A5F)),
        ),
        child: Form(
          key: _formKey,
          child: Stepper(
            type: StepperType.vertical,
            currentStep: _currentStep,
            onStepTapped: (step) => setState(() => _currentStep = step),
            onStepContinue: () async {
              await _saveCV();
              if (_currentStep < 5) {
                setState(() => _currentStep += 1);
              } else {
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CVPage(data: _data),
                    ),
                  );
                }
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep -= 1);
              }
            },
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A5F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _currentStep == 5 ? 'PREVIEW CV' : 'CONTINUE',
                      ),
                    ),
                    if (_currentStep > 0) ...[
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: details.onStepCancel,
                        child: const Text(
                          'BACK',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
            steps: [
              Step(
                title: const Text(
                  'Personal Info',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                isActive: _currentStep >= 0,
                state: _currentStep > 0
                    ? StepState.complete
                    : StepState.indexed,
                content: Column(
                  children: [
                    TextFormField(
                      initialValue: _data.name,
                      decoration: _getInputDecoration(
                        'Full Name',
                        Icons.person,
                      ),
                      onChanged: (val) =>
                          setState(() => _data = _updateData(name: val)),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _data.jobTitle,
                      decoration: _getInputDecoration(
                        'Desired Job Title',
                        Icons.work,
                      ),
                      onChanged: (val) =>
                          setState(() => _data = _updateData(jobTitle: val)),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _data.profileSummary,
                      decoration: _getInputDecoration(
                        'Profile Summary',
                        Icons.description,
                      ),
                      maxLines: 4,
                      onChanged: (val) => setState(
                        () => _data = _updateData(profileSummary: val),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _data.contact.phone,
                      decoration: _getInputDecoration('Phone', Icons.phone),
                      onChanged: (val) =>
                          setState(() => _data = _updateContact(phone: val)),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _data.contact.email,
                      decoration: _getInputDecoration('Email', Icons.email),
                      onChanged: (val) =>
                          setState(() => _data = _updateContact(email: val)),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _data.contact.location,
                      decoration: _getInputDecoration(
                        'Location',
                        Icons.location_on,
                      ),
                      onChanged: (val) =>
                          setState(() => _data = _updateContact(location: val)),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _data.imagePath,
                      decoration: _getInputDecoration(
                        'Profile Image Path',
                        Icons.image,
                      ),
                      onChanged: (val) =>
                          setState(() => _data = _updateData(imagePath: val)),
                    ),
                  ],
                ),
              ),
              Step(
                title: const Text(
                  'Education',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                isActive: _currentStep >= 1,
                state: _currentStep > 1
                    ? StepState.complete
                    : StepState.indexed,
                content: _buildDynamicListSection(
                  title: 'Academic Background',
                  items: _data.education,
                  onAdd: () =>
                      setState(() => _data.education.add(Education.empty())),
                  itemBuilder: (index) {
                    final edu = _data.education[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withAlpha(51)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(13),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: edu.period,
                                  decoration: _getInputDecoration(
                                    'Period',
                                    Icons.calendar_today,
                                  ),
                                  onChanged: (val) => setState(
                                    () => _data.education[index] = _updateEdu(
                                      edu,
                                      period: val,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () => setState(
                                  () => _data.education.removeAt(index),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            initialValue: edu.institution,
                            decoration: _getInputDecoration(
                              'Institution',
                              Icons.school,
                            ),
                            onChanged: (val) => setState(
                              () => _data.education[index] = _updateEdu(
                                edu,
                                institution: val,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            initialValue: edu.degree,
                            decoration: _getInputDecoration(
                              'Degree',
                              Icons.history_edu,
                            ),
                            onChanged: (val) => setState(
                              () => _data.education[index] = _updateEdu(
                                edu,
                                degree: val,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            initialValue: edu.score ?? '',
                            decoration: _getInputDecoration(
                              'Score/GPA (Optional)',
                              Icons.grade,
                            ),
                            onChanged: (val) => setState(
                              () => _data.education[index] = _updateEdu(
                                edu,
                                score: val,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Step(
                title: const Text(
                  'Experience',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                isActive: _currentStep >= 2,
                state: _currentStep > 2
                    ? StepState.complete
                    : StepState.indexed,
                content: Column(
                  children: [
                    _buildDynamicListSection(
                      title: 'Work History',
                      items: _data.workExperience,
                      onAdd: () => setState(
                        () => _data.workExperience.add(Experience.empty()),
                      ),
                      itemBuilder: (index) =>
                          _buildExperienceFormItem(index, _data.workExperience),
                    ),
                    const Divider(height: 32),
                    _buildDynamicListSection(
                      title: 'Internships',
                      items: _data.internshipExperience,
                      onAdd: () => setState(
                        () =>
                            _data.internshipExperience.add(Experience.empty()),
                      ),
                      itemBuilder: (index) => _buildExperienceFormItem(
                        index,
                        _data.internshipExperience,
                      ),
                    ),
                  ],
                ),
              ),
              Step(
                title: const Text(
                  'Skills & Languages',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                isActive: _currentStep >= 3,
                state: _currentStep > 3
                    ? StepState.complete
                    : StepState.indexed,
                content: Column(
                  children: [
                    _buildSimpleListSection(
                      'Professional Skills',
                      _data.skills,
                      Icons.bolt,
                    ),
                    const SizedBox(height: 20),
                    _buildSimpleListSection(
                      'Languages',
                      _data.languages,
                      Icons.language,
                    ),
                    const SizedBox(height: 20),
                    _buildSimpleListSection(
                      'Hobbies',
                      _data.hobbies,
                      Icons.interests,
                    ),
                  ],
                ),
              ),
              Step(
                title: const Text(
                  'References',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                isActive: _currentStep >= 4,
                state: _currentStep > 4
                    ? StepState.complete
                    : StepState.indexed,
                content: TextFormField(
                  initialValue: _data.reference,
                  decoration: _getInputDecoration(
                    'References',
                    Icons.people_outline,
                  ),
                  maxLines: 3,
                  onChanged: (val) =>
                      setState(() => _data = _updateData(reference: val)),
                ),
              ),
              Step(
                title: const Text(
                  'Finish',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                isActive: _currentStep >= 5,
                content: const Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 64,
                        color: Colors.green,
                      ),
                      SizedBox(height: 16),
                      Text('Your professional CV data is ready!'),
                      Text('Click below to preview or generate PDF.'),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E3A5F),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDynamicListSection({
    required String title,
    required List items,
    required VoidCallback onAdd,
    required Widget Function(int) itemBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle(title),
            TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_circle_outline, size: 20),
              label: const Text('ADD NEW'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1E3A5F),
              ),
            ),
          ],
        ),
        ...List.generate(items.length, itemBuilder),
      ],
    );
  }

  Widget _buildExperienceFormItem(int index, List<Experience> list) {
    final exp = list[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withAlpha(51)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: exp.title,
                  decoration: _getInputDecoration(
                    'Job Title',
                    Icons.work_outline,
                  ),
                  onChanged: (val) =>
                      setState(() => list[index] = _updateExp(exp, title: val)),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => setState(() => list.removeAt(index)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: exp.company,
            decoration: _getInputDecoration('Company', Icons.business),
            onChanged: (val) =>
                setState(() => list[index] = _updateExp(exp, company: val)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: exp.location ?? '',
                  decoration: _getInputDecoration('Location', Icons.place),
                  onChanged: (val) => setState(
                    () => list[index] = _updateExp(exp, location: val),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  initialValue: exp.period,
                  decoration: _getInputDecoration('Period', Icons.date_range),
                  onChanged: (val) => setState(
                    () => list[index] = _updateExp(exp, period: val),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: exp.points.join(', '),
            decoration: _getInputDecoration(
              'Key Achievements (comma separated)',
              Icons.list,
            ),
            maxLines: 3,
            onChanged: (val) => setState(() {
              list[index] = _updateExp(
                exp,
                points: val
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList(),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleListSection(
    String title,
    List<String> list,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        TextFormField(
          initialValue: list.join(', '),
          decoration: _getInputDecoration(
            'Enter $title (comma separated)',
            icon,
          ),
          maxLines: 2,
          onChanged: (val) => setState(() {
            list.clear();
            list.addAll(
              val.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty),
            );
          }),
        ),
      ],
    );
  }

  CVData _updateData({
    String? name,
    String? jobTitle,
    String? profileSummary,
    String? reference,
    String? imagePath,
  }) {
    return CVData(
      id: _data.id,
      name: name ?? _data.name,
      jobTitle: jobTitle ?? _data.jobTitle,
      profileSummary: profileSummary ?? _data.profileSummary,
      contact: _data.contact,
      education: _data.education,
      skills: _data.skills,
      languages: _data.languages,
      hobbies: _data.hobbies,
      workExperience: _data.workExperience,
      internshipExperience: _data.internshipExperience,
      reference: reference ?? _data.reference,
      imagePath: imagePath ?? _data.imagePath,
      lastModified: DateTime.now(),
      template: _data.template,
    );
  }

  CVData _updateContact({String? phone, String? email, String? location}) {
    return CVData(
      id: _data.id,
      name: _data.name,
      jobTitle: _data.jobTitle,
      profileSummary: _data.profileSummary,
      contact: ContactInfo(
        phone: phone ?? _data.contact.phone,
        email: email ?? _data.contact.email,
        location: location ?? _data.contact.location,
      ),
      education: _data.education,
      skills: _data.skills,
      languages: _data.languages,
      hobbies: _data.hobbies,
      workExperience: _data.workExperience,
      internshipExperience: _data.internshipExperience,
      reference: _data.reference,
      imagePath: _data.imagePath,
      lastModified: DateTime.now(),
      template: _data.template,
    );
  }

  Education _updateEdu(
    Education old, {
    String? period,
    String? institution,
    String? degree,
    String? score,
  }) {
    return Education(
      period: period ?? old.period,
      institution: institution ?? old.institution,
      degree: degree ?? old.degree,
      score: score ?? old.score,
    );
  }

  Experience _updateExp(
    Experience old, {
    String? title,
    String? company,
    String? location,
    String? period,
    List<String>? points,
  }) {
    return Experience(
      title: title ?? old.title,
      company: company ?? old.company,
      location: location ?? old.location,
      period: period ?? old.period,
      points: points ?? old.points,
    );
  }
}
