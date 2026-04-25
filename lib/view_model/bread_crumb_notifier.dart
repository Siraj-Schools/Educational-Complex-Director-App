import 'package:educational_complex_director_app/routes/enums/screen_names.dart';
import 'package:flutter_riverpod/legacy.dart';

class BreadCrumbNotifier extends StateNotifier<List<ScreenNames>> {
  BreadCrumbNotifier(ScreenNames root) : super([root]);

  void push(ScreenNames screen) {
    state = [...state, screen];
  }

  void pop() {
    if (state.length > 1) {
      state = state.sublist(0, state.length - 1);
    }
  }

  void replace(ScreenNames screen) {
    final list = [...state];
    list[list.length - 1] = screen;
    state = list;
  }

  void setPath(List<ScreenNames> screens) {
    state = screens;
  }

  void reset(ScreenNames root) {
    state = [root];
  }
}

final schoolsBreadcrumbProvider =
    StateNotifierProvider<BreadCrumbNotifier, List<ScreenNames>>(
      (ref) => BreadCrumbNotifier(ScreenNames.schools),
    );

final teachersBreadcrumbProvider =
    StateNotifierProvider<BreadCrumbNotifier, List<ScreenNames>>(
      (ref) => BreadCrumbNotifier(ScreenNames.teachers),
    );

final managersBreadcrumbProvider =
    StateNotifierProvider<BreadCrumbNotifier, List<ScreenNames>>(
      (ref) => BreadCrumbNotifier(ScreenNames.managers),
    );

final studentsBreadcrumbProvider =
    StateNotifierProvider<BreadCrumbNotifier, List<ScreenNames>>(
      (ref) => BreadCrumbNotifier(ScreenNames.students),
    );

final settingsBreadcrumbProvider =
    StateNotifierProvider<BreadCrumbNotifier, List<ScreenNames>>(
      (ref) => BreadCrumbNotifier(ScreenNames.settings),
    );
final activePageProvider = StateProvider.autoDispose<int>((ref) => 0);
