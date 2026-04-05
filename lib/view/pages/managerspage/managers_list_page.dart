import 'dart:async';

import 'package:educational_complex_director_app/l10n/app_localizations.dart';

// ignore: unused_import
import 'package:educational_complex_director_app/models/school/school.dart';
import 'package:educational_complex_director_app/routes/routes.dart';

import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:educational_complex_director_app/view/components/error_dialog.dart';
import 'package:educational_complex_director_app/view/pages/managerspage/manager_card.dart';

import 'package:educational_complex_director_app/view_model/schoolmanager/school_managers.dart';
import 'package:educational_complex_director_app/view_model/user.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ManagersListPage extends ConsumerStatefulWidget {
  const ManagersListPage({super.key});

  @override
  ConsumerState<ManagersListPage> createState() => _ManagersListPageState();
}

class _ManagersListPageState extends ConsumerState<ManagersListPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  // String? selectedTypeId;
  // String? selectedtCityId;
  // String? selectedStateId;
  // Widget buildDropdown({
  //   required String label,
  //   required List<LookupItem> items,
  //   required String? value,
  //   required Function(String?) onChanged,
  //   required AppLocalizations loc,
  // }) {
  //   return DropdownButtonFormField<String?>(
  //     initialValue: value,
  //     menuMaxHeight: 300,
  //     isExpanded: true,
  //     decoration: InputDecoration(
  //       labelText: label,
  //     ),
  //     items: [
  //       DropdownMenuItem(
  //         value: null,
  //         child: Text(loc.all),
  //       ),
  //       ...items.map(
  //         (e) => DropdownMenuItem(
  //           value: e.id,
  //           child: Text(e.value),
  //         ),
  //       ),
  //     ],
  //     onChanged: onChanged,
  //   );
  // }
  Widget filterField(Widget child, {bool? smaller}) {
    double? width;

    if (SConfig.isMobile()) {
      width = null;
    } else if (SConfig.isTablet()) {
      width = 200;
    } else {
      width = 220;
    }

    return SizedBox(
      width: width,
      child: child,
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(schoolManagersNotifierProvider(true).notifier);
    super.build(context);
    final loc = AppLocalizations.of(context)!;
    final searchQuery = notifier.searchQuery;
    if (searchController.text != searchQuery) {
      searchController.value = TextEditingValue(
        text: searchQuery,
        selection: TextSelection.collapsed(offset: searchQuery.length),
      );
    }

    SConfig.init(context);

    int crossAxisCount = 3;

    if (SConfig.isMobile()) {
      crossAxisCount = 1;
    } else if (SConfig.isTablet()) {
      crossAxisCount = 2;
    }
    const accent = Color(0xFF3F51B5); // Royal Blue

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(200),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: SConfig.primaryColor.withAlpha(40),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: SConfig.primaryColor.withAlpha(15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                /// SEARCH
                filterField(
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: loc.searchManager,
                      prefixIcon: const Icon(Icons.search),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: accent,
                          width: 1,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: accent,
                          width: 1,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      _debounce?.cancel();
                      _debounce = Timer(
                        const Duration(milliseconds: 400),
                        () async {
                          await notifier.search(searchController.text);
                        },
                      );
                    },
                  ),
                ),

                // /// SCHOOL TYPE
                // filterField(
                //   buildDropdown(
                //     label: loc.schoolType,
                //     value: selectedTypeId,
                //     items: getSchoolTypes(loc),
                //     loc: loc,
                //     onChanged: (v) {
                //       setState(() => selectedTypeId = v);
                //     },
                //   ),
                //   smaller: true,
                // ),

                // /// STATE
                // filterField(
                //   buildDropdown(
                //     label: loc.stateId,
                //     value: selectedStateId,
                //     items: getSyrianStates(loc),
                //     loc: loc,
                //     onChanged: (v) {
                //       setState(() => selectedStateId = v);
                //     },
                //   ),
                //   smaller: true,
                // ),

                // /// CITY
                // filterField(
                //   buildDropdown(
                //     label: loc.cityId,
                //     value: selectedtCityId,
                //     items: getSyrianStates(loc),
                //     loc: loc,
                //     onChanged: (v) {
                //       setState(() => selectedtCityId = v);
                //     },
                //   ),
                //   smaller: true,
                // ),

                /// ADD BUTTON
                if (ref.watch(userViewModelProvider).value?.isDirector ?? false)
                  SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        shadowColor: accent.withAlpha(100),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () => Get.toNamed(
                        Sroutes.addManager,
                        id: Sroutes.managersNavigationId,
                      ),
                      icon: const Icon(
                        Icons.person_add_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      iconAlignment: IconAlignment.start,
                      label: Text(
                        loc.addManager,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          SConfig.spaceMedium,
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent * 0.8 &&
                  !notifier.isLoadingMore &&
                  notifier.errorLoadingMore == null &&
                  notifier.hasNextPage) {
                notifier.loadMore();
              }
              return false;
            },
            child: Expanded(
              child: ref
                  .watch(schoolManagersNotifierProvider(true))
                  .when(
                    data: (data) {
                      if (data.isEmpty) {
                        return Center(
                          child: Text(
                            loc.noDataFound,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        );
                      }
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 20,

                                    mainAxisExtent: 422,
                                  ),

                              itemCount: data.length,
                              itemBuilder: (_, index) {
                                return ManagerCard(manager: data[index]);

                                // }
                              },
                            ),
                            if (notifier.isLoadingMore)
                              SizedBox(
                                width: double.infinity,
                                child: Center(
                                  child: LoadingAnimationWidget.waveDots(
                                    color: accent.withAlpha(180),
                                    size: 90,
                                  ),
                                ),
                              ),

                            if (notifier.errorLoadingMore != null)
                              SizedBox(
                                width: double.infinity,
                                child: Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: SConfig.errorColor,
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () async {
                                      await notifier.loadMore();
                                    },
                                    child: Text(loc.retry),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                    error: (error, stack) {
                      return Center(
                        child: ErrorDialog(
                          message: loc.errorOccurred,
                          blur: 0,
                          okText: loc.retry,
                          onOK: () async {
                            await notifier.refresh();
                          },
                        ),
                      );
                    },
                    loading: () {
                      return Center(
                        child: LoadingAnimationWidget.hexagonDots(
                          color: accent.withAlpha(180),
                          size: 90,
                        ),
                      );
                    },
                  ),
            ),
          ),

          /// GRID
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
