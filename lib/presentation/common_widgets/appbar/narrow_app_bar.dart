import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class NarrowAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subTitle;
  final String? backIcon;
  final String? zodiac;
  final String? backButtonText;

  const NarrowAppBar({
    Key? key,
    required this.title,
    this.subTitle,
    this.backButtonText,
    this.backIcon,
    this.zodiac,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Brand currentBrand = getIt.get<MainCubit>().state.currentBrand;
    return title == ''
        ? const SizedBox.shrink()
        : AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            titleSpacing: AppConstants.horizontalScreenPadding,
            elevation: 0.0,
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppIconButton(
                      icon: backIcon ?? Assets.vectors.arrowLeft.path,
                      onTap: Get.back,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              currentBrand.icon,
                              height: 17.0,
                            ),
                            const SizedBox(width: 12.0),
                            Text(title,
                                style: theme.textTheme.headlineMedium
                                    ?.copyWith(fontSize: 17.0)),
                          ],
                        ),
                        Text(
                          subTitle ?? currentBrand.name,
                          style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12.0, color: theme.shadowColor),
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      zodiac ?? '',
                      width: 28.0,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                const Divider(
                  height: 1.0,
                )
              ],
            ),
            backgroundColor: theme.canvasColor,
          );
  }
}
