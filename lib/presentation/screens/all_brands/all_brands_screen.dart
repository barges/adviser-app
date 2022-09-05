import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_images.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).allOurBrands,
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalScreenPadding),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
                    child: Text(
                      'Ingenio',
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    S.of(context).wePrideOurselvesToOfferAdvisorsASafePlaceTo,
                    style: Get.textTheme.bodyMedium
                        ?.copyWith(color: Get.iconColor),
                  ),
                ],
              ),
            ),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                mainAxisExtent: kToolbarHeight,
              ),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding:
                  const EdgeInsets.all(AppConstants.horizontalScreenPadding),
              itemCount: AppImages.brands.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: kToolbarHeight,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppConstants.buttonRadius),
                      color: Get.theme.backgroundColor,
                      image: DecorationImage(
                          image: AssetImage(AppImages.brands[index]))),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
