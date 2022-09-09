import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:ez_tracker_app/resources/routes_manager.dart';

enum DialogAction {
  ok,
  cancel,
}

class DialogHelper {
  const DialogHelper._();

  static Future<DialogAction?> showOkDialog({
    String? title,
    String? message,
    String? okLabel,
  }) async {
    if (RouteGenerator.navigatorKey.currentContext != null) {
      OkCancelResult result = await showOkAlertDialog(
        context: RouteGenerator.navigatorKey.currentContext!,
        title: title,
        message: message,
        okLabel: okLabel,
      );
      if (result == OkCancelResult.ok) {
        return DialogAction.ok;
      }
      return DialogAction.cancel;
    }
    return null;
  }

  static Future<dynamic> showOkCancelDialog({
    String? title,
    String? message,
    String? okLabel,
  }) async {
    if (RouteGenerator.navigatorKey.currentContext != null) {
      OkCancelResult result = await showOkCancelAlertDialog(
        context: RouteGenerator.navigatorKey.currentContext!,
        title: title,
        message: message,
        okLabel: okLabel,
      );
      if (result == OkCancelResult.ok) {
        return DialogAction.ok;
      }
      return DialogAction.cancel;
    }

    return null;
  }
}
