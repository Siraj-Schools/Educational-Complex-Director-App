import 'package:educational_complex_director_app/models/school/school.dart';
import 'package:educational_complex_director_app/models/school/school_manager.dart';
import 'package:educational_complex_director_app/models/student.dart';
import 'package:educational_complex_director_app/models/teacher/teacher.dart';

class PaginatedResponse<T> {
  final int currentPage;
  final bool hasNextPage;
  final int pageSize;
  final List<T> list;
  const PaginatedResponse({
    required this.currentPage,
    required this.list,
    required this.pageSize,
    required this.hasNextPage,
  });

  factory PaginatedResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedResponse(
      currentPage: json["pageNumber"],
      list:
          (T == School
                  ? (json["items"] as List<dynamic>)
                        .map(
                          (e) => School.fromJson(e),
                        )
                        .toList()
                  : T == Teacher
                  ? (json["items"] as List<dynamic>)
                        .map(
                          (e) => Teacher.fromJson(e),
                        )
                        .toList()
                  : T == SchoolManager
                  ? (json["items"] as List<dynamic>)
                        .map(
                          (e) => SchoolManager.fromJson(e),
                        )
                        .toList()
                  : (json["items"] as List<dynamic>)
                        .map(
                          (e) => Student.fromJson(e),
                        )
                        .toList())
              as List<T>,
      pageSize: json["pageSize"],
      hasNextPage: json["hasNext"],
    );
  }
}
