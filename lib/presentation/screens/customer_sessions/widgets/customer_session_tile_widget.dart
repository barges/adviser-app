import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/questions_type.dart';
import 'package:shared_advisor_interface/data/models/enums/sessions_types.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class CustomerSessionListTileWidget extends StatelessWidget {
  const CustomerSessionListTileWidget({Key? key, required this.item})
      : super(key: key);

  final ChatItem item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(90.0)),
            child: SvgPicture.asset(
              item.ritualIdentifier?.iconPath ?? '',
              height: AppConstants.iconSize,
              width: AppConstants.iconSize,
              fit: BoxFit.scaleDown,
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.ritualIdentifier?.sessionName ?? '',
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontSize: 15.0,
                                ),
                      ),
                    ),
                    Text(
                      item.createdAt?.chatListTime ??
                          DateTime.now().toUtc().chatListTime,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).shadowColor,
                            fontSize: 12.0,
                          ),
                    )
                  ],
                ),
                const SizedBox(height: 4.0),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: AppConstants.iconSize,
                          child: Text(
                            item.content ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color: item.type == ChatItemType.history
                                      ? Theme.of(context).shadowColor
                                      : AppColors.promotion,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 32.0,
                      ),
                      if (item.type != ChatItemType.history)
                        Container(
                          height: 8.0,
                          width: 8.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.promotion,
                          ),
                        ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
