import 'package:educational_complex_director_app/models/constants/gender.dart';
import 'package:educational_complex_director_app/models/student/parent.dart';
import 'package:educational_complex_director_app/models/student/student.dart';

class StudentDetails {
  final Student student;
  final Parent parent;
  final String registrationNumber;
  final String userName;
  final String fullName;
  final String mobileNumber;
  final GenderEnum gender;
  final DateTime dateOfBirth;

  StudentDetails({
    required this.student,
    required this.parent,
    required this.registrationNumber,
    required this.userName,
    required this.fullName,
    required this.mobileNumber,
    required this.gender,
    required this.dateOfBirth,
  });

  factory StudentDetails.fromJson(Map<String, dynamic> json) {
    return StudentDetails(
      student: Student.fromJson(json),
      parent: Parent.fromJson(json),
      registrationNumber: json['registrationNumber'],
      userName: json['userName'],
      fullName: json['fullName'],
      mobileNumber: json['mobileNumber'],
      gender: GenderEnum.values.firstWhere(
        (e) => e.name == json['gender'],
      ),
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
    );
  }
}
