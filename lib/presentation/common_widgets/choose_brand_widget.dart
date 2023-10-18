// TODO DELETE

/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_constants.dart';
import '../../infrastructure/brands/base_brand.dart';
import '../../infrastructure/di/brand_manager.dart';
import '../../main_cubit.dart';
import 'brand_widget.dart';

class ChooseBrandWidget extends StatelessWidget {
  const ChooseBrandWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.select((MainCubit cubit) => cubit.state.currentBrand);
    final List<BaseBrand> brands = BrandManager.unauthorizedBrands();

    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: 78.0,
        child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalScreenPadding,
            ),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              BaseBrand brand = brands[index];
              return BrandWidget(
                brand: brands[index],
                isSelected:
                    brand == context.read<MainCubit>().state.currentBrand,
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                width: 8.0,
              );
            },
            itemCount: brands.length),
      ),
    );
  }
}
*/