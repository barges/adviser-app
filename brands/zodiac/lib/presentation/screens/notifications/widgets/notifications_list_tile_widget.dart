import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/data/models/notification/notification_item.dart';
import 'package:zodiac/presentation/common_widgets/app_image_widget.dart';
import 'package:zodiac/zodiac_extensions.dart';

class NotificationsListTileWidget extends StatelessWidget {
  final NotificationItem item;

  const NotificationsListTileWidget({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.horizontalScreenPadding,
        0.0,
        AppConstants.horizontalScreenPadding,
        8.0,
      ),
      child: Container(
        height: 72.0,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: theme.canvasColor,
        ),
        child: Row(children: [
          AppImageWidget(
            uri: Uri.parse(item.image ?? ''),
            width: 48.0,
            height: 48.0,
            radius: 8.0,
          ),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        item.pageTitle ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      item.dateCreate != null
                          ? DateTime.fromMillisecondsSinceEpoch(
                                  item.dateCreate! * 1000)
                              .listTime(context)
                          : '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12.0,
                            color: Theme.of(context).shadowColor,
                          ),
                    )
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        item.message ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 14.0,
                          color: theme.shadowColor,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
