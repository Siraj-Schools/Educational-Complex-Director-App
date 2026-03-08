import 'package:educational_complex_director_app/models/school/school.dart';
import 'package:educational_complex_director_app/models/school/school_manager.dart';

class SchoolDetails {
  final School school;
  final SchoolManager manager;
  final List<String> details;

  SchoolDetails({
    required this.school,
    required this.manager,
    required this.details,
  });

  factory SchoolDetails.fromJson(Map<String, dynamic> json) {
    return SchoolDetails(
      school: School.fromJson(json),
      manager: SchoolManager.fromJson(json['manager']),
      details: List<String>.from(json['details'] ?? []),
    );
  }
}
