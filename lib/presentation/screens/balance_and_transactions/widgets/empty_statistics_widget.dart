import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/empty_list_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/widgets/see_more_widget.dart';

class EmptyStatisticsWidget extends StatelessWidget {
  const EmptyStatisticsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.horizontalScreenPadding,
                  ),
                  child: EmptyListWidget(
                    title: S.of(context).youHaveNotCompletedAnySessionsYet,
                  ),
                ),
              ],
            ),
          ),
          const SeeMoreWidget(),
        ],
      ),
    );
  }
}
