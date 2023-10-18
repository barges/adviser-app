import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app_constants.dart';
import '../../generated/assets/assets.gen.dart';

class AuthorizedBrandsAppBarWidget extends StatelessWidget {
  ///Need not const for updates
  const AuthorizedBrandsAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO DELETE
    /*context.select((MainCubit cubit) =>
        cubit.state.currentBrand ?? BrandManager.defaultBrand);
    final List<BaseBrand> brands =
        globalGetIt.get<BrandManager>().authorizedBrands();*/

    return const _AuthorizedBrandWidget(
      index: 0,
      //brand: element,
      isFirstBrand: true,
    );
  }
}

class _AuthorizedBrandWidget extends StatelessWidget {
  final int index;
  final bool isFirstBrand;

  const _AuthorizedBrandWidget({
    Key? key,
    required this.index,
    required this.isFirstBrand,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Container(
        margin: EdgeInsets.only(right: 24.0 * index),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              height: AppConstants.iconButtonSize,
              width: AppConstants.iconButtonSize,
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius:
                      BorderRadius.circular(AppConstants.buttonRadius)),
              child: SvgPicture.asset(Assets.vectors.fortunica.path),
            ),
            Container(
              height: 12.0,
              width: 12.0,
              decoration: BoxDecoration(
                // TODO ?
                //color: brand.userStatusBadgeColor(context),
                shape: BoxShape.circle,
                border: Border.all(
                    width: 2.0, color: Theme.of(context).canvasColor),
              ),
            ),
          ],
        ),
      );
    });
  }
}
