import 'package:educational_complex_director_app/models/enums/gender.dart';

import 'package:educational_complex_director_app/models/enums/marital_status.dart';

class SchoolManager {
  final String managerEmail;
  final String userName;
  final String password;
  final String nationalId;
  final String firstName;
  final String middleName;
  final String lastName;
  final String managerMobileNumber;
  final GenderEnum gender;
  final DateTime dateOfBirth;
  final MaritalStatusEnum maritalStatus;
  final String managerCityId;
  final String managerStateId;
  final String managerCountryId;

  SchoolManager({
    required this.managerEmail,
    required this.userName,
    required this.password,
    required this.nationalId,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.managerMobileNumber,
    required this.gender,
    required this.dateOfBirth,
    required this.maritalStatus,
    required this.managerCityId,
    required this.managerStateId,
    required this.managerCountryId,
  });

  factory SchoolManager.fromJson(Map<String, dynamic> json) {
    return SchoolManager(
      managerEmail: json['managerEmail'],
      userName: json['userName'],
      password: json['password'],
      nationalId: json['nationalId'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      managerMobileNumber: json['managerMobileNumber'],
      gender: GenderEnum.values.firstWhere(
        (e) => e.name.toLowerCase() == json['gender'].toString().toLowerCase(),
      ),
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      maritalStatus: MaritalStatusEnum.values.firstWhere(
        (e) =>
            e.name.toLowerCase() ==
            json['maritalStatus'].toString().toLowerCase(),
      ),
      managerCityId: json['managerCityId'],
      managerStateId: json['managerStateId'],
      managerCountryId: json['managerCountryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'managerEmail': managerEmail,
      'userName': userName,
      'password': password,
      'nationalId': nationalId,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'managerMobileNumber': managerMobileNumber,
      'gender': gender.name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'maritalStatus': maritalStatus.name,
      'managerCityId': managerCityId,
      'managerStateId': managerStateId,
      'managerCountryId': managerCountryId,
    };
  }
}
