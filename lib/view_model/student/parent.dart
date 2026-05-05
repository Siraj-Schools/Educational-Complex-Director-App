import 'package:educational_complex_director_app/Repositories/student_repository.dart';
import 'package:educational_complex_director_app/models/student/parent.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final parentProvider = FutureProvider.family.autoDispose<Parent, String>((
  ref,
  nationalId,
) async {
  return await ref
      .read(studentRepositoryProvider)
      .getParent(nationalId: nationalId);
});
