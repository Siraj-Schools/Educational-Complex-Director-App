import 'dart:ui';
import 'package:educational_complex_director_app/l10n/app_localizations.dart';
import 'package:educational_complex_director_app/utils/s_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';

class NotificationsDialog extends ConsumerWidget {
  const NotificationsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    SConfig.init(context);
    // final double dialogWidth =
    //     (SConfig.widthSize ?? 400) * (SConfig.isMobile() ? 0.9 : 0.45);

    // 🔔 Dummy notifications
    final notifications = [
      {
        "title": "تمت إضافة درس جديد",
        "body": "تم نشر درس جديد في مقرر الرياضيات.",
        "isRead": false,
      },
      {
        "title": "تمت إضافة درس جديد",
        "body": "تم نشر درس جديد في مقرر الرياضيات.",
        "isRead": false,
      },
      {
        "title": "تم تحديث الجدول",
        "body": "تم تعديل موعد الحصة القادمة.",
        "isRead": true,
      },
      {
        "title": "إشعار إداري",
        "body": "يرجى استكمال البيانات الشخصية.",
        "isRead": false,
      },
    ];

    return Dialog(
      backgroundColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          // width: dialogWidth,
          constraints:const BoxConstraints(
          
            maxWidth: 450,
          ),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark
                ? SConfig.secondaryBackground.withAlpha(64)
                : Colors.white.withAlpha(242),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: SConfig.primaryColor.withAlpha(38),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(38),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔷 Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.notifications,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (Get.isDialogOpen!) {
                        Get.back();
                      }
                    } ,
                    icon: const Icon(Icons.close),
                    color: SConfig.primaryColor,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🔔 Notifications List
              SizedBox(
                height: 300,
                child: ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    final bool isRead = notification["isRead"] as bool;

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isRead
                            ? SConfig.secondaryBackground.withAlpha(48)
                            : SConfig.highlightColor.withAlpha(38),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isRead
                              ? SConfig.primaryColor.withAlpha(25)
                              : SConfig.accentColor.withAlpha(102),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isRead
                                    ? Icons.notifications_none
                                    : Icons.notifications,
                                color: isRead
                                    ? SConfig.primaryColor
                                    : SConfig.accentColor,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  notification["title"] as String,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            notification["body"] as String,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // 🔘 Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SConfig.secondaryBackground,
                        padding: const EdgeInsets.all(16),
                       
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(

                        maxLines: 1,
                        AppLocalizations.of(context)!.markAllAsRead,
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge!.copyWith(fontSize:SConfig.isMobile() ? 16 : 19),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),

                        backgroundColor: SConfig.errorColor.withAlpha(210),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.deleteAll,
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge!.copyWith(fontSize:SConfig.isMobile() ? 16 : 19),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
