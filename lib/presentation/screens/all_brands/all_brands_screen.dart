import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WideAppBar(
        title: S.of(context).allOurBrands,
      ),
      backgroundColor: Get.theme.canvasColor,
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
                      S.of(context).ingenio,
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
              itemCount: BrandExtension.allBrands.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: kToolbarHeight,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppConstants.buttonRadius),
                    color: Get.theme.backgroundColor,
                    border: Border.all(
                      color: Get.theme.hintColor,
                    ),
                    image: DecorationImage(
                      image: AssetImage(
                        BrandExtension.allBrands[index],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
