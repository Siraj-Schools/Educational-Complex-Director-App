import 'package:educational_complex_director_app/models/constants/qualifications.dart';

class Teacher {
  final String id;

  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String nationalId;
  final String registrationNumber;
  final String mobileNumber;
  final String schoolId;

  final QualificationEnum qualificationName;
  final String cityName;
  final String stateName;
  final String countryName;

  Teacher({
    required this.id,

    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.nationalId,
    required this.registrationNumber,
    required this.mobileNumber,
    required this.schoolId,

    required this.qualificationName,
    required this.cityName,
    required this.stateName,
    required this.countryName,
  });

  String get fullName => "$firstName $middleName $lastName";

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      email: json['email'],
      nationalId: json['nationalId'],
      registrationNumber: json['registrationNumber'],
      mobileNumber: json['mobileNumber'],
      schoolId: json['schoolId'],
      qualificationName: QualificationEnum.values.firstWhere(
        (element) => element.englishName == json['qualificationName'],
        orElse: () => QualificationEnum.None,
      ),
      cityName: json['cityName'],
      stateName: json['stateName'],
      countryName: json['countryName'],
    );
  }
}
