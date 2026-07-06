import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';

import 'notification-custom.service.dart';
import '../widgets/notification-updatable/notification-updatable.widget.dart';

class NotificationUpdatable {
  final StreamController<Widget> titleController;
  final StreamController<Widget> subtitleController;
  final ToastificationItem notification;

  NotificationUpdatable({ required this.titleController, required this.subtitleController, required this.notification });
}

/// Shows an updatable notification
NotificationUpdatable naShowNotificationUpdatable({
  required BuildContext? context,
  required ToastificationType type,
  required Widget title,
  Widget? subtitle,
  bool showIcon = true,
  ToastificationCallbacks? callbacks,
  int seconds = 2,
  bool willHaveSubtitle = true
//  Duration? animationDuration,
//  DismissDirection? dismissDirection
}) {
  StreamController<Widget> notificationTitleController    = StreamController<Widget>();
  StreamController<Widget> notificationSubtitleController = StreamController<Widget>();

  NaNotificationUpdatable notificationTitle    = NaNotificationUpdatable(notificationTitleController.stream);
  NaNotificationUpdatable notificationSubtitle = NaNotificationUpdatable(notificationSubtitleController.stream);

  ToastificationItem notificationItem = naShowNotificationCustom(
    context    : context,
    type       : type,
    title      : notificationTitle,
    description: willHaveSubtitle ? notificationSubtitle : null,
    callbacks  : callbacks,
    showIcon   : showIcon,
    seconds    : seconds,
    closable   : seconds > 0
  );

  // Add initial view
  notificationTitleController.add(title);
  if (subtitle != null) {
    notificationSubtitleController.add(subtitle);
  }

  return NotificationUpdatable(
    titleController   : notificationTitleController,
    subtitleController: notificationSubtitleController,
    notification      : notificationItem
  );
}

/// Hides the updatable notification
void naHideNotificationUpdatable(NotificationUpdatable notification) {
  notification.titleController.close();
  notification.subtitleController.close();
  toastification.dismiss(notification.notification);
}
