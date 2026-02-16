enum CVTemplate { classic, modern, professional }

class CVData {
  final String id;
  final String name;
  final String jobTitle;
  final String profileSummary;
  final ContactInfo contact;
  final List<Education> education;
  final List<String> skills;
  final List<String> languages;
  final List<String> hobbies;
  final List<Experience> workExperience;
  final List<Experience> internshipExperience;
  final String reference;
  final String imagePath;
  final DateTime lastModified;
  final CVTemplate template;

  CVData({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.profileSummary,
    required this.contact,
    required this.education,
    required this.skills,
    required this.languages,
    required this.hobbies,
    required this.workExperience,
    required this.internshipExperience,
    required this.reference,
    this.imagePath = 'assets/images/profile.jpg',
    required this.lastModified,
    this.template = CVTemplate.classic,
  });

  factory CVData.empty({String? id}) => CVData(
    id: id ?? '',
    name: '',
    jobTitle: '',
    profileSummary: '',
    contact: ContactInfo.empty(),
    education: [],
    skills: [],
    languages: [],
    hobbies: [],
    workExperience: [],
    internshipExperience: [],
    reference: '',
    imagePath: 'assets/images/profile.jpg',
    lastModified: DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'jobTitle': jobTitle,
    'profileSummary': profileSummary,
    'contact': contact.toJson(),
    'education': education.map((e) => e.toJson()).toList(),
    'skills': skills,
    'languages': languages,
    'hobbies': hobbies,
    'workExperience': workExperience.map((e) => e.toJson()).toList(),
    'internshipExperience': internshipExperience
        .map((e) => e.toJson())
        .toList(),
    'reference': reference,
    'imagePath': imagePath,
    'lastModified': lastModified.toIso8601String(),
    'template': template.index,
  };

  factory CVData.fromJson(Map<String, dynamic> json) => CVData(
    id: json['id'],
    name: json['name'],
    jobTitle: json['jobTitle'],
    profileSummary: json['profileSummary'],
    contact: ContactInfo.fromJson(json['contact']),
    education: (json['education'] as List)
        .map((e) => Education.fromJson(e))
        .toList(),
    skills: List<String>.from(json['skills']),
    languages: List<String>.from(json['languages']),
    hobbies: List<String>.from(json['hobbies']),
    workExperience: (json['workExperience'] as List)
        .map((e) => Experience.fromJson(e))
        .toList(),
    internshipExperience: (json['internshipExperience'] as List)
        .map((e) => Experience.fromJson(e))
        .toList(),
    reference: json['reference'],
    imagePath: json['imagePath'] ?? 'assets/images/profile.jpg',
    lastModified: DateTime.parse(json['lastModified']),
    template: CVTemplate.values[json['template'] ?? 0],
  );

  CVData copyWith({
    String? id,
    String? name,
    String? jobTitle,
    String? profileSummary,
    ContactInfo? contact,
    List<Education>? education,
    List<String>? skills,
    List<String>? languages,
    List<String>? hobbies,
    List<Experience>? workExperience,
    List<Experience>? internshipExperience,
    String? reference,
    String? imagePath,
    DateTime? lastModified,
    CVTemplate? template,
  }) {
    return CVData(
      id: id ?? this.id,
      name: name ?? this.name,
      jobTitle: jobTitle ?? this.jobTitle,
      profileSummary: profileSummary ?? this.profileSummary,
      contact: contact ?? this.contact,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      languages: languages ?? this.languages,
      hobbies: hobbies ?? this.hobbies,
      workExperience: workExperience ?? this.workExperience,
      internshipExperience: internshipExperience ?? this.internshipExperience,
      reference: reference ?? this.reference,
      imagePath: imagePath ?? this.imagePath,
      lastModified: lastModified ?? this.lastModified,
      template: template ?? this.template,
    );
  }
}

class ContactInfo {
  final String phone;
  final String email;
  final String location;

  ContactInfo({
    required this.phone,
    required this.email,
    required this.location,
  });

  factory ContactInfo.empty() =>
      ContactInfo(phone: '', email: '', location: '');

  Map<String, dynamic> toJson() => {
    'phone': phone,
    'email': email,
    'location': location,
  };

  factory ContactInfo.fromJson(Map<String, dynamic> json) => ContactInfo(
    phone: json['phone'] ?? '',
    email: json['email'] ?? '',
    location: json['location'] ?? '',
  );
}

class Education {
  final String period;
  final String institution;
  final String degree;
  final String? score;

  Education({
    required this.period,
    required this.institution,
    required this.degree,
    this.score,
  });

  factory Education.empty() =>
      Education(period: '', institution: '', degree: '');

