import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortunica/fortunica.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:fortunica/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar_cubit.dart';
import 'package:fortunica/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/screens/home_screen/cubit/main_home_screen_cubit.dart';

const double _maxHeight = AppConstants.appBarHeight * 2;
const double _minHeight = AppConstants.appBarHeight;
const double _errorHeight = 36.0;

class ScrollableAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? actionOnClick;
  final bool needShowError;

  const ScrollableAppBar({
    Key? key,
    required this.title,
    this.actionOnClick,
    this.needShowError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final BaseBrand currentBrand = FortunicaBrand();

    return BlocProvider(
      create: (_) => ScrollableAppBarCubit(fortunicaGetIt.get<FortunicaMainCubit>()),
      child: Builder(builder: (context) {
        final ScrollableAppBarCubit scrollableAppBarCubit =
            context.read<ScrollableAppBarCubit>();
        final bool isOnline = context.select(
            (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);

        final bool isWide = context
            .select((ScrollableAppBarCubit cubit) => cubit.state.isWideAppBar);

        return SliverAppBar(
          automaticallyImplyLeading: false,
          forceElevated: true,
          backgroundColor: Theme.of(context).canvasColor,
          expandedHeight: _maxHeight,
          centerTitle: true,
          pinned: true,
          snap: true,
          floating: true,
          scrolledUnderElevation: 0.2,
          flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            scrollableAppBarCubit.setIsWideAppbar(constraints.maxHeight -
                        MediaQuery.of(context).padding.top >
                    _maxHeight - 1.0 &&
                constraints.maxHeight - MediaQuery.of(context).padding.top <=
                    _maxHeight);

            return isWide
                ? Padding(
                    padding: EdgeInsets.fromLTRB(
                      16.0,
                      MediaQuery.of(context).padding.top + 16.0,
                      16.0,
                      0.0,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width),
                      child: Row(
                        children: [
                          AppIconButton(
                            icon: Assets.vectors.arrowLeft.path,
                            onTap: context.popRoute,
                          ),
                          Expanded(
                              child: GestureDetector(
                                onTap: context.read<MainHomeScreenCubit>().openDrawer,
                                child: Row(
                                  children: [
                                    Container(
                                      height: AppConstants.iconSize,
                                      width: AppConstants.iconSize,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3.0),
                                      margin: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 4.0,
                                      ),
                                      child: SvgPicture.asset(
                                        currentBrand.iconPath,
                                      ),
                                    ),
                                    Text(currentBrand.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                    const SizedBox(width: 4.0),
                                    Assets.vectors.swap.svg(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (actionOnClick != null)
                            Opacity(
                              opacity: isOnline ? 1.0 : 0.4,
                              child: AppIconButton(
                                icon: Assets.vectors.check.path,
                                onTap: isOnline ? actionOnClick : null,
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }),
          //title:
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(_minHeight),
            child: Builder(
              builder: (context) {
                final AppError appError =
                    context.select((FortunicaMainCubit cubit) => cubit.state.appError);
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      height: _minHeight,
                      child: !isWide
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppIconButton(
                                    icon: Assets.vectors.arrowLeft.path,
                                    onTap: context.popRoute,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: AppConstants.iconSize,
                                            width: AppConstants.iconSize,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3.0),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: SvgPicture.asset(
                                              currentBrand.iconPath,
                                            ),
                                          ),
                                          Text(
                                            title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 17.0,
                                                ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        currentBrand.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontSize: 12.0,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                            ),
                                      ),
                                    ],
                                  ),
                                  actionOnClick != null
                                      ? Opacity(
                                          opacity: isOnline ? 1.0 : 0.4,
                                          child: AppIconButton(
                                            icon: Assets.vectors.check.path,
                                            onTap: actionOnClick,
                                          ))
                                      : const SizedBox(
                                          width: AppConstants.iconButtonSize,
                                        ),
                                ],
                              ),
                            )
                          : Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 16.0,
                                  ),
                                  child: Text(
                                    title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    if (needShowError)
                      Positioned(
                        top: _minHeight,
                        child: AppErrorWidget(
                          height: _errorHeight,
                          errorMessage: isOnline
                              ? ''
                              : SFortunica.of(context).noInternetConnectionFortunica,
                          isRequired: true,
                        ),
                      ),
                    if (isOnline)
                      Positioned(
                        top: _minHeight,
                        child: AppErrorWidget(
                          height: _errorHeight,
                          errorMessage: appError.getMessage(context),
                          close: scrollableAppBarCubit.closeErrorWidget,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
