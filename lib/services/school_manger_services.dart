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
}

final schoolMangerServiceProvider = Provider<SchoolMangerServices>(
  (ref) => SchoolMangerServices(dio: ref.read(dioProvider)),
);
