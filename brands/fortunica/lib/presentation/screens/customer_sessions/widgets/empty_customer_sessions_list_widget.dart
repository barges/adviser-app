import 'package:shared_advisor_interface/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/presentation/common_widgets/empty_list_widget.dart';
import 'package:fortunica/presentation/screens/customer_sessions/customer_sessions_cubit.dart';

class EmptyCustomerSessionsListWidget extends StatelessWidget {
  const EmptyCustomerSessionsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<CustomerSessionsCubit>()
            .getPrivateQuestions(refresh: true);
      },
      child: CustomScrollView(slivers: [
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
                    title: SFortunica.of(context).weDidntFindAnythingFortunica,
                    label: SFortunica.of(context)
                        .noSessionsFoundWithThisFilterFortunica,
                  ),
                ],
              ),
            ))
      ]),
    );
  }
}
