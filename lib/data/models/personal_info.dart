import 'package:hive/hive.dart';

part 'personal_info.g.dart';

@HiveType(typeId: 1)
class PersonalInfo {
  @HiveField(0)
  final String fullName;

  @HiveField(1)
  final String jobTitle; // e.g. "Flutter Developer"

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String location; // City, Country

  @HiveField(5)
  final String? linkedIn;

  @HiveField(6)
  final String? github;

  @HiveField(7)
  final String? website;

  @HiveField(8)
  final String? profilePhotoPath; // local file path

  @HiveField(9)
  final String summary; // professional summary paragraph

  PersonalInfo({
    required this.fullName,
    required this.jobTitle,
    required this.email,
    required this.phone,
    required this.location,
    this.linkedIn,
    this.github,
    this.website,
    this.profilePhotoPath,
    required this.summary,
  });

  PersonalInfo copyWith({
    String? fullName,
    String? jobTitle,
    String? email,
    String? phone,
    String? location,
    String? linkedIn,
    String? github,
    String? website,
    String? profilePhotoPath,
    String? summary,
  }) {
    return PersonalInfo(
      fullName: fullName ?? this.fullName,
      jobTitle: jobTitle ?? this.jobTitle,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      linkedIn: linkedIn ?? this.linkedIn,
      github: github ?? this.github,
      website: website ?? this.website,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      summary: summary ?? this.summary,
    );
  }
}
