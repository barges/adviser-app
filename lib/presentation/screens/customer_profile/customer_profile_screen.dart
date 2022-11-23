import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/data/models/customer_info/customer_info.dart';
import 'package:shared_advisor_interface/data/models/enums/zodiac_sign.dart';
import 'package:shared_advisor_interface/data/network/responses/get_note_response.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/customer_profile_appbar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_profile/customer_profile_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_profile/widgets/notes_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_profile/widgets/question_properties_widget.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

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
            final ThemeData theme = Theme.of(context);
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
                            color: theme.canvasColor,
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
                                    //     style: theme
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
                                          style: theme.textTheme.headlineMedium,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            (customerInfo.birthdate ?? '')
                                                .parseDateTimePattern9,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: theme.shadowColor,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8.0,
                                          ),
                                          Container(
                                            width: 4.0,
                                            height: 4.0,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(90.0),
                                                color: theme.hintColor),
                                          ),
                                          const SizedBox(
                                            width: 8.0,
                                          ),
                                          Text(
                                            toBeginningOfSentenceCase(
                                                    customerInfo.gender) ??
                                                '',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: theme.shadowColor,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )),
                              const SizedBox(
                                  height: AppConstants.horizontalScreenPadding),
                              Builder(builder: (context) {
                                final List<String>? questionProperties =
                                    customerInfo.advisorMatch?.values.toList();
                                return Wrap(
                                  runSpacing: 8.0,
                                  children: [
                                    (questionProperties != null &&
                                            questionProperties.isNotEmpty)
                                        ? QuestionPropertiesWidget(
                                            properties: questionProperties,
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                );
                              }),
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
