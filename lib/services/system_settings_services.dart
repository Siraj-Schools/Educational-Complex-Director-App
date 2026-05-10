import 'package:dio/dio.dart';
import 'package:educational_complex_director_app/models/academic_year.dart';
import 'package:educational_complex_director_app/models/system_settings.dart';
import 'package:educational_complex_director_app/services/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SystemSettingsServices {
  final Dio dio;
  const SystemSettingsServices(this.dio);

  Future<SystemSettings> getSystemSettings({
    required String token,
  }) async {
    final response = await dio.get(
      '/system-settings',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode != 200) {
      throw Exception(response.data["title"]);
    }
    return SystemSettings.fromJson(response.data);
  }

  Future<List<AcademicYear>> getAcademicYears({
    required String token,
  }) async {
    final response = await dio.get(
      '/academic-years',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      queryParameters: {"Page": 1, "PageSize": 1000},
    );
    if (response.statusCode != 200) {
      throw Exception(response.data["title"]);
    }
    return (response.data["items"] as List<dynamic>)
        .map((e) => AcademicYear.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> createAcademicYear({
    required String token,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await dio.post(
      '/academic-years',
      data: {
        "startDate": startDate.toIso8601String().split("T")[0],
        "endDate": endDate.toIso8601String().split("T")[0],
        "name": "${startDate.year}-${endDate.year}",
        "description": ".",
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode != 201 && response.statusCode != 500) {
      throw Exception(response.data["title"]);
    }
  }

  Future<void> updateCurrentChapter({
    required String token,
    required String chapterId,
  }) async {
    final response = await dio.patch(
      '/system-settings/chapter',
      data: {"chapterId": chapterId},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode != 204) {
      throw Exception(response.data["title"]);
    }
  }

  Future<void> updateCurrentAcademicYear({
    required String token,
    required String academicYearId,
  }) async {
    final response = await dio.patch(
      '/system-settings/academic-year',
      data: {"academicYearId": academicYearId},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode != 204) {
      throw Exception(response.data["title"]);
    }
  }

  Future<void> updateNextAcademicYear({
    required String token,
    required String academicYearId,
  }) async {
    final response = await dio.patch(
      '/system-settings/next-academic-year',
      data: {"academicYearId": academicYearId},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode != 204) {
      throw Exception(response.data["title"]);
    }
  }

  Future<void> updatePromotionStatus({
    required String token,
    required bool isPromotion,
  }) async {
    final response = await dio.patch(
      '/system-settings/promotion',
      data: {"isPromotion": isPromotion},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode != 204) {
      throw Exception(response.data["title"]);
    }
  }

  Future<void> updateChapterPromotionStatus({
    required String token,
    required bool isChapterPromotion,
  }) async {
    final response = await dio.patch(
      '/system-settings/chapter-promotion',
      data: {"isChapterPromotion": isChapterPromotion},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode != 204) {
      throw Exception(response.data["title"]);
    }
  }
}

final systemSettingsServicesProvider = Provider<SystemSettingsServices>((ref) {
  return SystemSettingsServices(ref.read(dioProvider));
});
