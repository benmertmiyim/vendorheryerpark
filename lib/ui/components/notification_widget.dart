import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vendor/core/model/notification_model.dart';
import 'package:vendor/core/view/notification_view.dart';

class NotificationWidget extends StatefulWidget {
  final NotificationModel notificationModel;

  const NotificationWidget({
    Key? key,
    required this.notificationModel,
  }) : super(key: key);

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {


  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Row(
        children: const <Widget>[
          Icon(
            Icons.delete_outline,
          ),
          Text("Delete"),
        ],
      ),
      onDismissed: (direction) {
        Provider.of<NotificationView>(context, listen: false)
            .deleteNotification(widget.notificationModel.id);
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text("Notification deleted",),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      key: UniqueKey(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.notificationModel.title,
                ),
              ),
              Text(
                DateFormat('dd MMM yy - kk:mm')
                    .format(widget.notificationModel.sentDate),
              ),
            ],
          ),
          const SizedBox(height: 2,),
          Text(
            widget.notificationModel.message,
            ),
        ],
      ),
    );
  }
}
