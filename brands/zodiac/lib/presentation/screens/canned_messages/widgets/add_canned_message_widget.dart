import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:zodiac/data/models/canned_messages/canned_category.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/box_decoration_widget.dart';
import 'package:zodiac/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:zodiac/presentation/screens/canned_messages/canned_messages_cubit.dart';
import 'package:zodiac/presentation/screens/canned_messages/canned_messages_screen.dart';
import 'package:zodiac/presentation/screens/canned_messages/widgets/categories_widget.dart';
import 'package:zodiac/presentation/screens/canned_messages/widgets/info_widget.dart';
import 'package:zodiac/zodiac_constants.dart';

class AddCannedMessageWidget extends StatefulWidget {
  const AddCannedMessageWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<AddCannedMessageWidget> createState() => _AddCannedMessageWidgetState();
}

class _AddCannedMessageWidgetState extends State<AddCannedMessageWidget> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController(text: '');
    _textEditingController.addListener(() {
      CannedMessagesCubit cannedMessagesCubit =
          context.read<CannedMessagesCubit>();
      cannedMessagesCubit
          .setTextCannedMessageToAdd(_textEditingController.text);
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CannedMessagesCubit cannedMessagesCubit =
        context.read<CannedMessagesCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalScreenPadding,
      ),
      child: Column(
        children: [
          const InfoWidget(),
          const SizedBox(
            height: verticalInterval,
          ),
          AppTextField(
            controller: _textEditingController,
            label: SZodiac.of(context).addMessageZodiac,
            footerHint: SZodiac.of(context).thisWhatYourClientSeeZodiac,
            isBig: true,
            showCounter: true,
            maxLength: ZodiacConstants.cannedMessageMaxLength,
            minLength: 1,
          ),
          const SizedBox(
            height: verticalInterval,
          ),
          Builder(builder: (context) {
            final List<CannedCategory> categories = context
                .select((CannedMessagesCubit cubit) => cubit.state.categories!);
            return categories.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(bottom: verticalInterval),
                    child: BoxDecorationWidget(
                      child: CategoriesWidget(
                        title: SZodiac.of(context).chooseCategoryTemplateZodiac,
                        onTap: (index) =>
                            cannedMessagesCubit.setCategoryToAdd(index),
                        categories: categories,
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }),
          Builder(builder: (context) {
            final isButtonEnabled = context.select(
                (CannedMessagesCubit cubit) =>
                    cubit.state.isSaveTemplateButtonEnabled);
            return AppElevatedButton(
              title: SZodiac.of(context).saveTemplateZodiac,
              onPressed: isButtonEnabled
                  ? () async {
                      if (await cannedMessagesCubit.saveTemplate()) {
                        _textEditingController.text = '';
                      }
                    }
                  : null,
            );
          }),
          const SizedBox(
            height: verticalInterval,
          ),
        ],
      ),
    );
  }
}