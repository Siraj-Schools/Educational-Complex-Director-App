class AcademicYear {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  AcademicYear({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  factory AcademicYear.fromJson(Map<String, dynamic> json) {
    return AcademicYear(
      id: json['id'],
      name: json['name'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
  factory AcademicYear.fromTeacherDetailsApi(Map<String, dynamic> json) {
    return AcademicYear(
      id: json['schoolAcademicYearId'] ?? '',
      name: json['academicYearName'],
      startDate: DateTime.parse(json['academicYearStartDate']),
      endDate: DateTime.parse(json['academicYearEndDate']),
    );
  }
}
