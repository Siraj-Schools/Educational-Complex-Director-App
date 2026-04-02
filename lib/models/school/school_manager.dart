import 'package:educational_complex_director_app/models/constants/gender.dart';
import 'package:educational_complex_director_app/models/constants/marital_status.dart';

class SchoolManager {
  final String userId;
  final String userName;
  final String email;
  final String nationalId;
  final String registrationNumber;
  final String firstName;
  final String middleName;
  final String lastName;
  final String fullName;
  final String mobileNumber;
  final GenderEnum gender;
  final DateTime dateOfBirth;
  final MaritalStatusEnum maritalStatus;
  final String cityName;
  final String stateName;
  final String countryName;
  final String joiningDateUtc;

  SchoolManager({
    required this.userId,
    required this.userName,
    required this.email,
    required this.nationalId,
    required this.registrationNumber,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.fullName,
    required this.mobileNumber,
    required this.gender,
    required this.dateOfBirth,
    required this.maritalStatus,
    required this.cityName,
    required this.stateName,
    required this.countryName,
    required this.joiningDateUtc,
  });

  factory SchoolManager.fromJson(Map<String, dynamic> json) {
    return SchoolManager(
      userId: json['userId'],
      userName: json['userName'],
      email: json['email'],
      nationalId: json['nationalId'],
      registrationNumber: json['registrationNumber'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      fullName: json['fullName'],
      mobileNumber: json['mobileNumber'],
      gender: GenderEnum.values.firstWhere((e) => e.name == json['gender']),
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      maritalStatus: MaritalStatusEnum.values.firstWhere(
        (e) => e.name == json['maritalStatus'],
      ),
      cityName: json['cityName'],
      stateName: json['stateName'],
      countryName: json['countryName'],
      joiningDateUtc: json['joiningDateUtc'],
    );
  }
}
