import 'package:educational_complex_director_app/models/school.dart';
import 'package:educational_complex_director_app/models/school_manager.dart';

class SchoolDetails {
  final School school;
  final SchoolManager manager;
  final String moreInfo;
  SchoolDetails({
    required this.school,
    required this.manager,
    required this.moreInfo,
  });

  factory SchoolDetails.fromJson(Map<String, dynamic> json) {
    return SchoolDetails(
      school: School.fromJson(json['school']),
      manager: SchoolManager.fromJson(json['manager']),
      moreInfo: json['moreInfo'] ?? '',
    );
  }
}
