import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_icons.dart';
import 'package:shared_advisor_interface/presentation/resources/app_images.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Get.statusBarHeight + 8.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.buttonRadius),
          topRight: Radius.circular(AppConstants.buttonRadius),
        ),
        child: Scaffold(
          appBar: SimpleAppBar(
            title: S.of(context).allOurBrands,
            backIcon: AppIcons.close,
          ),
          backgroundColor: Get.theme.canvasColor,
          body: Column(
            children: [
              Divider(
                height: 1.0,
                color: Get.theme.hintColor,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.horizontalScreenPadding),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0, bottom: 12.0),
                              child: Text(
                                S.of(context).ingenio,
                                style: Get.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              S
                                  .of(context)
                                  .wePrideOurselvesToOfferAdvisorsASafePlaceTo,
                              style: Get.textTheme.bodyMedium
                                  ?.copyWith(color: Get.iconColor),
                            ),
                          ],
                        ),
                      ),
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                          mainAxisExtent: kToolbarHeight,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(
                            AppConstants.horizontalScreenPadding),
                        itemCount: AppImages.brands.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: kToolbarHeight,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    AppConstants.buttonRadius),
                                color: Get.theme.backgroundColor,
                                border: Border.all(
                                  color: Get.theme.hintColor,
                                ),
                                image: DecorationImage(
                                    image:
                                        AssetImage(AppImages.brands[index]))),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
