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
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/customer_profile_appbar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_profile/customer_profile_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_profile/widgets/birth_town_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_profile/widgets/info_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_profile/widgets/notes_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_profile/widgets/question_properties_widget.dart';

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
            final CustomerInfo? customerInfo = context.select(
                (CustomerProfileCubit cubit) => cubit.state.customerInfo);

            return Scaffold(
              appBar: CustomerProfileAppBar(
                title: customerInfo != null
                    ? '${customerInfo.firstName} ${customerInfo.lastName}'
                    : '',
                zodiac: customerInfo?.zodiac?.imagePath(context),
              ),
              body: SingleChildScrollView(child: Builder(builder: (context) {
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
                                  QuestionPropertiesWidget(
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
