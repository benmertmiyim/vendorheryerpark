
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor/core/view/notification_view.dart';
import 'package:vendor/ui/components/notification_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late ThemeData theme;
  late NotificationView notificationView;

  Future _onRefresh() async {
    await notificationView.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    notificationView = Provider.of<NotificationView>(context);

    return Scaffold(
      appBar: AppBar(
        title:Text(AppLocalizations.of(context).notification_screen_notifications),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: notificationView.notificationList.isNotEmpty
              ? notificationView.notificationList
                  .map((model) => ListTile(
                        title: NotificationWidget(
                          notificationModel: model,
                        ),
                      ))
                  .toList()
              : [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(AppLocalizations.of(context).notification_screen_no_notifications,),
                    ),
                  )
                ],
        ),
      ),
    );
  }
}
