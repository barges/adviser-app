import 'package:shared_advisor_interface/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/presentation/common_widgets/empty_list_widget.dart';

class EmptyHistoryListWidget extends StatelessWidget {
  const EmptyHistoryListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalScreenPadding,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EmptyListWidget(
                    title: SFortunica.of(context).noSessionsYetFortunica,
                    label: SFortunica.of(context)
                        .whenYouHelpYourFirstClientYouWillSeeYourSessionHistoryHereFortunica,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
