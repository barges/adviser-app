import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_colors.dart';
import 'package:shared_advisor_interface/presentation/resources/app_text_styles.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const SimpleAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      titleTextStyle: AppTextStyles.appBarTitleStyle,
      leading: Navigator.canPop(context)
          ? InkResponse(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back_ios,
                        color: AppColors.secondary, size: 16.0),
                    Text(
                      S.of(context).back,
                      style: AppTextStyles.labelMedium,
                    )
                  ],
                ),
              ))
          : const SizedBox(),
      leadingWidth: 70,
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent),
      elevation: 0.0,
      title: Text(title),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}
