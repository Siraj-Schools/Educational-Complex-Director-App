import 'package:educational_complex_director_app/models/academic_year.dart';
import 'package:educational_complex_director_app/models/constants/gender.dart';
import 'package:educational_complex_director_app/models/constants/marital_status.dart';
import 'package:educational_complex_director_app/models/constants/teacher_designation.dart';
import 'package:educational_complex_director_app/models/school/school.dart';
import 'package:educational_complex_director_app/models/teacher/teacher.dart';

class TeacherDetails {
  final String userName;
  final Teacher teacher;

  final GenderEnum gender;
  final DateTime dateOfBirth;
  final MaritalStatusEnum maritalStatus;

  final School? school;
  final AcademicYear academicYear;

  final TeacherDesignation designation;

  TeacherDetails({
    required this.userName,
    required this.teacher,

    required this.gender,
    required this.dateOfBirth,
    required this.maritalStatus,

    required this.designation,

    required this.school,
    required this.academicYear,
  });

  factory TeacherDetails.fromJson(Map<String, dynamic> json) {
    return TeacherDetails(
      teacher: Teacher.fromJson(json),
      userName: json['userName'],

      gender: GenderEnum.values.firstWhere(
        (element) => element.name == json['gender'],
        orElse: () => GenderEnum.None,
      ),
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      maritalStatus: MaritalStatusEnum.values.firstWhere(
        (element) => element.name == json['maritalStatus'],
        orElse: () => MaritalStatusEnum.None,
      ),

      school: School.fromTeacherDetailsApi(json),
      academicYear: AcademicYear.fromTeacherDetailsApi(json),

      designation: TeacherDesignation.values.firstWhere(
        (element) => element.name == json['designation'],
        orElse: () => TeacherDesignation.Others,
      ),
    );
  }
}
