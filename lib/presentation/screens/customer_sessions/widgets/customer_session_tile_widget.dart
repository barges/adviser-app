import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/list_tile_content_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_sessions/customer_sessions_cubit.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class CustomerSessionListTileWidget extends StatelessWidget {
  const CustomerSessionListTileWidget({Key? key, required this.question})
      : super(key: key);

  final ChatItem question;

  @override
  Widget build(BuildContext context) {
    final CustomerSessionsCubit customerSessionsCubit =
        context.read<CustomerSessionsCubit>();
    return GestureDetector(
      onTap: () {
        customerSessionsCubit.goToChat(question);
      },
      child: SizedBox(
        height: 44.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44.0,
              height: 44.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2.0,
                ),
              ),
              child: SvgPicture.asset(
                question.ritualIdentifier?.iconPath ??
                    question.type?.iconPath ??
                    '',
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
                          question.ritualIdentifier?.sessionName ??
                              question.type?.typeName ??
                              '',
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontSize: 15.0,
                                  ),
                        ),
                      ),
                      Text(
                        question.updatedAt?.chatListTime ??
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
                            child: ListTileContentWidget(
                              question: question,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 32.0,
                        ),
                        if (question.hasUnanswered ?? false)
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
