import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';

/// Shows a notification
ToastificationItem naShowNotificationCustom({
  required BuildContext? context,
  required ToastificationType type,
  required Widget title,
  Widget? description,
  bool showIcon = true,
  ToastificationCallbacks? callbacks,
  int seconds = 2,
  Duration? animationDuration,
  DismissDirection? dismissDirection,
  bool closable = true,
}) {
  if (!(context?.mounted ?? false)) {
    return ToastificationItem(
      builder  : (context, holder) => Container(),
      alignment: Alignment.topCenter
    );
  }

  return toastification.show(
    context          : context,
    type             : type,
    style            : ToastificationStyle.flat,
    autoCloseDuration: seconds == 0 ? null : Duration(seconds: seconds),
    animationDuration: animationDuration,
    dismissDirection : dismissDirection,
    title            : title,
    description      : description,
    alignment        : Alignment.topCenter,
    showIcon         : showIcon,                     // show or hide the icon
    showProgressBar  : false,
    closeButton      : ToastCloseButton(
      showType: CloseButtonShowType.onHover
    ),
    closeOnClick     : closable,
    pauseOnHover     : true,
    dragToClose      : closable,
    applyBlurEffect  : true,
//    foregroundColor    : platformTextColor(context),
//    backgroundColor    : lightDartTheme(
//      context,
//      ifLight: null,
//      ifDark : QColorsDark.notificationBackground
//    ),
    callbacks        : callbacks ?? const ToastificationCallbacks()
  );
}
