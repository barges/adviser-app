import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/chat/widgets/upselling_menu/canned_messages/canned_messages_cubit.dart';

const double cannedMessageContentPadding = 12.0;
const double paddingBetweenMessageAndEdit = 6.0;
const int displayMaxLines = 7;
const int editingMaxLines = 6;

class CannedMessageWidget extends StatefulWidget {
  final String message;
  final ValueChanged<String> onEditing;
  final int index;

  const CannedMessageWidget({
    Key? key,
    required this.message,
    required this.onEditing,
    required this.index,
  }) : super(key: key);

  @override
  State<CannedMessageWidget> createState() => _CannedMessageWidgetState();
}

class _CannedMessageWidgetState extends State<CannedMessageWidget> {
  static const int maxCount = 280;

  final TextEditingController _editingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final CannedMessagesCubit cannedMessagesCubit =
        context.read<CannedMessagesCubit>();

    final bool isEditing = context.select((CannedMessagesCubit cubit) =>
            cubit.state.editingCannedMessageIndex) ==
        widget.index;

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(cannedMessageContentPadding),
      decoration: BoxDecoration(
        color: isEditing ? theme.canvasColor : theme.primaryColor,
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor,
            offset: const Offset(-1.0, 0.0),
          ),
          BoxShadow(
            color: theme.primaryColor,
            offset: const Offset(1.0, 0.0),
          ),
          BoxShadow(
            color: theme.primaryColor,
            offset: const Offset(0.0, -1.0),
          ),
          BoxShadow(
            color: theme.primaryColor,
            offset: const Offset(0.0, 3.0),
          ),
        ],
      ),
      child: isEditing
          ? Scrollbar(
              child: TextField(
                controller: _editingController,
                scrollController: _scrollController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                minLines: 1,
                maxLines: editingMaxLines,
                style: theme.textTheme.bodyMedium,
                maxLength: maxCount,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
                onChanged: (value) {
                  cannedMessagesCubit.editedCannedMessage = value;
                  widget.onEditing(value);
                },
                buildCounter: (context,
                    {required currentLength, required isFocused, maxLength}) {
                  final bool limitReached =
                      maxLength != null && currentLength >= maxLength;
                  return Text(
                    '$currentLength/$maxLength',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 14.0,
                      color: limitReached ? AppColors.error : AppColors.online,
                    ),
                  );
                },
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message,
                  maxLines: displayMaxLines,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.backgroundColor,
                  ),
                ),
                if (!isEditing)
                  Padding(
                    padding: const EdgeInsets.only(
                        top: paddingBetweenMessageAndEdit),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            cannedMessagesCubit.setEditingIndex(widget.index);
                            _editingController.text = widget.message;
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                SZodiac.of(context).editZodiac,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.backgroundColor,
                                ),
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Assets.zodiac.vectors.editIcon.svg(
                                height: AppConstants.iconSize,
                                width: AppConstants.iconSize,
                                colorFilter: ColorFilter.mode(
                                  theme.backgroundColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
    );
  }
}
