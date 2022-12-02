import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/login/widgets/brand_widget.dart';

class ChooseBrandWidget extends StatelessWidget {
  const ChooseBrandWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Brand> brands = context.read<LoginCubit>().unauthorizedBrands;
    final Brand selectedBrand =
        context.select((LoginCubit cubit) => cubit.state.selectedBrand);
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
                isSelected: brand == selectedBrand,
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
