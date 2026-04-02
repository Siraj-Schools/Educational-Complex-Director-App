import 'package:dio/dio.dart';
import 'package:educational_complex_director_app/models/helpers/paginated_response.dart';
import 'package:educational_complex_director_app/models/school/school_manager.dart';

import 'package:educational_complex_director_app/services/dio.dart';
import 'package:educational_complex_director_app/services/log_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SchoolMangerServices {
  final Dio dio;
  SchoolMangerServices({required this.dio});

  Future<PaginatedResponse<SchoolManager>> getManagers({
    required String token,
    String searchQuery = '',
    int page = 1,
    int pageSize = 6,
  }) async {
    final response = await dio.get(
      '/managers',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      queryParameters: {
        if (searchQuery.isNotEmpty) 'SearchTerm': searchQuery,
        'PageNumber': page,
        'PageSize': pageSize,
      },
    );
    if (response.statusCode != 200) {
      LogService.e(response.data['title']);
      throw Exception('Failed to load managers');
    }
    return PaginatedResponse.fromJson(response.data);
  }

  Future<SchoolManager> getManager({
    required String token,
    required String managerId,
  }) async {
    final response = await dio.get(
      '/managers/$managerId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response.statusCode != 200) {
      LogService.e(response.data['title']);
      throw Exception('Failed to load manager');
    }
    return SchoolManager.fromJson(response.data);
  }

  Future<void> createManager({
    required String token,
    required Map<String, dynamic> body,
  }) async {
    final response = await dio.post(
      '/managers',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      data: body,
    );
    if (response.statusCode != 201) {
      LogService.e(response.data['title']);
      throw Exception('Failed to create manager');
    }
  }

  Future<void> updateManager({
    required String token,
    required String managerId,
    required Map<String, dynamic> body,
  }) async {
    final response = await dio.patch(
      '/managers/$managerId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
      data: body,
    );
    if (response.statusCode != 204) {
      LogService.e(response.data['title']);
      throw Exception('Failed to update manager');
    }
  }
}

final schoolMangerServiceProvider = Provider<SchoolMangerServices>(
  (ref) => SchoolMangerServices(dio: ref.read(dioProvider)),
);
