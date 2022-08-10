import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      titleTextStyle: const TextStyle(
          color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w400),
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
                    Icon(Icons.arrow_back_ios,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 16.0),
                    Text(
                      'Back',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
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
      backgroundColor: Colors.white,
    );
  }
}
