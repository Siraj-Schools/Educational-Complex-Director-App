import 'package:flutter_riverpod/legacy.dart';

enum SchoolsViewType {
  list,
  add,
  details,
}

class SchoolsPageState {
  final SchoolsViewType view;
  final String? schoolId;
  final bool isEditing;

  SchoolsPageState({
    required this.view,
    this.schoolId,

    this.isEditing = false,
  });

  SchoolsPageState copyWith({
    SchoolsViewType? view,
    String? schoolId,
    bool? isEditing,
  }) {
    return SchoolsPageState(
      view: view ?? this.view,
      schoolId: schoolId ?? this.schoolId,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}

class SchoolsPageViewModel extends StateNotifier<SchoolsPageState> {
  SchoolsPageViewModel() : super(SchoolsPageState(view: SchoolsViewType.list));
  
  void goToAdd() {
    
    state = state.copyWith(
      view: SchoolsViewType.add,
      schoolId: null,
    );
  }

  void goToDetails(String schoolId) {
    state = state.copyWith(
      view: SchoolsViewType.details,
      schoolId: schoolId,
      isEditing: false,
    );
  }

  void enableEdit() {
    state = state.copyWith(isEditing: true);
  }

  void goBackToList() {
    state = state.copyWith(
      view: SchoolsViewType.list,
      schoolId: null,
      isEditing: false,
    );
  }
}

final schoolsPageNavigationProvider =
    StateNotifierProvider<SchoolsPageViewModel, SchoolsPageState>(
      (ref) => SchoolsPageViewModel(),
    );
