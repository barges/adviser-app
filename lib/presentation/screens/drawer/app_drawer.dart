import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/drawer_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/widgets/bottom_section.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/widgets/brand_item.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return BlocProvider(
      create: (_) => DrawerCubit(getIt.get<CachingManager>()),
      child: Builder(builder: (context) {
        final DrawerCubit cubit = context.read<DrawerCubit>();
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
                                      S.of(context).workspaces,
                                      style: theme.textTheme.headlineLarge,
                                    ),
                                    const SizedBox(
                                      height: 12.0,
                                    ),
                                    Column(
                                      children: cubit.authorizedBrands
                                          .map(
                                            (e) => Column(
                                              children: [
                                                BrandItem(
                                                  brand: e,
                                                  isLoggedIn: true,
                                                ),
                                                const SizedBox(
                                                  height: 8.0,
                                                ),
                                              ],
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 1.0,
                              ),
                              if (cubit.unauthorizedBrands.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      12.0, 12.0, 12.0, 4.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        S.of(context).otherBrands.toUpperCase(),
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          fontSize: 11.0,
                                          color: theme.iconTheme.color,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12.0,
                                      ),
                                      Column(
                                        children: cubit.unauthorizedBrands
                                            .map(
                                              (e) => Column(
                                                children: [
                                                  BrandItem(
                                                    brand: e,
                                                  ),
                                                  const SizedBox(
                                                    height: 8.0,
                                                  ),
                                                ],
                                              ),
                                            )
                                            .toList(),
                                      )
                                    ],
                                  ),
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
