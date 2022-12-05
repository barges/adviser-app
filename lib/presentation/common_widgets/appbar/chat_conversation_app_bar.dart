import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/models/enums/zodiac_sign.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class ChatConversationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final ZodiacSign? zodiacSign;
  final String? backIcon;
  final String? backButtonText;
  final VoidCallback? backButtonOnTap;

  const ChatConversationAppBar({
    Key? key,
    required this.title,
    this.zodiacSign,
    this.backButtonText,
    this.backIcon,
    this.backButtonOnTap,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: AppConstants.horizontalScreenPadding,
      elevation: 0.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppIconButton(
            icon: backIcon ?? Assets.vectors.arrowLeft.path,
            onTap: backButtonOnTap ?? Get.back,
          ),
          Builder(builder: (context) {
            final Brand selectedBrand =
                context.select((MainCubit cubit) => cubit.state.currentBrand);
            return Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      selectedBrand.icon,
                      height: 17.0,
                    ),
                    const SizedBox(width: 12.0),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).hoverColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Text(
                  selectedBrand.name,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w200,
                    color: Theme.of(context).shadowColor,
                  ),
                ),
              ],
            );
          }),
          if (zodiacSign != null)
            SvgPicture.asset(
              zodiacSign!.imagePath(context),
              width: 28.0,
            ),
        ],
      ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}