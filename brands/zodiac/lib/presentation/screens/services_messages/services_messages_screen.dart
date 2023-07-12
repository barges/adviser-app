import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:zodiac/presentation/screens/services_messages/list_of_filters_widget.dart';
import 'package:zodiac/presentation/screens/services_messages/canned_messages/canned_messages_screen.dart';

class ServicesMessagesScreen extends StatelessWidget {
  const ServicesMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    int currentIndex = 1;
    return Scaffold(
        appBar: SimpleAppBar(
          title: SZodiac.of(context).servicesMessagesZodiac,
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: AppConstants.horizontalScreenPadding,
                      left: AppConstants.horizontalScreenPadding,
                      right: AppConstants.horizontalScreenPadding),
                  child: ListOfFiltersWidget(
                    currentFilterIndex: currentIndex,
                    onTapToFilter: (index) =>
                        setState(() => currentIndex = index!),
                    filters: [
                      SZodiac.of(context).servicesZodiac,
                      SZodiac.of(context).cannedMessagesZodiac
                    ],
                    itemWidth: (MediaQuery.of(context).size.width -
                            AppConstants.horizontalScreenPadding * 2 -
                            8.0) *
                        0.5,
                  ),
                ),
                const SizedBox(height: verticalInterval),
                Flexible(
                  child: IndexedStack(
                    index: currentIndex,
                    children: const [
                      SizedBox.shrink(),
                      CannedMessagesScreen(),
                    ],
                  ),
                )
              ],
            );
          }),
        ));
  }
}
