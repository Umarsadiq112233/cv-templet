import 'package:hive/hive.dart';

part 'project_entry.g.dart';

@HiveType(typeId: 5)
class ProjectEntry {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final List<String> technologies;

  @HiveField(4)
  final String? githubUrl;

  @HiveField(5)
  final String? liveUrl;

  @HiveField(6)
  final String? duration;

  ProjectEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.technologies,
    this.githubUrl,
    this.liveUrl,
    this.duration,
  });

  ProjectEntry copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? technologies,
    String? githubUrl,
    String? liveUrl,
    String? duration,
  }) {
    return ProjectEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      technologies: technologies ?? this.technologies,
      githubUrl: githubUrl ?? this.githubUrl,
      liveUrl: liveUrl ?? this.liveUrl,
      duration: duration ?? this.duration,
    );
  }
}
