import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/data/models/user_info/brand_model.dart';
import 'package:zodiac/generated/l10n.dart';

class BrandsListWidget extends StatelessWidget {
  final List<BrandModel> brands;
  final int selectedBrandIndex;
  const BrandsListWidget({
    Key? key,
    required this.brands,
    required this.selectedBrandIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(
            width: AppConstants.horizontalScreenPadding,
          ),
          ...brands.mapIndexed((index, element) => Padding(
                padding: EdgeInsets.only(
                  right: index != brands.length - 1 ? 8.0 : 0,
                ),
                child: _BrandWidget(
                  isSelected: selectedBrandIndex == index,
                  name: element.name,
                  isMain: element.isMain,
                ),
              )),
          const SizedBox(
            width: AppConstants.horizontalScreenPadding,
          )
        ],
      ),
    );
  }
}

class _BrandWidget extends StatelessWidget {
  final String? name;
  final bool? isMain;
  final bool isSelected;

  const _BrandWidget({
    Key? key,
    required this.isSelected,
    this.name,
    this.isMain = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 9.0,
        horizontal: 24.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: isSelected ? theme.primaryColorLight : theme.canvasColor,
      ),
      child: Row(
        children: [
          Text(
            name ?? '',
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 15.0,
              color: isSelected ? theme.primaryColor : theme.hoverColor,
            ),
          ),
          if (isMain == true)
            Padding(
              padding: const EdgeInsets.only(
                left: 4.0,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 2.0,
                  horizontal: 6.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: theme.scaffoldBackgroundColor,
                ),
                child: Text(
                  SZodiac.of(context).mainZodiac.toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontSize: 12.0,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
