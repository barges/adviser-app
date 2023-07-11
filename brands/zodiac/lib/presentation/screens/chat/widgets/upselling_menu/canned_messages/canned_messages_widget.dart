import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/models/canned_message/canned_message_category.dart';
import 'package:zodiac/data/models/canned_message/canned_message_model.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/upselling_menu/canned_messages/canned_message_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/upselling_menu/category_menu_item_widget.dart';

class CannedMessagesWidget extends StatefulWidget {
  const CannedMessagesWidget({Key? key}) : super(key: key);

  @override
  State<CannedMessagesWidget> createState() => _CannedMessagesWidgetState();
}

class _CannedMessagesWidgetState extends State<CannedMessagesWidget> {
  int selectedCategotyIndex = 0;
  int? selectedMessageIndex;
  String? editedCannedMessage;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ChatCubit chatCubit = context.read<ChatCubit>();

    final List<CannedMessageCategory>? cannedMessageCategories = context
        .select((ChatCubit cubit) => cubit.state.cannedMessageCategories);

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
              child: Row(
                children: [
                  const SizedBox(
                    width: 32.0,
                  ),
                  Expanded(
                    child: Text(
                      SZodiac.of(context).sendCannedMessageZodiac,
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(fontSize: 17.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  GestureDetector(
                    onTap: chatCubit.closeUpsellingMenu,
                    child: Assets.zodiac.vectors.crossSmall.svg(
                      height: AppConstants.iconSize,
                      width: AppConstants.iconSize,
                      colorFilter: ColorFilter.mode(
                        theme.shadowColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(
                    width: AppConstants.horizontalScreenPadding,
                  ),
                  ...cannedMessageCategories.mapIndexed((index, element) {
                    final Widget child = CategotyMenuItemWidget(
                      title: element.categoryName ?? '',
                      isSelected: selectedCategotyIndex == index,
                      onTap: () {
                        if (selectedCategotyIndex != index) {
                          setState(() {
                            selectedCategotyIndex = index;
                          });
                        }
                      },
                    );
                    if (index != cannedMessageCategories.length - 1) {
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
            const SizedBox(
              height: 12.0,
            ),
            Builder(builder: (context) {
              final List<CannedMessageModel>? messages =
                  cannedMessageCategories[selectedCategotyIndex].messages;

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
                    onPageChanged: (value) {
                      selectedMessageIndex = value;
                      editedCannedMessage = null;
                    },
                    onEditing: (value) => editedCannedMessage = value,
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
                  if (selectedMessageIndex != null) {
                    chatCubit.sendUpsellingMessage(
                      cannedMessageId:
                          cannedMessageCategories[selectedCategotyIndex]
                              .messages?[selectedMessageIndex!]
                              .id,
                      customCannedMessage: editedCannedMessage ??
                          cannedMessageCategories[selectedCategotyIndex]
                              .messages?[selectedMessageIndex!]
                              .message,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class CannedMessagesPageView extends StatefulWidget {
  final List<CannedMessageModel> messages;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<String?> onEditing;
  const CannedMessagesPageView({
    Key? key,
    required this.messages,
    required this.onPageChanged,
    required this.onEditing,
  }) : super(key: key);

  @override
  State<CannedMessagesPageView> createState() => _CannedMessagesPageViewState();
}

class _CannedMessagesPageViewState extends State<CannedMessagesPageView> {
  static const double viewportFraction = 0.9;
  static const double paddingBetweenCannedMessages = 4.0;

  final PageController _pageController =
      PageController(viewportFraction: viewportFraction);

  final PublishSubject _stopEditingStream = PublishSubject();

  double widgetHeight = 0;
  late _CannedMessageHeightModel _widgetWithMaxHeight;

  @override
  void initState() {
    super.initState();

    widget.onPageChanged(0);

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
          widget.onPageChanged(index);
          _stopEditingStream.add(true);
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
                message: widget.messages[index].message ?? '',
                stopEditingStream: _stopEditingStream.stream,
                onEditing: (message) {
                  widget.onEditing(message);
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
