import 'package:flutter_base/common/feature_flags.dart';
import 'package:flutter_base/generated/l10n.dart';
import 'package:flutter_base/services/analytics/analytics_service.dart';
import 'package:flutter_base/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:flutter_base/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:flutter_base/ui/views/home/home_view.dart';
import 'package:flutter_base/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    // @stacked-route
  ],
  dependencies: [
    Singleton(classType: FeatureFlag),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: S),
    LazySingleton(classType: AnalyticsService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
  logger: StackedLogger(),
)
class App {}
