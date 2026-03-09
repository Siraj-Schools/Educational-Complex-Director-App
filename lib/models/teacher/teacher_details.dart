class TeacherDetails {
  final String id;
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
  final String gender;
  final DateTime dateOfBirth;
  final String maritalStatus;
  final String joiningDateUtc;

  final String cityName;
  final String stateName;
  final String countryName;

  final String schoolId;
  final String schoolName;
  final String schoolEmail;
  final String schoolPhone;
  final String schoolAddress;
  final String schoolEMISNumber;

  final String schoolCityName;
  final String schoolStateName;
  final String schoolTypeName;

  final String schoolAcademicYearId;
  final String academicYearName;
  final DateTime academicYearStartDate;
  final DateTime academicYearEndDate;

  final String qualificationName;
  final String qualificationType;
  final String designation;

  TeacherDetails({
    required this.id,
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
    required this.joiningDateUtc,
    required this.cityName,
    required this.stateName,
    required this.countryName,
    required this.schoolId,
    required this.schoolName,
    required this.schoolEmail,
    required this.schoolPhone,
    required this.schoolAddress,
    required this.schoolEMISNumber,
    required this.schoolCityName,
    required this.schoolStateName,
    required this.schoolTypeName,
    required this.schoolAcademicYearId,
    required this.academicYearName,
    required this.academicYearStartDate,
    required this.academicYearEndDate,
    required this.qualificationName,
    required this.qualificationType,
    required this.designation,
  });

  factory TeacherDetails.fromJson(Map<String, dynamic> json) {
    return TeacherDetails(
      id: json['id'],
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
      gender: json['gender'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      maritalStatus: json['maritalStatus'],
      joiningDateUtc: json['joiningDateUtc'],
      cityName: json['cityName'],
      stateName: json['stateName'],
      countryName: json['countryName'],
      schoolId: json['schoolId'],
      schoolName: json['schoolName'],
      schoolEmail: json['schoolEmail'],
      schoolPhone: json['schoolPhone'],
      schoolAddress: json['schoolAddress'],
      schoolEMISNumber: json['schoolEMISNumber'],
      schoolCityName: json['schoolCityName'],
      schoolStateName: json['schoolStateName'],
      schoolTypeName: json['schoolTypeName'],
      schoolAcademicYearId: json['schoolAcademicYearId'],
      academicYearName: json['academicYearName'],
      academicYearStartDate: DateTime.parse(json['academicYearStartDate']),
      academicYearEndDate: DateTime.parse(json['academicYearEndDate']),
      qualificationName: json['qualificationName'],
      qualificationType: json['qualificationType'],
      designation: json['designation'],
    );
  }
}
