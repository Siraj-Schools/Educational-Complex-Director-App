import 'package:dio/dio.dart';
import 'package:educational_complex_director_app/models/helpers/paginated_response.dart';
import 'package:educational_complex_director_app/models/school/school.dart';
import 'package:educational_complex_director_app/models/school/school_details.dart';
import 'package:educational_complex_director_app/services/dio.dart';
import 'package:educational_complex_director_app/services/log_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SchoolServices {
  const SchoolServices({required this.dio});
  final Dio dio;

  Future<PaginatedResponse<School>> getSchools({
    required String token,
    String searchQuery = '',
    int page = 1,
    int pageSize = 6,
  }) async {
    final response = await dio.get(
      '/schools',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      queryParameters: {
        if (searchQuery.isNotEmpty) 'SearchTerm': searchQuery,
        'page': page,
        'pageSize': pageSize,
      },
    );
    if (response.statusCode != 200) {
      LogService.e(response.data['title']);
      throw Exception('Failed to load schools');
    }
    return PaginatedResponse.fromJson(response.data);
  }

  Future<SchoolDetails> getSchool({
    required String token,
    required String id,
  }) async {
    final response = await dio.get(
      '/schools/$id',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response.statusCode != 200) {
      LogService.e(response.data['title']);
      throw Exception('Failed to load school');
    }
    return SchoolDetails.fromJson(response.data);
  }

  Future<void> createSchool({
    required String token,
    required Map<String, dynamic> body,
  }) async {
    final response = await dio.post(
      '/schools',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      data: body,
    );
    if (response.statusCode != 200 && response.statusCode != 500) {
      LogService.e(response.data['title']);
      throw Exception('Failed to create school');
    }
  }

  Future<void> updateSchool({
    required String token,
    required String id,
    required Map<String, dynamic> body,
  }) async {
    final response = await dio.put(
      '/schools/$id',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      data: body,
    );

    if (response.statusCode != 204) {
      LogService.e(response.data['title']);
      throw Exception('Failed to update school');
    }
  }

  Future<void> removeManager({
    required String token,
    required String id,
  }) async {
    final response = await dio.delete(
      '/schools/$id/manager',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response.statusCode != 204) {
      LogService.e(response.data['title']);
      throw Exception('Failed to remove manager');
    }
  }

  Future<void> changeManager({
    required String token,
    required String schoolId,
    required String newManagerId,
  }) async {
    final response = await dio.put(
      '/schools/$schoolId/manager',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      data: {
        'newManagerUserId': newManagerId,
      },
    );
    if (response.statusCode != 204) {
      LogService.e(response.data['title']);
      throw Exception('Failed to change manager');
    }
  }
}

final schoolServiceProvider = Provider<SchoolServices>(
  (ref) => SchoolServices(dio: ref.read(dioProvider)),
);
