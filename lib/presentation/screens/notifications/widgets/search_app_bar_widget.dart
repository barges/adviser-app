import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors_light.dart';

class SearchAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const SearchAppBarWidget({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(AppConstants.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      titleTextStyle: Theme.of(context).textTheme.headline1,
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent),
      elevation: 0.0,
      title: Text(title),
      backgroundColor: AppColorsLight.uinegative,
    );
  }
}
