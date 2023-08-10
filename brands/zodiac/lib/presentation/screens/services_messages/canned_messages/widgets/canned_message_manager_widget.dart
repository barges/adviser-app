import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/data/models/canned_messages/canned_category.dart';
import 'package:zodiac/data/models/canned_messages/canned_message.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/services_messages/canned_messages/canned_messages_cubit.dart';
import 'package:zodiac/presentation/screens/services_messages/list_of_filters_widget.dart';
import 'package:zodiac/presentation/screens/services_messages/canned_messages/canned_messages_screen.dart';
import 'package:zodiac/presentation/screens/services_messages/canned_messages/widgets/canned_message_card.dart';

class CannedMessageManagerWidget extends StatelessWidget {
  final ValueNotifier<int> indexNotifier = ValueNotifier(0);
  CannedMessageManagerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    CannedMessagesCubit cannedMessagesCubit =
        context.read<CannedMessagesCubit>();
    if (cannedMessagesCubit.state.categories != null &&
        cannedMessagesCubit.selectedCategory != null) {
      indexNotifier.value = cannedMessagesCubit.state.categories!
              .indexOf(cannedMessagesCubit.selectedCategory!) +
          1;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(builder: (context) {
          final List<CannedCategory> categories = context
              .select((CannedMessagesCubit cubit) => cubit.state.categories!);
          final List<String> filters =
              categories.map((item) => item.name ?? '').toList();
          return categories.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: AppConstants.horizontalScreenPadding,
                        bottom: AppConstants.horizontalScreenPadding,
                      ),
                      child: Text(
                        SZodiac.of(context).manageMessagesZodiac,
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(fontSize: 17.0),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: indexNotifier,
                      builder: (_, int value, __) {
                        return ListOfFiltersWidget(
                          currentFilterIndex: value,
                          onTapToFilter: (index) {
                            if (index != null) {
                              indexNotifier.value = index;
                              cannedMessagesCubit
                                  .setCategory(index == 0 ? null : index - 1);
                              cannedMessagesCubit
                                  .filterCannedMessagesByCategory();
                            }
                          },
                          filters: [SZodiac.of(context).allZodiac, ...filters],
                          padding: AppConstants.horizontalScreenPadding,
                        );
                      },
                    ),
                  ],
                )
              : const SizedBox.shrink();
        }),
        Builder(builder: (context) {
          final List<CannedMessage> messages = context.select(
                  (CannedMessagesCubit cubit) => cubit.state.messages) ??
              [];
          return Padding(
              padding: EdgeInsets.only(
                top: messages.isNotEmpty ? verticalInterval : 0.0,
                left: AppConstants.horizontalScreenPadding,
                right: AppConstants.horizontalScreenPadding,
              ),
              child: Column(
                  children: messages.mapIndexed<Widget>(
                (index, element) {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: index != messages.length - 1
                            ? verticalInterval
                            : 0),
                    child: CannedMessageCard(
                      cannedMessage: element,
                    ),
                  );
                },
              ).toList()));
        }),
      ],
    );
  }
}
