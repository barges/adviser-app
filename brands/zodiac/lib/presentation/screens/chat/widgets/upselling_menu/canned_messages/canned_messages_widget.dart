import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/models/canned_message/canned_message_category.dart';
import 'package:zodiac/data/models/canned_message/canned_message_model.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/upselling_menu/canned_messages/canned_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/upselling_menu/canned_messages/canned_messages_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/upselling_menu/category_menu_item_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/upselling_menu/upselling_header_widget.dart';

class CannedMessagesWidget extends StatelessWidget {
  const CannedMessagesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ChatCubit chatCubit = context.read<ChatCubit>();

    return BlocProvider(
      create: (context) => CannedMessagesCubit(),
      child: Builder(
        builder: (context) {
          final CannedMessagesCubit cannedMessagesCubit =
              context.read<CannedMessagesCubit>();

          final List<CannedMessageCategory>? cannedMessageCategories = context
              .select((ChatCubit cubit) => cubit.state.cannedMessageCategories);
          final int selectedCategoryIndex = context.select(
              (CannedMessagesCubit cubit) => cubit.state.selectedCategoryIndex);

          if (cannedMessageCategories != null) {
            return Container(
              decoration: BoxDecoration(color: theme.canvasColor),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.horizontalScreenPadding),
                    child: UpsellingHeaderWidget(
                      title: SZodiac.of(context).sendCannedMessageZodiac,
                      onCrossTap: chatCubit.closeUpsellingMenu,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Builder(builder: (context) {
                    final int? editingCannedMessageIndex = context.select(
                        (CannedMessagesCubit cubit) =>
                            cubit.state.editingCannedMessageIndex);
                    if (editingCannedMessageIndex == null) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: AppConstants.horizontalScreenPadding,
                              ),
                              ...cannedMessageCategories
                                  .mapIndexed((index, element) {
                                final Widget child = CategoryMenuItemWidget(
                                  title: element.categoryName ?? '',
                                  isSelected: selectedCategoryIndex == index,
                                  onTap: () => cannedMessagesCubit
                                      .setSelectedCategoryIndex(index),
                                );
                                if (index !=
                                    cannedMessageCategories.length - 1) {
                                  return Row(
                                    children: [
                                      child,
                                      const SizedBox(
                                        width: 8.0,
                                      )
                                    ],
                                  );
                                } else {
                                  return child;
                                }
                              }).toList(),
                              const SizedBox(
                                width: AppConstants.horizontalScreenPadding,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                  Builder(builder: (context) {
                    final List<CannedMessageModel>? messages =
                        cannedMessageCategories[selectedCategoryIndex].messages;

                    if (messages != null) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (child, animation) => SizeTransition(
                          sizeFactor: animation,
                          child: child,
                        ),
                        child: CannedMessagesPageView(
                          key: ValueKey(messages.hashCode),
                          messages: messages,
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.horizontalScreenPadding),
                    child: AppElevatedButton(
                      title: SZodiac.of(context).sendZodiac,
                      onPressed: () {
                        chatCubit.sendUpsellingMessage(
                          cannedMessageId:
                              cannedMessageCategories[selectedCategoryIndex]
                                  .messages?[
                                      cannedMessagesCubit.selectedMessageIndex]
                                  .id,
                          customCannedMessage: cannedMessagesCubit
                                  .editedCannedMessage ??
                              cannedMessageCategories[selectedCategoryIndex]
                                  .messages?[
                                      cannedMessagesCubit.selectedMessageIndex]
                                  .message,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class CannedMessagesPageView extends StatefulWidget {
  final List<CannedMessageModel> messages;
  const CannedMessagesPageView({
    Key? key,
    required this.messages,
  }) : super(key: key);

  @override
  State<CannedMessagesPageView> createState() => _CannedMessagesPageViewState();
}

class _CannedMessagesPageViewState extends State<CannedMessagesPageView> {
  static const double viewportFraction = 0.9;
  static const double paddingBetweenCannedMessages = 4.0;

  final PageController _pageController =
      PageController(viewportFraction: viewportFraction);

  late final CannedMessagesCubit cannedMessagesCubit;

  double widgetHeight = 0;
  late _CannedMessageHeightModel _widgetWithMaxHeight;

  @override
  void initState() {
    super.initState();

    cannedMessagesCubit = context.read<CannedMessagesCubit>();

    cannedMessagesCubit.onPageChanged(0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      double maxHeight = 0;

      widget.messages.forEachIndexed((index, element) {
        double height =
            _getCannedMessageHeight(element.message ?? '', displayMaxLines);
        if (height > maxHeight) {
          maxHeight = height;
          _widgetWithMaxHeight =
              _CannedMessageHeightModel(index: index, height: height);
        }
      });

      setState(() {
        widgetHeight = maxHeight;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widgetHeight,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.messages.length,
        onPageChanged: (index) {
          cannedMessagesCubit.onPageChanged(index);
          _setWidgetWithMaxHeight();
          if (widgetHeight > _widgetWithMaxHeight.height) {
            setState(() {
              widgetHeight = _widgetWithMaxHeight.height;
            });
          }
        },
        itemBuilder: (context, index) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: paddingBetweenCannedMessages),
              child: CannedMessageWidget(
                index: index,
                message: widget.messages[index].message ?? '',
                onEditing: (message) {
                  double height =
                      _getCannedMessageHeight(message, editingMaxLines);

                  if (widgetHeight < height) {
                    setState(() {
                      widgetHeight = height;
                    });
                  } else {
                    _setWidgetWithMaxHeight(
                        message: message, editingIndex: index);
                    if (_widgetWithMaxHeight.index == index) {
                      setState(() {
                        widgetHeight = _widgetWithMaxHeight.height;
                      });
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getCannedMessageHeight(String message, int maxLines) {
    return Utils.getTextHeight(
            message,
            Theme.of(context).textTheme.bodyMedium,
            MediaQuery.of(context).size.width * viewportFraction -
                paddingBetweenCannedMessages * 2 -
                cannedMessageContentPadding * 2,
            maxLines: maxLines) +
        AppConstants.iconSize +
        paddingBetweenMessageAndEdit +
        cannedMessageContentPadding * 2 +
        12;
  }

  void _setWidgetWithMaxHeight({String? message, int? editingIndex}) {
    double maxHeight = 0;

    widget.messages.forEachIndexed((index, element) {
      double height = _getCannedMessageHeight(
          index == editingIndex ? message ?? '' : element.message ?? '',
          editingMaxLines);
      if (height > maxHeight) {
        maxHeight = height;
        _widgetWithMaxHeight =
            _CannedMessageHeightModel(index: index, height: height);
      }
    });
  }
}

class _CannedMessageHeightModel {
  final int index;
  final double height;

  const _CannedMessageHeightModel({
    required this.index,
    required this.height,
  });
}
