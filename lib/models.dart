class CVData {
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

  CVData({
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
  });
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
}

final sampleCVData = CVData(
  name: 'UMAR SADIQ',
  jobTitle: 'MOBILE APP DEVELOPER',
  profileSummary:
      'Motivated Computer Operator, Flutter Mobile App Developer, and Frontend Web Developer with strong skills in Dart, Firebase, HTML/CSS, React, Node.js, basic networking, and computer operations. I have 4 years of self-driven experience in developing mobile applications and web projects, including UI/UX design and efficient data management. Experienced in building real-world applications and delivering practical solutions.',
  contact: ContactInfo(
    phone: '03348934034',
    email: 'umarsadiq27041501@gmail.com',
    location: 'Pakistan Islamabad',
  ),
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
);
