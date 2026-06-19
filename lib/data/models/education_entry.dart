import 'package:hive/hive.dart';

part 'education_entry.g.dart';

@HiveType(typeId: 2)
class EducationEntry {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String degree; // "BS Computer Science"

  @HiveField(2)
  final String institution;

  @HiveField(3)
  final String startYear;

  @HiveField(4)
  final String endYear; // or "Present"

  @HiveField(5)
  final String? grade; // CGPA or percentage

  @HiveField(6)
  final String? description;

  EducationEntry({
    required this.id,
    required this.degree,
    required this.institution,
    required this.startYear,
    required this.endYear,
    this.grade,
    this.description,
  });

  EducationEntry copyWith({
    String? id,
    String? degree,
    String? institution,
    String? startYear,
    String? endYear,
    String? grade,
    String? description,
  }) {
    return EducationEntry(
      id: id ?? this.id,
      degree: degree ?? this.degree,
      institution: institution ?? this.institution,
      startYear: startYear ?? this.startYear,
      endYear: endYear ?? this.endYear,
      grade: grade ?? this.grade,
      description: description ?? this.description,
    );
  }
}
