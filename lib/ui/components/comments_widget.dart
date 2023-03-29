import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vendor/core/model/comment_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommentWidget extends StatelessWidget {
  final RateModel rateModel;

  const CommentWidget({Key? key, required this.rateModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
      margin: EdgeInsets.zero,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).other_screen_security+":"),
                Row(
                  children: [
                    Text(rateModel.security.toStringAsFixed(2)),
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).other_screen_accessibility+":"),
                Row(
                  children: [
                    Text(rateModel.accessibility.toStringAsFixed(2)),
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).other_screen_service+":"),
                Row(
                  children: [
                    Text(rateModel.serviceQuality.toStringAsFixed(2)),
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).comment_screen_rate_date),
                Text(DateFormat('dd-MM-yyyy – kk:mm')
                    .format(rateModel.commentDate.toDate())),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context).other_screen_comments+": "),
                Expanded(child: Text(rateModel.message != "" ? rateModel.message : "-",))
              ],
            ),
          ],
        ),
      ),
    );
  }
}