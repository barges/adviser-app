import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:zodiac/data/models/canned_messages/canned_category.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:zodiac/presentation/screens/canned_messages/canned_messages_cubit.dart';
import 'package:zodiac/presentation/screens/canned_messages/canned_messages_screen.dart';
import 'package:zodiac/presentation/screens/canned_messages/widgets/categories_widget.dart';
import 'package:zodiac/zodiac_constants.dart';

class EditCannedMessageWidget extends StatefulWidget {
  final String text;
  final CannedCategory? category;
  final List<CannedCategory> categories;
  final ValueChanged<String> onTextEdit;
  final ValueChanged<int> onSelectCategory;
  final VoidCallback? onSave;
  const EditCannedMessageWidget({
    super.key,
    required this.text,
    required this.category,
    required this.categories,
    required this.onTextEdit,
    required this.onSelectCategory,
    required this.onSave,
  });

  @override
  State<EditCannedMessageWidget> createState() =>
      _EditCannedMessageWidgetState();
}

class _EditCannedMessageWidgetState extends State<EditCannedMessageWidget> {
  late final TextEditingController _textEditingController;
  late int _initialSelectedIndex;
  late final ValueNotifier<int> countSymbolsNotifier =
      ValueNotifier(_textEditingController.text.length);

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController(text: widget.text);
    _textEditingController.addListener(() {
      widget.onTextEdit(_textEditingController.text);
      countSymbolsNotifier.value = _textEditingController.text.length;
    });

    widget.onTextEdit(_textEditingController.text);

    _initialSelectedIndex = widget.category != null
        ? widget.categories.indexOf(widget.category!)
        : 0;
    widget.onSelectCategory(_initialSelectedIndex);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalScreenPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                bottom: AppConstants.horizontalScreenPadding,
              ),
              child: Container(
                  width: 96.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21.0),
                    color: theme.dividerColor,
                  )),
            ),
            Text(
              SZodiac.of(context).editTemplateZodiac,
              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 17.0),
            ),
            const SizedBox(height: AppConstants.horizontalScreenPadding),
            Flexible(
              child: RawScrollbar(
                thumbColor: theme.hintColor,
                thickness: 4.0,
                radius: const Radius.circular(2.0),
                crossAxisMargin: -10.0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _textEditingController,
                        label: SZodiac.of(context).addMessageZodiac,
                        isBig: true,
                        showCounter: true,
                        maxLength: ZodiacConstants.cannedMessageMaxLength,
                        minLength: 1,
                      ),
                      const SizedBox(
                        height: verticalInterval,
                      ),
                      if (widget.categories.isNotEmpty)
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: verticalInterval),
                          child: CategoriesWidget(
                            title: SZodiac.of(context)
                                .chooseCategoryTemplateZodiac,
                            onTap: (index) => widget.onSelectCategory(index),
                            categories: widget.categories,
                            initialSelectedIndex: _initialSelectedIndex,
                          ),
                        ),
                      ValueListenableBuilder(
                          valueListenable: countSymbolsNotifier,
                          builder: (_, int value, __) {
                            return AppElevatedButton(
                              title: SZodiac.of(context).saveZodiac,
                              onPressed:
                                  value > 0 && value <= maximumMessageSymbols
                                      ? widget.onSave
                                      : null,
                            );
                          }),
                      const SizedBox(
                        height: 18.0,
                      ),
                      GestureDetector(
                        onTap: () => context.popRoute(),
                        child: Text(
                          SZodiac.of(context).cancelZodiac,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                            color: theme.shadowColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
