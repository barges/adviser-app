import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/cache/caching_manager.dart';
import '../../../domain/repositories/fortunica_auth_repository.dart';
import '../../../generated/l10n.dart';
import '../../../global.dart';
import 'widgets/drawer_item.dart';
import 'drawer_cubit.dart';
import 'widgets/bottom_section.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return BlocProvider(
      create: (_) => DrawerCubit(
        globalGetIt.get<FortunicaAuthRepository>(),
        globalGetIt.get<CachingManager>(),
      ),
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
                                    const DrawerItem(),
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
