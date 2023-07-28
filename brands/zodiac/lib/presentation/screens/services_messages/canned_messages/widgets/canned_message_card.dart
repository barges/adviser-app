import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';
import 'package:zodiac/data/models/canned_messages/canned_category.dart';
import 'package:zodiac/data/models/canned_messages/canned_message.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/services_messages/box_decoration_widget.dart';
import 'package:zodiac/presentation/screens/services_messages/canned_messages/canned_messages_cubit.dart';
import 'package:zodiac/presentation/screens/services_messages/canned_messages/widgets/edit_canned_message_widget.dart';

class CannedMessageCard extends StatelessWidget {
  final CannedMessage cannedMessage;
  const CannedMessageCard({
    super.key,
    required this.cannedMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    CannedMessagesCubit cannedMessagesCubit =
        context.read<CannedMessagesCubit>();
    return BoxDecorationWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cannedMessage.text ?? '',
            maxLines: 5,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 14.0,
              color: theme.shadowColor,
            ),
          ),
          const SizedBox(height: AppConstants.horizontalScreenPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cannedMessage.categoryName ?? '',
                maxLines: 5,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.primaryColor,
                ),
              ),
              const Spacer(),
              GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    cannedMessagesCubit.setUpdateCannedMessage(cannedMessage);
                    final CannedCategory? category =
                        cannedMessage.categoryId != null
                            ? cannedMessagesCubit
                                .getCategoryById(cannedMessage.categoryId!)
                            : null;
                    showModalBottomSheet<void>(
                      context: context,
                      useSafeArea: true,
                      builder: (BuildContext context) {
                        return EditCannedMessageWidget(
                            text: cannedMessage.text ?? '',
                            category: category,
                            categories: cannedMessagesCubit.state.categories,
                            onTextEdit: (text) =>
                                cannedMessagesCubit.setUpdatedText(text),
                            onSelectCategory: (index) =>
                                cannedMessagesCubit.setUpdateCategory(index),
                            onSave: () async {
                              if (await cannedMessagesCubit
                                  .updateCannedMessage()) {
                                context.popRoute();
                              }
                            });
                      },
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(21.0),
                            topRight: Radius.circular(21.0)),
                      ),
                      backgroundColor: Theme.of(context).canvasColor,
                    );
                  },
                  child: Assets.zodiac.vectors.edit.svg()),
              const SizedBox(width: 8.0),
              GestureDetector(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  if (await showOkCancelAlert(
                        context: context,
                        title:
                            SZodiac.of(context).doYouWantDeleteTemplateZodiac,
                        description: SZodiac.of(context)
                            .itWillBeRemovedFromTemplatesZodiac,
                        okText: SZodiac.of(context).deleteZodiac,
                        allowBarrierClick: false,
                        isCancelEnabled: true,
                      ) ==
                      true) {
                    cannedMessagesCubit.deleteCannedMessage(cannedMessage.id);
                  }
                },
                child: Assets.vectors.delete.svg(),
              )
            ],
          ),
        ],
      ),
    );
  }
}
