import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:fortunica/presentation/screens/home/home_cubit.dart';
import 'package:fortunica/presentation/screens/home/tabs_types.dart';

class NotLiveStatusWidget extends StatelessWidget {
  final FortunicaUserStatus status;

  const NotLiveStatusWidget({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeCubit homeCubit = context.read<HomeCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalScreenPadding,
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Utils.isDarkMode(context)
                            ? Assets.images.logos.notLiveLogoDark.image(
                                height: AppConstants.logoSize,
                                width: AppConstants.logoSize,
                              )
                            : Assets.images.logos.notLiveLogo.image(
                                height: AppConstants.logoSize,
                                width: AppConstants.logoSize,
                              ),
                        const SizedBox(
                          height: 24.0,
                        ),
                        Text(
                          status.errorTitleText(context),
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          status.errorBodyText(context),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 16.0,
                                    color: Theme.of(context).shadowColor,
                                  ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
                AppElevatedButton(
                  title: status.buttonText(context),
                  onPressed: () async {
                    if (status != FortunicaUserStatus.live) {
                      if (HomeCubit.tabsList.contains(TabsTypes.account)) {
                        homeCubit.changeTabIndex(
                          HomeCubit.tabsList.indexOf(TabsTypes.account),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
