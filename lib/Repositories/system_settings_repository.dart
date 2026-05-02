import 'package:educational_complex_director_app/models/academic_year.dart';
import 'package:educational_complex_director_app/models/system_settings.dart';
import 'package:educational_complex_director_app/services/local_storage_services.dart';
import 'package:educational_complex_director_app/services/log_services.dart';
import 'package:educational_complex_director_app/services/system_settings_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SystemSettingsRepository {
  final SystemSettingsServices systemSettingsServices;

  const SystemSettingsRepository({
    required this.systemSettingsServices,
  });

  Future<SystemSettings> getSystemSettings() async {
    try {
      final token = LocalStorageService.getToken;
      if (token == null) {
        throw Exception("Token is null");
      }
      return await systemSettingsServices.getSystemSettings(token: token);
    } catch (e) {
      LogService.e(e.toString());
      rethrow;
    }
  }

  Future<List<AcademicYear>> getAcademicYears() async {
    try {
      final token = LocalStorageService.getToken;
      if (token == null) {
        throw Exception("Token is null");
      }
      return await systemSettingsServices.getAcademicYears(token: token);
    } catch (e) {
      LogService.e(e.toString());
      rethrow;
    }
  }

  Future<void> createAcademicYear({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final token = LocalStorageService.getToken;
      if (token == null) {
        throw Exception("Token is null");
      }
      await systemSettingsServices.createAcademicYear(
        token: token,

        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      LogService.e(e.toString());
      rethrow;
    }
  }

  Future<void> updateCurrentChapter({required String chapterId}) async {
    try {
      final token = LocalStorageService.getToken;
      if (token == null) {
        throw Exception("Token is null");
      }
      await systemSettingsServices.updateCurrentChapter(
        token: token,
        chapterId: chapterId,
      );
    } catch (e) {
      LogService.e(e.toString());
      rethrow;
    }
  }

  Future<void> updateCurrentAcademicYear({
    required String academicYearId,
  }) async {
    try {
      final token = LocalStorageService.getToken;
      if (token == null) {
        throw Exception("Token is null");
      }
      await systemSettingsServices.updateCurrentAcademicYear(
        token: token,
        academicYearId: academicYearId,
      );
    } catch (e) {
      LogService.e(e.toString());
      rethrow;
    }
  }

  Future<void> updateNextAcademicYear({required String academicYearId}) async {
    try {
      final token = LocalStorageService.getToken;
      if (token == null) {
        throw Exception("Token is null");
      }
      await systemSettingsServices.updateNextAcademicYear(
        token: token,
        academicYearId: academicYearId,
      );
    } catch (e) {
      LogService.e(e.toString());
      rethrow;
    }
  }

  Future<void> updatePromotionStatus({required bool isPromotion}) async {
    try {
      final token = LocalStorageService.getToken;
      if (token == null) {
        throw Exception("Token is null");
      }
      await systemSettingsServices.updatePromotionStatus(
        token: token,
        isPromotion: isPromotion,
      );
    } catch (e) {
      LogService.e(e.toString());
      rethrow;
    }
  }

  Future<void> updateChapterPromotionStatus({
    required bool isChapterPromotion,
  }) async {
    try {
      final token = LocalStorageService.getToken;
      if (token == null) {
        throw Exception("Token is null");
      }
      await systemSettingsServices.updateChapterPromotionStatus(
        token: token,
        isChapterPromotion: isChapterPromotion,
      );
    } catch (e) {
      LogService.e(e.toString());
      rethrow;
    }
  }
}

final systemSettingsRepositoryProvider = Provider<SystemSettingsRepository>((
  ref,
) {
  return SystemSettingsRepository(
    systemSettingsServices: ref.read(systemSettingsServicesProvider),
  );
});
