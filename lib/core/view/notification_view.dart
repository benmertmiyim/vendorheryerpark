import 'package:flutter/material.dart';
import 'package:vendor/core/base/notification_base.dart';
import 'package:vendor/core/model/notification_model.dart';
import 'package:vendor/core/service/notification_service.dart';
import 'package:vendor/locator.dart';

enum NotificationProcess {
  idle,
  busy,
}

class NotificationView with ChangeNotifier implements NotificationBase {
  NotificationService notificationService = locator<NotificationService>();
  NotificationProcess _notificationProcess = NotificationProcess.idle;
  List<NotificationModel> notificationList = [];

  NotificationProcess get notificationProcess => _notificationProcess;

  set notificationProcess(NotificationProcess value) {
    _notificationProcess = value;
    notifyListeners();
  }

  NotificationView() {
    getNotifications();
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      notificationProcess = NotificationProcess.busy;
      notificationList = await notificationService.getNotifications();
      return notificationList;
    } catch (e) {
      debugPrint(
        "NotificationView - Exception - Get Notifications : ${e.toString()}",
      );
      return [];
    }finally {
      notificationProcess = NotificationProcess.idle;
    }
  }

  @override
  Future deleteNotification(String id) async {
    try {
      notificationProcess = NotificationProcess.busy;
      await notificationService.deleteNotification(id);
      notificationList.removeWhere((model) => model.id == id);
    } catch (e) {
      debugPrint(
        "NotificationView - Exception - Delete Notifications : ${e.toString()}",
      );
    }finally {
      notificationProcess = NotificationProcess.idle;
    }
  }
}