  Map<String, dynamic> toJson() => {
    'period': period,
    'institution': institution,
    'degree': degree,
    'score': score,
  };

  factory Education.fromJson(Map<String, dynamic> json) => Education(
    period: json['period'] ?? '',
    institution: json['institution'] ?? '',
    degree: json['degree'] ?? '',
    score: json['score'],
  );
}

class Experience {
  final String title;
  final String company;
  final String? location;
  final String period;
  final List<String> points;

  Experience({
    required this.title,
    required this.company,
    this.location,
    required this.period,
    required this.points,
  });

  factory Experience.empty() =>
      Experience(title: '', company: '', period: '', points: []);

  Map<String, dynamic> toJson() => {
    'title': title,
    'company': company,
    'location': location,
    'period': period,
    'points': points,
  };

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    title: json['title'] ?? '',
    company: json['company'] ?? '',
    location: json['location'],
    period: json['period'] ?? '',
    points: List<String>.from(json['points'] ?? []),
  );
}

final sampleCVData = CVData(
  id: 'sample-id',
  name: 'UMAR SADIQ',
  jobTitle: 'MOBILE APP DEVELOPER',
  profileSummary:
      'Motivated Computer Operator, Flutter Mobile App Developer, and Frontend Web Developer with strong skills in Dart, Firebase, HTML/CSS, React, Node.js, basic networking, and computer operations. I have 4 years of self-driven experience in developing mobile applications and web projects, including UI/UX design and efficient data management. Experienced in building real-world applications and delivering practical solutions.',
  contact: ContactInfo(
    phone: '03348934034',
    email: 'umarsadiq27041501@gmail.com',
    location: 'Pakistan Islamabad',
  ),
  lastModified: DateTime.now(),
  education: [
    Education(
      period: '2021 – 2025',
      institution: 'Kohat University of Science \n & Technology (KUST)',
      degree: 'Bachelor of Science in Computer Science (B.Sc CS)',
      score: 'CGPA: 3.32 / 4.0',
    ),
    Education(
      period: '2023 – 2024',
      institution: 'Diploma in Information Technology (DIT)',
      degree: 'Diploma',
      score: '764 / 1000',
    ),
  ],

  skills: [
    'Flutter & Dart Development',
    'Firebase Integration',
    'Version Control (Git/GitHub)',
    'HTML, CSS & Front-End Development',
    'React.js',
    'Node.js',
    'SQL & Database Management',
    'UI/UX Design',
    'Microsoft Office Suite',
    'Basic Networking',
    'Effective Communication & Team Collaboration',
  ],

  languages: ['English', 'Urdu', 'Pashto'],
  hobbies: [
    'Hiking',
    'Reading',
    'Research and Analysis',
    'Following Industry Trends',
  ],

  workExperience: [
    Experience(
      title: 'Flutter Developer',
      company: 'Quant Aeonix',
      location: 'Islamabad, Pakistan',
      period: 'June 2026 — Present',
      points: [
        'Working on real projects including Hero-me, Legal Ace, Jumpeez, Yobeast.',
        'Developing and maintaining cross-platform mobile apps using Flutter and Dart.',
        'Collaborating with designers and team members to implement responsive and user-friendly features.',
        'Participating in a full project lifecycle: design, development, testing, and deployment.',
      ],
    ),
  ],
  internshipExperience: [
    Experience(
      title: 'Digital Marketing Internship',
      company: 'Digital Skills Program',
      period: '',
      points: [
        'Trained in social media marketing, online advertising, content strategy, and basic analytics.',
      ],
    ),
    Experience(
      title: 'Mobile App Development Intern',
      company: 'HERA-KDDP / KUST',
      period: 'Jun 2025 — Aug 2025',
      points: [
        'Completed a 3-month Flutter internship, gaining hands-on experience in mobile app development, state management, UI/UX design, and debugging.',
      ],
    ),
    Experience(
      title: 'Flutter Developer (Remote)',
      company: 'Developers Hub Corporation',
      period: '2025',
      points: [
        'Built Flutter apps (E-Commerce, To-Do, Chatbot) with Firebase, responsive UI, API integration, and Git/GitHub version control.',
      ],
    ),
    Experience(
      title: 'Career Coaching App (Final Year Project)',
      company: 'Department of Computer Science, Kohat KUST University',
      period: '',
      points: [
        'Led development of a career coaching app with Firebase (Auth, Firestore, Storage), implementing authentication, dashboards, chat, and goal tracking with strong UI/UX and state management.',
      ],
    ),
  ],
  reference: 'References will be provided on demand.',
  imagePath: 'assets/images/profile.jpg',
);
