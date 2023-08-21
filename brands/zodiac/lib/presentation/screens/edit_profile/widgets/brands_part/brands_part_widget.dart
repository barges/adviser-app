import 'package:flutter/widgets.dart';
import 'package:zodiac/data/models/user_info/brand_model.dart';
import 'package:zodiac/presentation/screens/edit_profile/widgets/brands_part/brands_list_widget.dart';

class BrandsPartWidget extends StatelessWidget {
  final List<BrandModel> brands;
  final int selectedBrandIndex;

  const BrandsPartWidget({
    Key? key,
    required this.brands,
    required this.selectedBrandIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BrandsListWidget(
          brands: brands,
          selectedBrandIndex: selectedBrandIndex,
        ),
      ],
    );
  }
}
