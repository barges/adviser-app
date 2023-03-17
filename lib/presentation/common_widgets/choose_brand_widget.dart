import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/brand_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChooseBrandWidget extends StatelessWidget {
  const ChooseBrandWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.select((MainCubit cubit) => cubit.state.currentBrand);
    final List<Brand> brands = Configuration.unauthorizedBrands();
    for (var element in brands) {logger.d(element);}

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
              Brand brand = brands[index];
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