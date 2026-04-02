class School {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String stateName;
  final String cityName;
  final String schoolTypeName;
  final String schoolTypeDescription;
  final String schoolType;
  final String emisNumber;

  School({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.stateName,
    required this.cityName,
    required this.schoolTypeName,
    required this.schoolTypeDescription,
    required this.schoolType,
    required this.emisNumber,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      stateName: json['stateName'],
      cityName: json['cityName'],
      schoolTypeName: json['schoolTypeName'],
      schoolTypeDescription: json['schoolTypeDescription'],
      schoolType: json['schoolType'],
      emisNumber: json['emisNumber'],
    );
  }
  factory School.fromTeacherDetailsApi(Map<String, dynamic> json) {
    return School(
      id: json['schoolId'],
      name: json['schoolName'],
      email: json['schoolEmail'],
      phone: json['schoolPhone'],
      address: json['schoolAddress'],
      stateName: json['schoolStateName'],
      cityName: json['schoolCityName'],
      schoolTypeName: "",
      schoolTypeDescription: "",
      schoolType: json['schoolTypeName'],
      emisNumber: json['schoolEMISNumber'],
    );
  }
}
