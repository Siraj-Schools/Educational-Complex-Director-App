class Teacher {
  final String id;
  final String userId;
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String nationalId;
  final String mobileNumber;
  final String schoolId;
  final String schoolAcademicYearId;
  final String qualificationName;
  final String cityName;
  final String stateName;
  final String countryName;

  Teacher({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.nationalId,
    required this.mobileNumber,
    required this.schoolId,
    required this.schoolAcademicYearId,
    required this.qualificationName,
    required this.cityName,
    required this.stateName,
    required this.countryName,
  });

  String get fullName => "$firstName $middleName $lastName";

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      userId: json['userId'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      email: json['email'],
      nationalId: json['nationalId'],
      mobileNumber: json['mobileNumber'],
      schoolId: json['schoolId'],
      schoolAcademicYearId: json['schoolAcademicYearId'],
      qualificationName: json['qualificationName'],
      cityName: json['cityName'],
      stateName: json['stateName'],
      countryName: json['countryName'],
    );
  }
}
