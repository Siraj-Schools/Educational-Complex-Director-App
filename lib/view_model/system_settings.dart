import 'dart:async';

import 'package:educational_complex_director_app/Repositories/system_settings_repository.dart';
import 'package:educational_complex_director_app/models/academic_year.dart';
import 'package:educational_complex_director_app/models/system_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SystemSettingsNotifier extends AsyncNotifier<SystemSettings> {
  Exception? error;
  @override
  FutureOr<SystemSettings> build() async {
    return await getSystemSettings();
  }

  Future<SystemSettings> getSystemSettings() async {
    return await ref.read(systemSettingsRepositoryProvider).getSystemSettings();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await getSystemSettings());
  }

  Future<void> updateCurrentChapter({
    required String chapterId,
  }) async {
    error = null;
    ref.notifyListeners();
    try {
      await ref
          .read(systemSettingsRepositoryProvider)
          .updateCurrentChapter(chapterId: chapterId);
    } catch (e) {
      if (e is Exception) {
        error = e;
      } else {
        error = Exception(e.toString());
      }
    }
    ref.notifyListeners();
  }

  Future<void> updateCurrentAcademicYear({
    required String academicYearId,
  }) async {
    error = null;
    ref.notifyListeners();
    try {
      await ref
          .read(systemSettingsRepositoryProvider)
          .updateCurrentAcademicYear(academicYearId: academicYearId);
    } catch (e) {
      if (e is Exception) {
        error = e;
      } else {
        error = Exception(e.toString());
      }
    }
    ref.notifyListeners();
  }

  Future<void> updateNextAcademicYear({
    required String academicYearId,
  }) async {
    error = null;
    ref.notifyListeners();
    try {
      await ref
          .read(systemSettingsRepositoryProvider)
          .updateNextAcademicYear(academicYearId: academicYearId);
    } catch (e) {
      if (e is Exception) {
        error = e;
      } else {
        error = Exception(e.toString());
      }
    }
    ref.notifyListeners();
  }

  Future<void> updatePromotionStatus({
    required bool isPromotion,
  }) async {
    error = null;
    ref.notifyListeners();
    try {
      await ref
          .read(systemSettingsRepositoryProvider)
          .updatePromotionStatus(isPromotion: isPromotion);
    } catch (e) {
      if (e is Exception) {
        error = e;
      } else {
        error = Exception(e.toString());
      }
    }
    ref.notifyListeners();
  }

  Future<void> updateChapterPromotionStatus({
    required bool isChapterPromotion,
  }) async {
    error = null;
    ref.notifyListeners();
    try {
      await ref
          .read(systemSettingsRepositoryProvider)
          .updateChapterPromotionStatus(isChapterPromotion: isChapterPromotion);
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

final systemSettingsProvider =
    AsyncNotifierProvider<SystemSettingsNotifier, SystemSettings>(
      () => SystemSettingsNotifier(),
    );
