import 'package:educational_complex_director_app/Repositories/school_repository.dart';

import 'package:educational_complex_director_app/models/school/standard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final standardsNotifierProvider = FutureProvider.family<List<Standard>, String>(
  (
    ref,
    schoolId,
  ) async {
    return await ref
        .read(schoolRepositoryProvider)
        .getSchoolStandards(schoolId: schoolId);
  },
);
