import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';

import 'notification-custom.service.dart';

/// Shows a notification
ToastificationItem naShowNotification({
  required BuildContext? context,
  required ToastificationType type,
  required String title,
  String? subtitle,
  bool showIcon = true,
  ToastificationCallbacks? callbacks,
  int seconds = 2,
  Duration? animationDuration,
  DismissDirection? dismissDirection
}) {
  return naShowNotificationCustom(
    context          : context,
    type             : type,
    title            : Text(
      title,
      overflow: TextOverflow.visible,
    ),
    description      : (subtitle?.isEmpty ?? true)
      ? null
      : RichText(
          text: TextSpan(
            text: subtitle!,
            style: TextStyle(
              color    : Color(0xff000000),//platformTextColor(context),
              fontStyle: FontStyle.italic
            )
          )
        )
    ,
    showIcon         : showIcon,
    callbacks        : callbacks,
    seconds          : seconds,
    animationDuration: animationDuration,
    dismissDirection : dismissDirection,
  );
}

/// Shows a notification error
void naShowNotificationException({
  required BuildContext? context,
  ToastificationType type = ToastificationType.error,
  required String title,
  required Object? error,
  String Function()? errorFunction,
  bool showIcon = true,
  int seconds = 10,
  ToastificationCallbacks? callbacks,
}) {
  String  errorTitle   = title;
  String? errorDetails = errorFunction?.call() ?? error?.toString() ?? '';

  naShowNotification(
    context  : context,
    type     : ToastificationType.error,
    title    : errorTitle,
    subtitle : errorDetails,
    showIcon : showIcon,
    seconds  : seconds,
    callbacks: callbacks
  );
}

/// Hides the notification
void naHideNotification(
  ToastificationItem notification,
  {
    bool showRemoveAnimation = true
  }
) {
  toastification.dismiss(notification, showRemoveAnimation: showRemoveAnimation);
}
