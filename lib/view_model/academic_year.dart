import 'dart:async';

import 'package:educational_complex_director_app/Repositories/system_settings_repository.dart';
import 'package:educational_complex_director_app/models/academic_year.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AcademicYearNotifier extends AsyncNotifier<List<AcademicYear>> {
  Exception? error;
  @override
  FutureOr<List<AcademicYear>> build() async {
    return await getAcademicYears();
  }

  Future<List<AcademicYear>> getAcademicYears() async {
    return await ref.read(systemSettingsRepositoryProvider).getAcademicYears();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await getAcademicYears());
  }

  Future<void> createAcademicYear({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    error = null;
    ref.notifyListeners();
    try {
      await ref
          .read(systemSettingsRepositoryProvider)
          .createAcademicYear(
            startDate: startDate,
            endDate: endDate,
          );
    } catch (e) {
      if (e is Exception) {
        error = e;
      } else {
        error = Exception(e.toString());
      }
    }
    ref.notifyListeners();
  }
}

final academicYearProvider =
    AsyncNotifierProvider<AcademicYearNotifier, List<AcademicYear>>(
      () => AcademicYearNotifier(),
    );
