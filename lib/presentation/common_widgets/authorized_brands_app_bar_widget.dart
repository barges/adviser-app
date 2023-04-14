import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/main_cubit.dart';

class AuthorizedBrandsAppBarWidget extends StatelessWidget {
  ///Need not const for updates
  AuthorizedBrandsAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.select((MainCubit cubit) =>
        cubit.state.currentBrand ?? BrandManager.defaultBrand);
    final List<BaseBrand> brands =
        globalGetIt.get<BrandManager>().authorizedBrands();

    return Stack(
        textDirection: TextDirection.rtl,
        children: brands
            .mapIndexed((index, element) => _AuthorizedBrandWidget(
                  index: index,
                  brand: element,
                  isFirstBrand: index == brands.length - 1,
                ))
            .toList());
  }
}

class _AuthorizedBrandWidget extends StatelessWidget {
  final int index;
  final bool isFirstBrand;
  final BaseBrand brand;

  const _AuthorizedBrandWidget(
      {Key? key,
      required this.index,
      required this.isFirstBrand,
      required this.brand})
      : super(key: key);

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
              child: SvgPicture.asset(brand.iconPath),
            ),
            Container(
              height: 12.0,
              width: 12.0,
              decoration: BoxDecoration(
                color: brand.userStatusBadgeColor(context),
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
