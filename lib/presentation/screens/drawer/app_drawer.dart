import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../infrastructure/routing/app_router.dart';
import '../../../generated/l10n.dart';
import '../../common_widgets/brand_drawer_item/fortunica_drawer_item.dart';
import '../../common_widgets/ok_cancel_bottom_sheet.dart';
import 'drawer_cubit.dart';
import 'widgets/bottom_section.dart';

class AppDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AppDrawer({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return BlocProvider(
      create: (_) => DrawerCubit(),
      child: Builder(builder: (context) {
        return Container(
            width: MediaQuery.of(context).size.width * 0.75,
            color: theme.canvasColor,
            child: SafeArea(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    fillOverscroll: false,
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    12.0, 12.0, 12.0, 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      SFortunica.of(context).workspaces,
                                      style: theme.textTheme.headlineLarge,
                                    ),
                                    const SizedBox(
                                      height: 12.0,
                                    ),
                                    BrandItem(
                                      scaffoldKey: scaffoldKey,
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 1.0,
                              ),
                            ],
                          ),
                        ),
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: BottomSection(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      }),
    );
  }
}

class BrandItem extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const BrandItem({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FortunicaDrawerItem(
      openLogoutDialog: (fortunicaContext, callback) => showOkCancelBottomSheet(
        context: context,
        okButtonText: SFortunica.of(context).logOut,
        okOnTap: () {
          callback(fortunicaContext).then((value) {
            context.pop();
            scaffoldKey.currentState?.closeDrawer();
          });
        },
      ),
    );
  }
}
