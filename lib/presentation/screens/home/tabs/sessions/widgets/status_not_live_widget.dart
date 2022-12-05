import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs_types.dart';
import 'package:shared_advisor_interface/presentation/utils/utils.dart';

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
                      children: [
                        Utils.isDarkMode(context)
                            ? Assets.images.logos.noConnectionLogoDark.image(
                                height: AppConstants.logoSize,
                                width: AppConstants.logoSize,
                              )
                            : Assets.images.logos.noConnectionLogo.image(
                                height: AppConstants.logoSize,
                                width: AppConstants.logoSize,
                              ),
                        const SizedBox(
                          height: 24.0,
                        ),
                        Text(
                          status.errorText,
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                AppElevatedButton(
                  title: status.buttonText,
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
