import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/customer_info/customer_info.dart';
import 'package:shared_advisor_interface/data/models/enums/zodiac_sign.dart';
import 'package:shared_advisor_interface/data/network/responses/get_note_response.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_profile/customer_profile_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_profile/widgets/notes_widget.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => CustomerProfileCubit(),
        child: Builder(
          builder: (context) {
            final CustomerProfileCubit userProfileCubit =
                context.read<CustomerProfileCubit>();
            return Scaffold(
              backgroundColor: Theme.of(context).canvasColor,
              appBar: WideAppBar(
                bottomWidget: Text(
                  S.of(context).customerProfile,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                topRightWidget: Builder(
                  builder: (context) {
                    final bool isFavorite = context.select(
                      (CustomerProfileCubit cubit) => cubit.state.isFavorite,
                    );
                    return AppIconButton(
                      icon: isFavorite
                          ? Assets.vectors.filledFavourite.path
                          : Assets.vectors.favourite.path,
                      onTap: userProfileCubit.updateIsFavorite,
                    );
                  },
                ),
              ),
              body: SingleChildScrollView(child: Builder(builder: (context) {
                final CustomerInfo? customerInfo = context.select(
                    (CustomerProfileCubit cubit) => cubit.state.response);
                return (customerInfo == null)
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          Ink(
                            color: Theme.of(context).canvasColor,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal:
                                    AppConstants.horizontalScreenPadding,
                                vertical: 24.0),
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    SvgPicture.asset(
                                        customerInfo.zodiac
                                                ?.imagePath(context) ??
                                            '',
                                        width: 96.0),
                                    // Container(
                                    //   padding: const EdgeInsets.symmetric(
                                    //       vertical: 2.0, horizontal: 8.0),
                                    //   decoration: BoxDecoration(
                                    //     color: AppColors.promotion,
                                    //     borderRadius: BorderRadius.circular(
                                    //       AppConstants.buttonRadius,
                                    //     ),
                                    //   ),
                                    //   child: Text(
                                    //     S.of(context).topSpender,
                                    //     style: Theme.of(context)
                                    //         .textTheme
                                    //         .labelSmall
                                    //         ?.copyWith(
                                    //           fontWeight: FontWeight.w700,
                                    //           color: AppColors.white,
                                    //         ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          AppConstants.horizontalScreenPadding),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12.0,
                                        ),
                                        child: Text(
                                          '${customerInfo.firstName ?? ''} ${customerInfo.lastName ?? ''}',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                        ),
                                      ),
                                      Text(
                                        '${S.of(context).born} ${(customerInfo.birthdate ?? '').parseDateTimePattern3}, ${customerInfo.gender ?? ''}, ${customerInfo.countryFullName ?? ''}',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color:
                                                  Theme.of(context).shadowColor,
                                            ),
                                      ),
                                      Text(
                                        '${customerInfo.totalMessages ?? 0} ${S.of(context).chats.toLowerCase()}, 5 ${S.of(context).calls.toLowerCase()}, 5 ${S.of(context).services.toLowerCase()}',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color:
                                                  Theme.of(context).shadowColor,
                                            ),
                                      ),
                                    ],
                                  )),
                              const SizedBox(
                                  height: AppConstants.horizontalScreenPadding),
                              Wrap(
                                runSpacing: 8.0,
                                children: [
                                  Row(
                                    children: [
                                      _InfoWidget(
                                        title: S.of(context).zodiacSign,
                                        info: SvgPicture.asset(
                                            customerInfo.zodiac?.iconPath ??
                                                ''),
                                      ),
                                      const SizedBox(width: 8.0),
                                      _InfoWidget(
                                        title: S.of(context).numerology,
                                        info: Text('2',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium
                                                ?.copyWith(
                                                    color: Get
                                                        .theme.primaryColor)),
                                      ),
                                      const SizedBox(width: 8.0),
                                      _InfoWidget(
                                        title: S.of(context).ascendant,
                                        info: SvgPicture.asset(
                                            ZodiacSign.cancer.iconPath),
                                      ),
                                    ],
                                  ),
                                  const _BirthTownWidget(
                                    address: 'Preston Rd. Inglewood, Maine',
                                  ),
                                  _QuestionPropertiesWidget(
                                    properties: customerInfo
                                            .advisorMatch?.values
                                            .toList() ??
                                        const [],
                                  ),
                                ],
                              ),
                            ]),
                          ),
                          Builder(builder: (context) {
                            final GetNoteResponse? currentNote = context.select(
                                (CustomerProfileCubit cubit) =>
                                    cubit.state.currentNote);
                            return NotesWidget(
                              onTapAddNew: userProfileCubit
                                  .navigateToAddNoteScreenForNewNote,
                              onTapOldNote: userProfileCubit
                                  .navigateToAddNoteScreenForOldNote,
                              notes: (currentNote?.content == "" ||
                                      currentNote == null)
                                  ? []
                                  : [currentNote],
                              images: const [
                                [
                                  //'https://cdn.shopify.com/s/files/1/0275/3318/0970/products/AgendaNotebook-2_800x.jpg'
                                ],
                              ],
                            );
                          })
                        ],
                      );
              })),
            );
          },
        ));
  }
}

class _InfoWidget extends StatelessWidget {
  final String title;
  final Widget info;

  const _InfoWidget({Key? key, required this.title, required this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          border: Border.all(
            color: Theme.of(context).hintColor,
          ),
        ),
        child: Column(children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).shadowColor,
                ),
          ),
          const SizedBox(height: 8.0),
          info
        ]),
      ),
    );
  }
}

class _BirthTownWidget extends StatelessWidget {
  final String address;

  const _BirthTownWidget({Key? key, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 12.0, horizontal: AppConstants.horizontalScreenPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        border: Border.all(
          color: Theme.of(context).hintColor,
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          S.of(context).birthTown.toUpperCase(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w400,
                color: Theme.of(context).shadowColor,
              ),
        ),
        const SizedBox(height: 10.0),
        _IconAndTitleWidget(
          iconPath: Assets.vectors.location.path,
          title: address,
        ),
      ]),
    );
  }
}

class _QuestionPropertiesWidget extends StatelessWidget {
  final List<String> properties;

  const _QuestionPropertiesWidget({Key? key, required this.properties})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 12.0, horizontal: AppConstants.horizontalScreenPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        border: Border.all(
          color: Theme.of(context).hintColor,
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          S.of(context).questionProperties.toUpperCase(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w400,
                color: Theme.of(context).shadowColor,
              ),
        ),
        const SizedBox(height: 10.0),
        ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) => Text(
                  properties[index],
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
            separatorBuilder: (_, __) => const SizedBox(height: 12.0),
            itemCount: properties.length)
      ]),
    );
  }
}

class _IconAndTitleWidget extends StatelessWidget {
  final String iconPath;
  final String title;

  const _IconAndTitleWidget(
      {Key? key, required this.iconPath, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(iconPath),
        const SizedBox(width: 4.0),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .displayLarge
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
