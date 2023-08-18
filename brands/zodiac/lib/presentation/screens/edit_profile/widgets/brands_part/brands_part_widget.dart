import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/models/user_info/brand_model.dart';
import 'package:zodiac/presentation/screens/edit_profile/edit_profile_cubit.dart';
import 'package:zodiac/presentation/screens/edit_profile/widgets/brands_part/brands_list_widget.dart';

class BrandsPartWidget extends StatelessWidget {
  const BrandsPartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<BrandModel>? brands =
        context.select((EditProfileCubit cubit) => cubit.state.brands);
    final int selectedBrandIndex = context
        .select((EditProfileCubit cubit) => cubit.state.selectedBrandIndex);

    if (brands != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BrandsListWidget(
            brands: brands,
            selectedBrandIndex: selectedBrandIndex,
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
